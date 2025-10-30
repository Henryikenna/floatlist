package com.floatlist.app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class BootService : Service() {

  private var engine: FlutterEngine? = null

  override fun onCreate() {
    super.onCreate()
    createNotifChannel()
    val notif = Notification.Builder(this, "boot_overlay")
      .setContentTitle("Floatlist")
      .setContentText("Preparing overlay")
      .setSmallIcon(android.R.drawable.stat_notify_more)
      .build()
    startForeground(1001, notif)

    engine = FlutterEngine(applicationContext).apply {
      dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
    }

    // Notify Dart
    MethodChannel(engine!!.dartExecutor.binaryMessenger, "com.floatlist.app/boot")
      .invokeMethod("onBootCompleted", null, object : MethodChannel.Result {
        override fun success(result: Any?) {
          stopSelf()
        }
        override fun error(code: String, msg: String?, details: Any?) {
          Log.e("BootService", "Channel error: $code $msg")
          stopSelf()
        }
        override fun notImplemented() {
          Log.e("BootService", "Method not implemented in Dart")
          stopSelf()
        }
      })
  }

  override fun onBind(intent: Intent?): IBinder? = null

  override fun onDestroy() {
    engine?.destroy()
    engine = null
    super.onDestroy()
  }

  private fun createNotifChannel() {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
      val ch = NotificationChannel("boot_overlay", "Boot Overlay", NotificationManager.IMPORTANCE_MIN)
      nm.createNotificationChannel(ch)
    }
  }
}
