import 'package:floatlist/utils/opacity_factor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class TaskItem extends ConsumerStatefulWidget {
  final Task task;

  const TaskItem({super.key, required this.task});

  @override
  ConsumerState<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends ConsumerState<TaskItem> {
  bool _isLoading = false;

  Future<void> _handleToggle(bool? value) async {
    if (_isLoading) return; // Prevent multiple clicks

    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(taskListProvider.notifier)
          .toggleTask(widget.task.id, value ?? false);
    } catch (e) {
      if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update task: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    // If today, show time
    if (difference.inDays == 0) {
      return 'Today at ${DateFormat('h:mm a').format(dateTime)}';
    }
    // If yesterday
    else if (difference.inDays == 1) {
      return 'Yesterday at ${DateFormat('h:mm a').format(dateTime)}';
    }
    // If within the last week
    else if (difference.inDays < 7) {
      return '${DateFormat('EEEE').format(dateTime)} at ${DateFormat('h:mm a').format(dateTime)}';
    }
    // Otherwise show full date
    else {
      return DateFormat('MMM d, y • h:mm a').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.task.id),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        ref.read(taskListProvider.notifier).deleteTask(widget.task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Task deleted'),
            // action: SnackBarAction(
            //   label: 'Undo',
            //   onPressed: () {
            //     // Note: Undo would require keeping deleted tasks in memory
            //     // For simplicity, we're not implementing it here
            //   },
            // ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          horizontalTitleGap: 3,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 10,
          ),
          // leading: Checkbox(
          //   value: task.completed,
          //   onChanged: (value) {
          //     ref.read(taskListProvider.notifier).toggleTask(
          //           task.id,
          //           value ?? false,
          //         );
          //   },
          // ),
          leading: _isLoading
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                )
              : Transform.scale(
                  scale: 1.1,
                  child: Checkbox(
                    value: widget.task.completed,
                    onChanged: _handleToggle,
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: WidgetStateBorderSide.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return const BorderSide(
                          width: 0,
                          color: Colors.transparent,
                        );
                      } else {
                        return const BorderSide(
                          width: 1.5,
                          color: AppTheme.textSecondary,
                        );
                      }
                    }),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task.text,
                style: TextStyle(
                  decoration: widget.task.completed
                      ? TextDecoration.lineThrough
                      : null,
                  color: widget.task.completed
                      ? AppTheme.textSecondary
                      : AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatDateTime(widget.task.createdAt),
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary.withOpacityFactor(0.8),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.drag_handle,
            color: AppTheme.textSecondary.withOpacityFactor(0.3),
          ),
        ),
      ),
    );
  }
}
