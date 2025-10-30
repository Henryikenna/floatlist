# FloatList

A beautiful Android task management app with a system-wide floating overlay. Never lose track of your tasks, even when using other apps!

## Features

- **System-Wide Floating Overlay**: Access your tasks from any app with a draggable floating button
- **Beautiful UI**: Purple-themed interface with smooth animations
- **Real-time Sync**: Tasks sync in real-time across the app and overlay using Supabase
- **Simple Task Management**: Add, complete, and delete tasks with ease
- **Auto-Start on Boot**: Overlay can automatically start when your device boots
- **Secure Authentication**: Email/password authentication powered by Supabase



## Usage

### First Time Setup

1. Launch the app
2. Create an account by tapping "Don't have an account? Sign Up"
3. Enter your email and password (minimum 6 characters)
4. After signing up, sign in with your credentials

### Managing Tasks

1. Tap the **+** button to add a new task
2. Tap the checkbox to mark tasks as complete
3. Swipe left on a task to delete it

### Using the Floating Overlay

1. Toggle the "Floating Overlay" switch in the main app
2. Grant the "Display over other apps" permission when prompted
3. The floating button will appear on your screen
4. Tap the button to expand and see your tasks
5. Add or complete tasks directly from the overlay
6. Tap the close icon to collapse back to the floating button
7. The overlay persists even when you switch to other apps!

### Auto-Start on Boot

Once you enable the overlay, it will automatically start when your device boots up (as long as it's still enabled in settings).

## Architecture

- **State Management**: Riverpod
- **Backend**: Supabase (PostgreSQL + Real-time)
- **Overlay**: flutter_overlay_window (Android only)
- **UI**: Material Design 3 with custom theme



## Technologies Used

- **Flutter**: Cross-platform UI framework
- **Riverpod**: State management
- **Supabase**: Backend-as-a-Service
  - PostgreSQL database
  - Authentication
  - Real-time subscriptions
  - Row Level Security (RLS)
- **flutter_overlay_window**: System-wide overlay functionality
- **shared_preferences**: Local settings persistence

## Color Scheme

- **Primary**: Vibrant Purple (#7C3AED)
- **Secondary**: Teal/Cyan (#14B8A6)
- **Background**: Light neutrals

## Known Limitations

- Android only (iOS doesn't support system-wide overlays)
- Requires internet connection (no offline mode)
- Overlay requires "Display over other apps" permission

## Troubleshooting

### App crashes on startup
- Verify your internet connection

### Overlay doesn't show
- Grant "Display over other apps" permission in Android settings
- Make sure the overlay toggle is ON in the app
- Try restarting the app

### Tasks don't sync
- Check internet connection
- Verify Supabase credentials are correct
- Check Supabase dashboard to see if database is running

## License

This project is open source and available for personal and educational use.

## Support

If you encounter any issues, please check the troubleshooting section above or review the code comments for implementation details.
