package net.niuxiaoer.flutter_gromore.utils

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.os.Build
import android.view.View
import android.view.WindowManager
import io.flutter.plugin.common.MethodChannel

class Utils {
    companion object {
        // 开屏广告result，在开屏广告关闭后返回给dart端
        var splashResult: MethodChannel.Result? = null

        // 获取屏幕宽度
        fun getScreenWidthInPx(context: Context): Int {
            val dm = context.applicationContext.resources.displayMetrics
            return dm.widthPixels
        }

        // 获取屏幕高度
        fun getScreenHeightInPx(context: Context): Int {
            val dm = context.applicationContext.resources.displayMetrics
            return dm.heightPixels
        }

        // 屏幕密度
        fun getDensity(context: Context): Float {
            return context.resources.displayMetrics.density
        }

        // 状态栏透明
        fun setTranslucent(activity: Activity) {
            val window = activity.window
            /// 设置透明状态栏
            if (window != null) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    window.statusBarColor = Color.TRANSPARENT
                } else {
                    window.addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
                }
            }
        }
    }
}