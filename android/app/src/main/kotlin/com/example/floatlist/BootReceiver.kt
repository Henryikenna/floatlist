package com.floatlist.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class BootReceiver : BroadcastReceiver() {
  override fun onReceive(context: Context, intent: Intent) {
    if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
      val prefs = context.getSharedPreferences("floatlist_prefs", Context.MODE_PRIVATE)
      val overlayEnabled = prefs.getBoolean("overlay_enabled", false)
      if (overlayEnabled) {
        // Start a foreground service that hosts a FlutterEngine
        val svc = Intent(context, BootService::class.java)
        context.startForegroundService(svc)
      } else {
        Log.i("BootReceiver", "Overlay disabled in prefs")
      }
    }
  }
}
