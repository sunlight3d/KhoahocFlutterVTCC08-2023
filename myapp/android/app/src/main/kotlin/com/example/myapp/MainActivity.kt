package com.example.myapp
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "channel_01"
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Set up the method channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "your_native_method_name") {
                // Implement your custom native logic here
                val response = yourNativeMethod()
                // Return the result to Flutter
                result.success(response)
            } else {
                result.notImplemented()
            }
        }
    }
    private fun yourNativeMethod(): String {
        // Implement your custom native logic here
        return "Hello from native code!"
    }
}