package com.example.dompet

import io.flutter.plugin.common.EventChannel

class AppStreamHandler(
    private val onCancel: ((args: Any?) -> Unit)? = null,
    private val onListen: ((args: Any?, sink: EventChannel.EventSink) -> Unit)? = null,
) : EventChannel.StreamHandler {

    override fun onListen(args: Any?, sink: EventChannel.EventSink?) {
        if (sink != null) {
            onListen?.invoke(args, sink)
        }
    }

    override fun onCancel(args: Any?) {
        onCancel?.invoke(args)
    }
}
