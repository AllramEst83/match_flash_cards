# shared_preferences_android calls its Kotlin code through JNI, looking up
# classes, methods and signatures by their original names. R8 renaming or
# removing any Kotlin runtime class they touch (Continuation, CoroutineSingletons,
# ...) makes release builds crash at startup, so keep the runtime intact.
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class kotlin.** { *; }
-keep class kotlinx.coroutines.** { *; }
-keep class com.github.dart_lang.jni.** { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.**
