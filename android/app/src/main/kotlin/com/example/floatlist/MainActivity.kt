package com.floatlist.app

import android.os.Bundle
import android.util.DisplayMetrics
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.floatlist.app/screen"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getScreenSize") {
                val displayMetrics = DisplayMetrics()
                @Suppress("DEPRECATION")
                windowManager.defaultDisplay.getRealMetrics(displayMetrics)

                val screenWidth = displayMetrics.widthPixels / displayMetrics.density
                val screenHeight = displayMetrics.heightPixels / displayMetrics.density

                result.success(mapOf(
                    "width" to screenWidth.toDouble(),
                    "height" to screenHeight.toDouble()
                ))
            } else {
                result.notImplemented()
            }
        }
    }
}
