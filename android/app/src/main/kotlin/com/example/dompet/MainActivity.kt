package com.example.dompet

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity

private var mainFlutterEngine: FlutterEngine? = null
private var mainActivity: MainActivity? = null

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        mainFlutterEngine = flutterEngine
        mainActivity = this
        setMessenger()
    }
}

fun getMainActivity () : MainActivity {
    return mainActivity!!
}

fun getMainFlutterEngine () : FlutterEngine {
    return mainFlutterEngine!!
}
