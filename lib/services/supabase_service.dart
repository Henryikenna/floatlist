import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';
import 'supabase_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  // Initialize Supabase
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
    );
  }

  // Auth methods
  Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  User? get currentUser => client.auth.currentUser;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Task methods
  Future<List<Task>> getTasks() async {
    final response = await client
        .from('tasks')
        .select()
        .eq('user_id', currentUser!.id)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Task.fromJson(json)).toList();
  }

  Future<Task> createTask(String text) async {
    final response = await client
        .from('tasks')
        .insert({
          'user_id': currentUser!.id,
          'text': text,
          'completed': false,
        })
        .select()
        .single();

    return Task.fromJson(response);
  }

  Future<void> updateTask(String taskId, {String? text, bool? completed}) async {
    final updates = <String, dynamic>{};
    if (text != null) updates['text'] = text;
    if (completed != null) updates['completed'] = completed;

    await client.from('tasks').update(updates).eq('id', taskId);
  }

  Future<void> deleteTask(String taskId) async {
    await client.from('tasks').delete().eq('id', taskId);
  }

  // Real-time subscription
  RealtimeChannel subscribeToTasks(void Function(List<Task>) onData) {
    return client
        .channel('tasks_channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'tasks',
          callback: (payload) async {
            // Fetch updated tasks
            final tasks = await getTasks();
            onData(tasks);
          },
        )
        .subscribe();
  }
}
