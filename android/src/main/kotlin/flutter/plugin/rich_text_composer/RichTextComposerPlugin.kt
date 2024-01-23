package flutter.plugin.rich_text_composer

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

private const val METHOD_CHANNEL = "rich_text_composer"

class RichTextComposerPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel : MethodChannel
    private lateinit var applicationContext: Context
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        setupCallbackChannels(binding.binaryMessenger)
    }
    private fun setupCallbackChannels(binaryMessenger: BinaryMessenger) {
        channel = MethodChannel(binaryMessenger, METHOD_CHANNEL)
        channel.setMethodCallHandler(this)
    }
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "showSoftInput" -> {
                showSoftInput(applicationContext)
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
    private fun showSoftInput(context: Context) {
        KeyboardUtils.showSoftInput(context)
    }
}
