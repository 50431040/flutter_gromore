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

        /* 隐藏虚拟按键 */
        fun hideBottomUIMenu(activity: Activity) {
            //隐藏虚拟按键，并且全屏
            if (Build.VERSION.SDK_INT <= 11 && Build.VERSION.SDK_INT < 19) {
                // lower api
                activity.window.decorView.systemUiVisibility = View.GONE
            } else if (Build.VERSION.SDK_INT > 19) {
                // for new api versions.
                val decorView: View = activity.window.decorView
                val uiOptions = (View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                        or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY or View.SYSTEM_UI_FLAG_FULLSCREEN)
                decorView.systemUiVisibility = uiOptions
            }
        }

        fun dp2px(context: Context, dp: Float): Int {
            val scale = context.resources.displayMetrics.density
            return (dp * scale + 0.5f).toInt()
        }

    }
}