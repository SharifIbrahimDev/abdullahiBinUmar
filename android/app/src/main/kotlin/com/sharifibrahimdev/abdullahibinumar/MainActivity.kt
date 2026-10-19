package com.sharifibrahimdev.abdullahibinumar

import android.os.Bundle
import androidx.core.view.WindowCompat
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private val CHANNEL = "com.sharifibrahimdev.abdullahibinumar/share"

    override fun onCreate(savedInstanceState: Bundle?) {
        // Draw behind system bars (edge-to-edge) using the non-deprecated API
        WindowCompat.setDecorFitsSystemWindows(window, false)
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getApkPath") {
                val apkPath = applicationInfo.sourceDir
                result.success(apkPath)
            } else {
                result.notImplemented()
            }
        }
    }
}
