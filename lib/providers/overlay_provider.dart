import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

// Overlay enabled state provider
final overlayEnabledProvider =
    StateNotifierProvider<OverlayEnabledNotifier, bool>((ref) {
      return OverlayEnabledNotifier();
    });

class OverlayEnabledNotifier extends StateNotifier<bool> {
  static const String _key = 'overlay_enabled';
  static const String _screenWidthKey = 'screen_width';
  static const String _screenHeightKey = 'screen_height';

  OverlayEnabledNotifier() : super(false) {
    _loadState();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_key) ?? false;
  }

  // Save screen dimensions for overlay to use
  static Future<void> saveScreenDimensions(Size screenSize) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_screenWidthKey, screenSize.width);
    await prefs.setDouble(_screenHeightKey, screenSize.height);
  }

  Future<void> toggle({Size? screenSize}) async {
    final newState = !state;

    if (newState) {
      // IMPORTANT: Save screen dimensions FIRST, before showing overlay
      if (screenSize != null) {
        await saveScreenDimensions(screenSize);
      } else {
        // If no screen size provided, try to get it from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final savedWidth = prefs.getDouble(_screenWidthKey);
        final savedHeight = prefs.getDouble(_screenHeightKey);

        // If dimensions aren't saved yet, we can't show overlay properly
        if (savedWidth == null || savedHeight == null || savedWidth <= 0 || savedHeight <= 0) {
          // Don't show overlay without valid dimensions
          return;
        }
      }

      // Request permission and show overlay
      final hasPermission = await FlutterOverlayWindow.isPermissionGranted();
      if (!hasPermission) {
        final granted = await FlutterOverlayWindow.requestPermission() ?? false;
        if (!granted) {
          // Permission denied, don't change state
          return;
        }
      }

      // Show overlay in collapsed state at center-right
      await FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        height: 80,
        width: 80,
        alignment: OverlayAlignment.centerRight,
        positionGravity: PositionGravity.none,
      );

      // Update state after successful show
      state = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, true);
    } else {
      // Hide overlay
      await FlutterOverlayWindow.closeOverlay();

      // Update state after successful close
      state = false;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, false);
    }
  }

  Future<void> setEnabled(bool enabled) async {
    state = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, enabled);
  }

  Future<void> show() async {
    if (!state) {
      await toggle();
    }
  }

  Future<void> hide() async {
    if (state) {
      await toggle();
    }
  }
}
