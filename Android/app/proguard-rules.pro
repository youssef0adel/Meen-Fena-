# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Dart
-keep class com.meenfena.game.** { *; }

# WebSocket
-keep class org.java_websocket.** { *; }
-dontwarn org.java_websocket.**

# OKHttp
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }

# Audio Player
-keep class com.google.android.exoplayer2.** { *; }

# أمان اللعبة - منع فك التجميع
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# إبقاء أسماء الحالات والأدلة
-keep class com.meenfena.game.data.models.** { *; }
-keep class com.meenfena.game.game.cases.** { *; }

# منع تحليل الكود العكسي
-obfuscationdictionary dict.txt
-classobfuscationdictionary dict.txt
-packageobfuscationdictionary dict.txt