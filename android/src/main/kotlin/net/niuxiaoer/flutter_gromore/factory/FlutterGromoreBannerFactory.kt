package net.niuxiaoer.flutter_gromore.factory

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import net.niuxiaoer.flutter_gromore.view.FlutterGromoreBanner

class FlutterGromoreBannerFactory(
        private val activity: Activity,
        private val binaryMessenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>
        return FlutterGromoreBanner(context, activity, viewId, creationParams, binaryMessenger);
    }
}