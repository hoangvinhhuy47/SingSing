package net.singsing.app

import io.flutter.embedding.android.FlutterActivity
import android.provider.Settings;
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "net.singsing.app"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "getKeyboardVendor") {
                result.success(getKeyboardVendor())
            } else {
                result.notImplemented()
            }
        }
    }

    // required for workaround, see https://github.com/flutter/flutter/issues/61175
    private fun getKeyboardVendor(): String {
        return Settings.Secure.getString(contentResolver, Settings.Secure.DEFAULT_INPUT_METHOD)
    }
}
