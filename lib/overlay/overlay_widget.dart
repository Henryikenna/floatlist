// import 'package:floatlist/utils/opacity_factor.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/task_provider.dart';
// import '../theme/app_theme.dart';

// class OverlayWidget extends ConsumerStatefulWidget {
//   const OverlayWidget({super.key});

//   @override
//   ConsumerState<OverlayWidget> createState() => _OverlayWidgetState();
// }

// class _OverlayWidgetState extends ConsumerState<OverlayWidget>
//     with SingleTickerProviderStateMixin {
//   bool _isExpanded = false;
//   late AnimationController _animationController;
//   late Animation<double> _expandAnimation;
//   final _textController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _expandAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _textController.dispose();
//     super.dispose();
//   }

//   void _toggleExpand() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//     });
//   }

//   void _addTask() {
//     if (_textController.text.trim().isEmpty) return;
//     ref.read(taskListProvider.notifier).addTask(_textController.text.trim());
//     _textController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tasks = ref.watch(taskListProvider);

//     return Material(
//       color: Colors.transparent,
//       child: GestureDetector(
//         onTap: _isExpanded ? null : _toggleExpand,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           width: _isExpanded ? 300 : 56,
//           height: _isExpanded ? 400 : 56,
//           decoration: BoxDecoration(
//             color: _isExpanded ? Colors.white : AppTheme.primaryPurple,
//             borderRadius: BorderRadius.circular(_isExpanded ? 16 : 28),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacityFactor(0.2),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: _isExpanded ? _buildExpandedView() : _buildCollapsedView(),
//         ),
//       ),
//     );
//   }

//   Widget _buildCollapsedView() {
//     return const Center(
//       child: Icon(
//         Icons.check_circle,
//         color: Colors.white,
//         size: 32,
//       ),
//     );
//   }

//   Widget _buildExpandedView() {
//     final tasks = ref.watch(taskListProvider);

//     return Column(
//       children: [
//         // Header
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppTheme.primaryPurple,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(16),
//               topRight: Radius.circular(16),
//             ),
//           ),
//           child: Row(
//             children: [
//               const Icon(
//                 Icons.check_circle,
//                 color: Colors.white,
//                 size: 24,
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 'FloatList',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Spacer(),
//               IconButton(
//                 icon: const Icon(Icons.close, color: Colors.white, size: 20),
//                 onPressed: _toggleExpand,
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//               ),
//             ],
//           ),
//         ),

//         // Add task input
//         Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _textController,
//                   decoration: InputDecoration(
//                     hintText: 'Add task...',
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                   ),
//                   onSubmitted: (_) => _addTask(),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 decoration: BoxDecoration(
//                   color: AppTheme.secondaryTeal,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: IconButton(
//                   icon: const Icon(Icons.add, color: Colors.white),
//                   onPressed: _addTask,
//                   padding: const EdgeInsets.all(8),
//                   constraints: const BoxConstraints(),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Task list
//         Expanded(
//           child: tasks.when(
//             data: (taskList) {
//               if (taskList.isEmpty) {
//                 return Center(
//                   child: Text(
//                     'No tasks',
//                     style: TextStyle(
//                       color: AppTheme.textSecondary,
//                       fontSize: 14,
//                     ),
//                   ),
//                 );
//               }

//               return ListView.builder(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 itemCount: taskList.length,
//                 itemBuilder: (context, index) {
//                   final task = taskList[index];
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: ListTile(
//                       dense: true,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 0,
//                       ),
//                       leading: Checkbox(
//                         value: task.completed,
//                         onChanged: (value) {
//                           ref.read(taskListProvider.notifier).toggleTask(
//                                 task.id,
//                                 value ?? false,
//                               );
//                         },
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                       ),
//                       title: Text(
//                         task.text,
//                         style: TextStyle(
//                           decoration: task.completed
//                               ? TextDecoration.lineThrough
//                               : null,
//                           color: task.completed
//                               ? AppTheme.textSecondary
//                               : AppTheme.textPrimary,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//             loading: () => const Center(
//               child: CircularProgressIndicator(),
//             ),
//             error: (error, stack) => Center(
//               child: Text(
//                 'Error loading tasks',
//                 style: TextStyle(
//                   color: Colors.red[300],
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:floatlist/utils/opacity_factor.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
// import '../providers/task_provider.dart';
// import '../theme/app_theme.dart';

// class OverlayWidget extends ConsumerStatefulWidget {
//   const OverlayWidget({super.key});

