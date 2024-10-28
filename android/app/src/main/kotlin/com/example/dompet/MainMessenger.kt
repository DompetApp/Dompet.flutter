package com.example.dompet

import java.lang.Exception
import io.flutter.plugin.common.MethodChannel

private var messenger: MethodChannel? = null
private var initialized: Boolean = false

fun isInitialized (): Boolean {
    return initialized
}

fun getMessenger (): MethodChannel {
    return messenger!!
}

fun setMessengerHandler () {
    messenger!!.setMethodCallHandler {
        call, result ->
            when (call.method) {
                "invokerNativeMethodChannel" -> {
                  initialized = true
                  result.success(true)
                }
                else -> result.notImplemented()
            }
    }
}

fun setMessenger() {
    messenger = MethodChannel(
        getMainFlutterEngine().dartExecutor,
        "app.native/methodChannel"
    )
    setMessengerHandler()
}

