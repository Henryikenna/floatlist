// import 'package:floatlist/utils/spacing.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/auth_provider.dart';
// import '../providers/task_provider.dart';
// import '../providers/overlay_provider.dart';
// import '../widgets/task_item.dart';
// import '../theme/app_theme.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final _textController = TextEditingController();

//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }

//   void _showAddTaskDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Add Task'),
//         content: TextField(
//           controller: _textController,
//           autofocus: true,
//           decoration: const InputDecoration(hintText: 'Enter task description'),
//           onSubmitted: (_) => _addTask(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               _textController.clear();
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(onPressed: _addTask, child: const Text('Add')),
//         ],
//       ),
//     );
//   }

//   void _addTask() {
//     if (_textController.text.trim().isEmpty) return;
//     ref.read(taskListProvider.notifier).addTask(_textController.text.trim());
//     _textController.clear();
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tasks = ref.watch(taskListProvider);
//     final overlayEnabled = ref.watch(overlayEnabledProvider);
//     final currentUser = ref.watch(currentUserProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('FloatList'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await ref.read(authServiceProvider).signOut();
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Overlay toggle card
//           Container(
//             margin: const EdgeInsets.all(16),
//             child: Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.picture_in_picture_alt,
//                       color: AppTheme.secondaryTeal,
//                       size: 32,
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Floating Overlay',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: AppTheme.textPrimary,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Show tasks on top of other apps',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: AppTheme.textSecondary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Switch(
//                       value: overlayEnabled,
//                       onChanged: (_) {
//                         ref.read(overlayEnabledProvider.notifier).toggle();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '• Tap on the checkbox to mark a task as done.',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: AppTheme.surfaceDark,
//                   ),
//                 ),
//                 4.spaceH,
//                 Text(
//                   '• Swipe a task to the left 🡐 to delete it.',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                     color: AppTheme.surfaceDark,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           24.spaceH,

//           // Tasks section
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Your Tasks',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: AppTheme.textPrimary,
//                   ),
//                 ),
//                 // const Spacer(),
//                 if (currentUser != null)
//                   Text(
//                     currentUser.email ?? '',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: AppTheme.textSecondary,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),

//           // Task list
//           Expanded(
//             child: tasks.when(
//               data: (taskList) {
//                 if (taskList.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.task_alt, size: 80, color: Colors.grey[300]),
//                         const SizedBox(height: 16),
//                         Text(
//                           'No tasks yet',
//                           style: TextStyle(
//                             fontSize: 18,
//                             color: AppTheme.textSecondary,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Tap + to add your first task',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: AppTheme.textSecondary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   itemCount: taskList.length,
//                   itemBuilder: (context, index) {
//                     final task = taskList[index];
//                     return TaskItem(task: task);
//                   },
//                 );
//               },
//               loading: () => const Center(child: CircularProgressIndicator()),
//               error: (error, stack) => Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Error loading tasks',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: AppTheme.textSecondary,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     TextButton(
//                       onPressed: () {
//                         ref.read(taskListProvider.notifier).loadTasks();
//                       },
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddTaskDialog,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

























import 'package:floatlist/utils/opacity_factor.dart';
import 'package:floatlist/utils/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../providers/overlay_provider.dart';
import '../widgets/task_item.dart';
import '../theme/app_theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Save screen dimensions immediately on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      OverlayEnabledNotifier.saveScreenDimensions(screenSize);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: _textController,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter task description'),
          onSubmitted: (_) => _addTask(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(onPressed: _addTask, child: const Text('Add')),
        ],
      ),
    );
  }

  void _addTask() {
    if (_textController.text.trim().isEmpty) return;
    ref.read(taskListProvider.notifier).addTask(_textController.text.trim());
    _textController.clear();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider);
    final overlayEnabled = ref.watch(overlayEnabledProvider);
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FloatList'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overlay toggle card
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: overlayEnabled
                    ? [
                        AppTheme.primaryPurple.withOpacityFactor(0.1),
                        AppTheme.secondaryTeal.withOpacityFactor(0.05),
                      ]
                    : [Colors.grey.shade50, Colors.grey.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: overlayEnabled
                    ? AppTheme.primaryPurple.withOpacityFactor(0.3)
                    : Colors.grey.shade200,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: overlayEnabled
                          ? AppTheme.primaryPurple
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.picture_in_picture_alt_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Floating Overlay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          overlayEnabled
                              ? 'Active on top of other apps'
                              : 'Show tasks on top of other apps',
                          style: TextStyle(
                            fontSize: 13,
                            color: overlayEnabled
                                ? AppTheme.primaryPurple
                                : AppTheme.textSecondary,
                            fontWeight: overlayEnabled
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: overlayEnabled,
                    onChanged: (_) {
                      final screenSize = MediaQuery.of(context).size;
                      ref.read(overlayEnabledProvider.notifier).toggle(
                        screenSize: screenSize,
                      );
                    },
                    activeThumbColor: AppTheme.secondaryTeal,
                    activeTrackColor: AppTheme.secondaryTeal.withOpacityFactor(0.5),
                  ),
                ],
              ),
            ),
          ),

          // Instructions
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Quick Tips',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '• Tap checkbox to mark tasks as done\n• Swipe left 🡐 to delete a task',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          24.spaceH,

          // Tasks section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Tasks',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (currentUser != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacityFactor(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      currentUser.email ?? '',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppTheme.primaryPurple,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Task list
          Expanded(
            child: tasks.when(
              data: (taskList) {
                if (taskList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryPurple.withOpacityFactor(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.task_alt_rounded,
                            size: 64,
                            color: AppTheme.primaryPurple.withOpacityFactor(0.4),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No tasks yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add your first task',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final task = taskList[index];
                    return TaskItem(task: task);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: Colors.red.shade400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading tasks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(taskListProvider.notifier).loadTasks();
                      },
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        backgroundColor: AppTheme.primaryPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}