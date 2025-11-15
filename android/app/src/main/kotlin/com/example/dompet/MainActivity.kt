package com.example.dompet

import android.os.Bundle
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity

private var mainEngine: FlutterEngine? = null
private var mainActivity: MainActivity? = null

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        mainEngine = flutterEngine
        setMethodChannel()
        setEventChannel()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        mainActivity = this
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    override fun onDestroy() {
        super.onDestroy()

        if (mainActivity != null) {
            mainActivity = null
        }

        if (mainEngine != null) {
            mainEngine = null
        }
    }
}

fun getMainActivity () : MainActivity {
    return mainActivity!!
}

fun getMainEngine () : FlutterEngine {
    return mainEngine!!
}
