package com.domus.mobile

import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager.LayoutParams
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Prevent screenshots and screen recordings on Android
        window.addFlags(LayoutParams.FLAG_SECURE)
    }
}
