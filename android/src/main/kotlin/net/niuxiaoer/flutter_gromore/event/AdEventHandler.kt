package net.niuxiaoer.flutter_gromore.event

import android.util.Log
import io.flutter.plugin.common.EventChannel

class AdEventHandler: EventChannel.StreamHandler {
    private val TAG: String = this::class.java.simpleName
    private var eventSink: EventChannel.EventSink? = null

    companion object {
        // 单例
        fun getInstance() = InstanceHelper.instance
    }

    object InstanceHelper {
        val instance = AdEventHandler()
    }

    fun sendEvent(adEvent: AdEvent) {
        eventSink?.success(adEvent.toMap())
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        Log.d(TAG, "onListen")
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        Log.d(TAG, "onCancel")
        eventSink = null
    }
}