package com.example.dompet

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

private var methodChannel: MethodChannel? = null
private var eventChannel: EventChannel? = null
private var initialized: Boolean = false

fun isInitialized (): Boolean {
    return initialized
}

fun getEventChannel(): EventChannel? {
    return eventChannel
}

fun getMethodChannel() : MethodChannel? {
    return methodChannel
}

fun setMethodChannelHandler () {
    methodChannel?.setMethodCallHandler { call, result ->
        when (call.method) {
            "invokeNativeMethodChannel" -> {
                initialized = true
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }
}

fun setEventChannelHandler () {
    eventChannel?.setStreamHandler(AppStreamHandler(
        onListen = { _, sink -> },
        onCancel = { _ -> }
    ))
}

fun setMethodChannel() {
    val channel = "app.native/methodChannel"
    val executor = getMainEngine().dartExecutor
    methodChannel = MethodChannel(executor, channel)
    setMethodChannelHandler()
}

fun setEventChannel() {
    val channel = "app.native/eventChannel"
    val executor = getMainEngine().dartExecutor
    eventChannel = EventChannel(executor, channel)
    setEventChannelHandler()
}
