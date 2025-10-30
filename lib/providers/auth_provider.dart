import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

// Auth state provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseService().authStateChanges;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

class AuthService {
  final _supabase = SupabaseService();

  Future<void> signUp(String email, String password) async {
    final response = await _supabase.signUp(email, password);
    if (response.user == null) {
      throw Exception('Sign up failed');
    }
  }

  Future<void> signIn(String email, String password) async {
    final response = await _supabase.signIn(email, password);
    if (response.user == null) {
      throw Exception('Sign in failed');
    }
  }

  Future<void> signOut() async {
    await _supabase.signOut();
  }
}
