package net.niuxiaoer.flutter_gromore.view

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * 广告基类
 * 必须实现 initAd
 * postMessage 发送事件
 */
abstract class FlutterGromoreBase(messenger: BinaryMessenger, channelName: String) {

    private val methodChannel = MethodChannel(messenger, channelName)

    // 初始化广告
    abstract fun initAd()

    // 发送事件消息
    protected fun postMessage(method: String, arguments: Map<String, Any?>? = null) {
        methodChannel.invokeMethod(method, arguments)
    }
}