//   @override
//   ConsumerState<OverlayWidget> createState() => _OverlayWidgetState();
// }

// class _OverlayWidgetState extends ConsumerState<OverlayWidget>
//     with SingleTickerProviderStateMixin {
//   bool _isExpanded = false;
//   late AnimationController _animationController;
//   late Animation<double> _expandAnimation;
//   final _textController = TextEditingController();

//   // Positioning state
//   Offset _currentPosition = Offset.zero;
//   Offset _dragStart = Offset.zero;
//   bool _isDragging = false;
//   Size _screenSize = Size.zero;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//     _expandAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutBack,
//     );

//     _initializePosition();
//   }

//   Future<void> _initializePosition() async {
//     // Wait for first frame to get screen size
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final size = MediaQuery.of(context).size;
//       setState(() {
//         _screenSize = size;
//       });

//       // Set initial position to center-right
//       await _moveToDefaultPosition();
//     });
//   }

//   Future<void> _moveToDefaultPosition() async {
//     if (_screenSize.width == 0) return;

//     final centerY = (_screenSize.height / 2).toInt();
//     // final rightX = (_screenSize.width - 56).toInt(); // 56 = collapsed width
//     // final rightX = (_screenSize.width - 56); // 56 = collapsed width
//     final rightX = (_screenSize.width - 200); // 200 = collapsed width

//     await FlutterOverlayWindow.moveOverlay(
//       OverlayPosition(rightX, centerY - 28), // -28 to center vertically
//     );

//     setState(() {
//       _currentPosition = Offset(rightX.toDouble(), (centerY - 28).toDouble());
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _textController.dispose();
//     super.dispose();
//   }

//   void _toggleExpand() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//       if (_isExpanded) {
//         _animationController.forward();
//         _expandToCenter();
//       } else {
//         _animationController.reverse().then((_) {
//           _moveToDefaultPosition();
//         });
//       }
//     });
//   }

//   Future<void> _expandToCenter() async {
//     if (_screenSize.width == 0) return;

//     // Calculate center position for expanded view
//     final centerX = (_screenSize.width / 2 - 150); // 150 = half of expanded width (300)
//     final currentY = _currentPosition.dy;

//     await FlutterOverlayWindow.moveOverlay(
//       OverlayPosition(centerX, currentY),
//     );

//     setState(() {
//       _currentPosition = Offset(centerX.toDouble(), currentY.toDouble());
//     });
//   }

//   void _onPanStart(DragStartDetails details) {
//     setState(() {
//       _isDragging = true;
//       _dragStart = details.globalPosition;
//     });
//   }

//   void _onPanUpdate(DragUpdateDetails details) {
//     if (!_isDragging) return;

//     final delta = details.globalPosition - _dragStart;
//     final newPosition = _currentPosition + delta;

//     FlutterOverlayWindow.moveOverlay(
//       OverlayPosition(newPosition.dx, newPosition.dy),
//     );

//     setState(() {
//       _currentPosition = newPosition;
//       _dragStart = details.globalPosition;
//     });
//   }

//   void _onPanEnd(DragEndDetails details) {
//     setState(() {
//       _isDragging = false;
//     });

//     if (!_isExpanded) {
//       _snapToEdge();
//     }
//   }

//   Future<void> _snapToEdge() async {
//     if (_screenSize.width == 0) return;

//     final currentX = _currentPosition.dx;
//     final screenMidpoint = _screenSize.width / 2;

//     // Determine which edge is closer
//     double targetX;
//     if (currentX < screenMidpoint) {
//       // Snap to left edge
//       targetX = 0;
//     } else {
//       // Snap to right edge
//       // targetX = (_screenSize.width - 56); // 56 = collapsed width
//       targetX = (_screenSize.width - 200); // 200 = collapsed width
//     }

//     await FlutterOverlayWindow.moveOverlay(
//       OverlayPosition(targetX, _currentPosition.dy),
//     );

//     setState(() {
//       _currentPosition = Offset(targetX.toDouble(), _currentPosition.dy);
//     });
//   }

//   void _addTask() {
//     if (_textController.text.trim().isEmpty) return;
//     ref.read(taskListProvider.notifier).addTask(_textController.text.trim());
//     _textController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final tasks = ref.watch(taskListProvider);

