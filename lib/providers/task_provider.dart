import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../services/supabase_service.dart';

// Task list provider
final taskListProvider = StateNotifierProvider<TaskListNotifier, AsyncValue<List<Task>>>((ref) {
  return TaskListNotifier();
});

class TaskListNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final _supabase = SupabaseService();

  TaskListNotifier() : super(const AsyncValue.loading()) {
    loadTasks();
    _subscribeToChanges();
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      final tasks = await _supabase.getTasks();
      state = AsyncValue.data(tasks);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void _subscribeToChanges() {
    _supabase.subscribeToTasks((tasks) {
      state = AsyncValue.data(tasks);
    });
  }

  Future<void> addTask(String text) async {
    try {
      await _supabase.createTask(text);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleTask(String taskId, bool completed) async {
    try {
      await _supabase.updateTask(taskId, completed: completed);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _supabase.deleteTask(taskId);
      await loadTasks();
    } catch (e) {
      rethrow;
    }
  }
}
