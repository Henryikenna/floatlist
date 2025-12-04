import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/supabase_service.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'overlay/overlay_main.dart' as overlay;

@pragma("vm:entry-point")
void overlayMain() {
  overlay.overlayMain();
}

// === MethodChannel used by BootService to notify Dart ===
const _bootChannel = MethodChannel('com.floatlist.app/boot');
const _screenChannel = MethodChannel('com.floatlist.app/screen');

void _setupBootChannel() {
  _bootChannel.setMethodCallHandler((call) async {
    if (call.method == 'onBootCompleted') {
      // Check if permission is granted
      final canDraw = await FlutterOverlayWindow.isPermissionGranted();
      if (!canDraw) {
        return;
      }

      // Note: Screen dimensions will be saved by overlayMain() when the overlay window starts
      // No need to save them here as the overlay process will handle it

      // Show overlay in collapsed state at center-right
      await FlutterOverlayWindow.showOverlay(
        enableDrag: true,
        height: 80,
        width: 80,
        alignment: OverlayAlignment.centerRight,
        positionGravity: PositionGravity.none,
        flag: OverlayFlag.focusPointer,
      );
    }
    return;
  });
}

Future<void> _saveScreenDimensions() async {
  try {
    final result = await _screenChannel.invokeMethod('getScreenSize');
    if (result != null && result is Map) {
      final width = result['width'] as double;
      final height = result['height'] as double;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('screen_width', width);
      await prefs.setDouble('screen_height', height);
    }
  } catch (e) {
    debugPrint('Error getting screen size: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  // Initialize Supabase
  await SupabaseService.initialize();

  // Save screen dimensions from native platform
  await _saveScreenDimensions();

  _setupBootChannel();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Float List',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: authState.when(
        data: (state) {
          if (state.session != null) {
            return const HomeScreen();
          }
          return const AuthScreen();
        },
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, stack) =>
            Scaffold(body: Center(child: Text('Error: $error'))),
      ),
    );
  }
}
