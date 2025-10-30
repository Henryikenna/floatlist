import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import '../services/supabase_service.dart';
import '../theme/app_theme.dart';
import 'overlay_widget.dart';

@pragma("vm:entry-point")
void overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get screen dimensions from platform
  // Note: In overlay context, we need to save dimensions from main app
  // This will run after main app has saved the dimensions, or use fallback

  runApp(const ProviderScope(child: OverlayApp()));
}

class OverlayApp extends StatefulWidget {
  const OverlayApp({super.key});

  @override
  State<OverlayApp> createState() => _OverlayAppState();
}

class _OverlayAppState extends State<OverlayApp> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await dotenv.load(fileName: ".env");
      
      final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

      // await SupabaseService.initialize();
      await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing overlay: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: _isInitialized
            ? const OverlayWidget()
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
