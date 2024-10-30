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
        mainActivity = this
        initAppShortcuts()
        setMessenger()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        initActiveShortcut(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        initActiveShortcut(intent)
        setIntent(intent)
    }
}

fun getMainActivity () : MainActivity {
    return mainActivity!!
}

fun getMainFlutterEngine () : FlutterEngine {
    return mainFlutterEngine!!
}
