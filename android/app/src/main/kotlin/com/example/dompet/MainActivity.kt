package com.example.dompet

import android.os.Bundle
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity

private var mainFlutterEngine: FlutterEngine? = null
private var mainActivity: MainActivity? = null

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        mainFlutterEngine = flutterEngine
        setMethodChannel()
        setEventChannel()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initAppShortcuts(this)
        initActiveShortcut(intent)
        mainActivity = this
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        initActiveShortcut(intent)
        setIntent(intent)
    }

    override fun onDestroy() {
        super.onDestroy()

        if (mainActivity != null) {
            mainActivity = null
        }

        if (mainFlutterEngine != null) {
            mainFlutterEngine = null
        }
    }
}

fun getMainActivity () : MainActivity {
    return mainActivity!!
}

fun getMainFlutterEngine () : FlutterEngine {
    return mainFlutterEngine!!
}