//     return Material(
//       color: Colors.transparent,
//       child: GestureDetector(
//         onTap: _isExpanded ? null : _toggleExpand,
//         onPanStart: _onPanStart,
//         onPanUpdate: _onPanUpdate,
//         onPanEnd: _onPanEnd,
//         child: AnimatedBuilder(
//           animation: _expandAnimation,
//           builder: (context, child) {
//             // final width = 56 + (244 * _expandAnimation.value); // 56 to 300
//             // final height = 56 + (344 * _expandAnimation.value); // 56 to 400
//             // final borderRadius = 28 - (12 * _expandAnimation.value); // 28 to 16
//             final width = 200 + (244 * _expandAnimation.value); // 200 to 300
//             final height = 200 + (344 * _expandAnimation.value); // 200 to 400
//             final borderRadius = 100 - (12 * _expandAnimation.value); // 100 to 16

//             return Container(
//               width: width,
//               height: height,
//               decoration: BoxDecoration(
//                 color: _isExpanded ? Colors.white : AppTheme.primaryPurple,
//                 borderRadius: BorderRadius.circular(borderRadius),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacityFactor(0.2),
//                     blurRadius: 10 + (5 * _expandAnimation.value),
//                     offset: Offset(0, 4 + (2 * _expandAnimation.value)),
//                   ),
//                 ],
//               ),
//               child: _isExpanded ? _buildExpandedView() : _buildCollapsedView(),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCollapsedView() {
//     return const Center(
//       child: Icon(
//         Icons.check_circle,
//         color: Colors.white,
//         size: 32,
//       ),
//     );
//   }

//   Widget _buildExpandedView() {
//     final tasks = ref.watch(taskListProvider);

//     return Column(
//             mainAxisSize: MainAxisSize.min,
//       children: [
//         // Header
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: AppTheme.primaryPurple,
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(
//                   Icons.check_circle,
//                   color: Colors.white,
//                   size: 24,
//                 ),
//                 const SizedBox(width: 8),
//                 const Text(
//                   'FloatList',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 // const Spacer(),
//                 IconButton(
//                   icon: const Icon(Icons.close, color: Colors.white, size: 20),
//                   onPressed: _toggleExpand,
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                 ),
//               ],
//             ),
//           ),
//         ),

//         // Add task input
//         Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _textController,
//                   decoration: InputDecoration(
//                     hintText: 'Add task...',
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: Colors.grey[300]!),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       borderSide: BorderSide(color: AppTheme.primaryPurple, width: 2),
//                     ),
//                   ),
//                   onSubmitted: (_) => _addTask(),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Container(
//                 decoration: BoxDecoration(
//                   color: AppTheme.secondaryTeal,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: IconButton(
//                   icon: const Icon(Icons.add, color: Colors.white),
//                   onPressed: _addTask,
//                   padding: const EdgeInsets.all(8),
//                   constraints: const BoxConstraints(),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Task list
//         Expanded(
//           child: tasks.when(
//             data: (taskList) {
//               if (taskList.isEmpty) {
//                 return Center(
//                   child: Text(
//                     'No tasks',
//                     style: TextStyle(
//                       color: AppTheme.textSecondary,
//                       fontSize: 14,
//                     ),
//                   ),
//                 );
//               }

//               return ListView.builder(
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 itemCount: taskList.length,
//                 itemBuilder: (context, index) {
//                   final task = taskList[index];
//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[50],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: ListTile(
//                       dense: true,
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 8,
//                         vertical: 0,
//                       ),
//                       leading: Checkbox(
//                         value: task.completed,
//                         onChanged: (value) {
//                           ref.read(taskListProvider.notifier).toggleTask(
//                                 task.id,
//                                 value ?? false,
//                               );
//                         },
//                         materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                         activeColor: AppTheme.secondaryTeal,
//                       ),
//                       title: Text(
//                         task.text,
//                         style: TextStyle(
//                           decoration: task.completed
//                               ? TextDecoration.lineThrough
//                               : null,
//                           color: task.completed
//                               ? AppTheme.textSecondary
//                               : AppTheme.textPrimary,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//             loading: () => const Center(
//               child: CircularProgressIndicator(),
//             ),
//             error: (error, stack) => Center(
//               child: Text(
//                 'Error loading tasks',
//                 style: TextStyle(
//                   color: Colors.red[300],
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:async';
import 'dart:developer';

