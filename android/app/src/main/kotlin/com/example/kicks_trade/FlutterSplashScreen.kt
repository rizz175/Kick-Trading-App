package com.example.kicks_trade

import android.graphics.drawable.Drawable
import io.flutter.embedding.android.DrawableSplashScreen
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.android.SplashScreen

class FlutterSplashScreen : FlutterFragment() {
    override fun provideSplashScreen(): SplashScreen? {
        // Load the splash Drawable.
        val splash: Drawable = resources.getDrawable(R.drawable.kicks_trade)

        // Construct a DrawableSplashScreen with the loaded splash
        // Drawable and return it.
        return DrawableSplashScreen(splash)
    }
}