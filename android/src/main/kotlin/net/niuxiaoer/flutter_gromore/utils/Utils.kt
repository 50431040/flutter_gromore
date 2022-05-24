package net.niuxiaoer.flutter_gromore.utils

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.os.Build
import android.view.View
import android.view.WindowManager

class Utils {
    companion object {
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