import 'package:floatlist/utils/opacity_factor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class OverlayWidget extends ConsumerStatefulWidget {
  const OverlayWidget({super.key});

  @override
  ConsumerState<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends ConsumerState<OverlayWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  final _textController = TextEditingController();

  // Positioning state
  Offset _currentPosition = Offset.zero;
  bool _isDragging = false;
  Size _screenSize = Size.zero;

  // Auto-collapse timer
  Timer? _inactivityTimer;
  Timer? _dimensionRetryTimer;
  static const _inactivityDuration = Duration(
    seconds: 12,
  ); // Longer than Pico's 5 seconds

  // Focus node for text field
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    _initializePosition();
  }

  Future<void> _initializePosition() async {
    // Wait for first frame to get screen size from SharedPreferences
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadScreenDimensions();

      // If dimensions are still invalid, retry periodically
      if (_screenSize.width <= 0 || _screenSize.height <= 0) {
        _retryLoadingDimensions();
      } else {
        // Set initial position to center-right
        await _moveToDefaultPosition();
      }
    });
  }

  Future<void> _loadScreenDimensions() async {
    final prefs = await SharedPreferences.getInstance();
    final screenWidth = prefs.getDouble('screen_width') ?? 0.0;
    final screenHeight = prefs.getDouble('screen_height') ?? 0.0;

    final size = Size(screenWidth, screenHeight);
    log("Device screen size from prefs: $size");

    if (mounted) {
      setState(() {
        _screenSize = size;
      });
    }
  }

  void _retryLoadingDimensions() {
    // Retry loading dimensions every 500ms until valid
    _dimensionRetryTimer?.cancel();
    _dimensionRetryTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      await _loadScreenDimensions();

      if (_screenSize.width > 0 && _screenSize.height > 0) {
        timer.cancel();
        _dimensionRetryTimer = null;
        await _moveToDefaultPosition();
      } else if (timer.tick > 10) {
        // Stop after 5 seconds (10 attempts)
        timer.cancel();
        _dimensionRetryTimer = null;
        log("Failed to load screen dimensions after 5 seconds");
      }
    });
  }

  Future<void> _moveToDefaultPosition() async {
    if (_screenSize.width == 0) return;

    final centerY = (_screenSize.height / 2).toInt();
    final rightX = (_screenSize.width - 80); // 80 = collapsed width

    await FlutterOverlayWindow.moveOverlay(
      OverlayPosition(rightX, centerY - 40), // -40 to center vertically
    );

    setState(() {
      _currentPosition = Offset(rightX.toDouble(), (centerY - 40).toDouble());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    _inactivityTimer?.cancel();
    _dimensionRetryTimer?.cancel();
    super.dispose();
  }

  void _startInactivityTimer() {
    _inactivityTimer?.cancel();
    if (_isExpanded) {
      _inactivityTimer = Timer(_inactivityDuration, () {
        if (_isExpanded && mounted) {
          _toggleExpand();
        }
      });
    }
  }

  void _resetInactivityTimer() {
    if (_isExpanded) {
      _startInactivityTimer();
    }
  }

  void _toggleExpand() async {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
      await _expandToCenter();
      _startInactivityTimer();
    } else {
      _inactivityTimer?.cancel();
      await _animationController.reverse();
      await _collapseToEdge();
    }
  }

  Future<void> _expandToCenter() async {
    if (_screenSize.width == 0) return;

    final expandedWidth = (_screenSize.width * 0.6).toInt();
    final expandedHeight = (_screenSize.height * 0.7).toInt();

    log("$_screenSize");
    log("$expandedHeight");
    log("$expandedWidth");

    // Resize overlay window to expanded size
    await FlutterOverlayWindow.resizeOverlay(
      expandedWidth,
      expandedHeight,
      false,
    );

    // Calculate center position for expanded view
    final centerX = (_screenSize.width / 2 - expandedWidth / 2);
    final currentY = _currentPosition.dy;

    await FlutterOverlayWindow.moveOverlay(OverlayPosition(centerX, currentY));

    setState(() {
      _currentPosition = Offset(centerX.toDouble(), currentY.toDouble());
    });
  }

  Future<void> _collapseToEdge() async {
    if (_screenSize.width == 0) return;

    // Resize back to collapsed size
    await FlutterOverlayWindow.resizeOverlay(80, 80, false);

    // Always move back to center-right default position
    await _moveToDefaultPosition();
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;

    // Calculate new position based on delta
    final delta = details.delta;
    final newPosition = Offset(
      _currentPosition.dx + delta.dx,
      _currentPosition.dy + delta.dy,
    );

    // Move overlay to new position
    FlutterOverlayWindow.moveOverlay(
      OverlayPosition(newPosition.dx, newPosition.dy),
    );

    setState(() {
      _currentPosition = newPosition;
    });

    // Reset inactivity timer while dragging
    if (_isExpanded) {
      _resetInactivityTimer();
    }
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _isDragging = false;
    });

    if (!_isExpanded) {
      _snapToEdge();
    }
  }

  Future<void> _snapToEdge() async {
    if (_screenSize.width == 0) return;

    final currentX = _currentPosition.dx;
    final screenMidpoint = _screenSize.width / 2;

    // Determine which edge is closer
    double targetX;
    if (currentX < screenMidpoint) {
      // Snap to left edge
      targetX = 0;
    } else {
      // Snap to right edge
      targetX = (_screenSize.width - 80); // 80 = collapsed width
    }

    await FlutterOverlayWindow.moveOverlay(
      OverlayPosition(targetX, _currentPosition.dy),
    );

    setState(() {
      _currentPosition = Offset(targetX.toDouble(), _currentPosition.dy);
    });
  }

  void _addTask() {
    if (_textController.text.trim().isEmpty) return;
    ref.read(taskListProvider.notifier).addTask(_textController.text.trim());
    _textController.clear();
    _resetInactivityTimer(); // Reset timer on user interaction
  }

  @override
  Widget build(BuildContext context) {
    // Use stored screen size (actual device size, not overlay window size)
    // If screen size is invalid (0 or negative), don't render content yet
    if (_screenSize.width <= 0 || _screenSize.height <= 0) {
      return const Material(
        color: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final expandedWidth = _screenSize.width * 0.6; // 60% of screen width
    final expandedHeight = _screenSize.height * 0.7; // 70% of screen height

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        // Only add tap and drag to collapsed state
        onTap: _isExpanded ? null : _toggleExpand,
        onPanStart: _isExpanded ? null : _onPanStart,
        onPanUpdate: _isExpanded ? null : _onPanUpdate,
        onPanEnd: _isExpanded ? null : _onPanEnd,
        child: AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            final width = 80 + ((expandedWidth - 80) * _expandAnimation.value);
            final height =
                80 + ((expandedHeight - 80) * _expandAnimation.value);
            final borderRadius = 40 - (24 * _expandAnimation.value); // 40 to 16

            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: _isExpanded ? Colors.white : AppTheme.primaryPurple,
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacityFactor(0.2),
                    blurRadius: 10 + (5 * _expandAnimation.value),
                    offset: Offset(0, 4 + (2 * _expandAnimation.value)),
                  ),
                ],
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Only show expanded content when container is large enough
                  final showExpanded = constraints.maxWidth > 100;
                  return showExpanded && _isExpanded
                      ? _buildExpandedView()
                      : _buildCollapsedView();
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCollapsedView() {
    return const Center(
      child: Icon(Icons.check_circle, color: Colors.white, size: 32),
    );
  }

  Widget _buildExpandedView() {
    final tasks = ref.watch(taskListProvider);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Prevent column overflow
        children: [
          // Header - Only this part is draggable
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'FloatList',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 18),
                    onPressed: _toggleExpand,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),

          // Add task input
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    style: const TextStyle(fontSize: 14),
                    autofocus: false,
                    decoration: InputDecoration(
                      hintText: 'Add task...',
                      hintStyle: const TextStyle(fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppTheme.primaryPurple,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _addTask(),
                    onTap: () {
                      // Reset inactivity timer when user taps text field
                      _resetInactivityTimer();
                    },
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryTeal,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 18),
                    onPressed: _addTask,
                    padding: const EdgeInsets.all(6),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ),

          // Task list
          Expanded(
            child: tasks.when(
              data: (taskList) {
                if (taskList.isEmpty) {
                  return Center(
                    child: Text(
                      'No tasks',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  itemCount: taskList.length,
                  itemBuilder: (context, index) {
                    final task = taskList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        leading: Checkbox(
                          value: task.completed,
                          onChanged: (value) {
                            ref
                                .read(taskListProvider.notifier)
                                .toggleTask(task.id, value ?? false);
                            _resetInactivityTimer(); // Reset timer on interaction
                          },
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: AppTheme.secondaryTeal,
                        ),
                        title: Text(
                          task.text,
                          style: TextStyle(
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.completed
                                ? AppTheme.textSecondary
                                : AppTheme.textPrimary,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Error loading tasks',
                  style: TextStyle(color: Colors.red[300], fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
