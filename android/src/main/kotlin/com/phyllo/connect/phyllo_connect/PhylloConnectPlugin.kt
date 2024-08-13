package com.phyllo.connect.phyllo_connect

import android.content.Context
import android.widget.Toast
import androidx.annotation.NonNull
import com.getphyllo.ConnectCallback
import com.getphyllo.PhylloConnect
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


class PhylloConnectPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "phyllo_connect")
        channel.setMethodCallHandler(this)

        this.context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPhylloEnvironmentUrl" -> {
                val envType = call.argument<String>("type")
                val env = envType?.let { getPhylloEnvironment(it) }
                if (env != null) {
                    result.success(env.baseUrl)
                } else {
                    result.success(null)
                }
            }
            "initialize" -> {

                if (call.argument<String?>("clientDisplayName") == null) {
                    showToast("Please pass a valid clientDisplayName.")
                    result.success(false)
                }

                if (call.argument<String?>("userId") == null) {
                    showToast("Please pass a valid userId.")
                    result.success(false)
                }

                if (call.argument<String?>("token") == null) {
                    showToast("Please pass a valid token.")
                    result.success(false)
                }

                if (call.argument<String?>("environment") == null) {
                    showToast("Please pass a valid environment.")
                    result.success(false)
                }
                @Suppress("UNCHECKED_CAST")
                initialize(config = call.arguments as HashMap<String, Any?>)
                result.success(true)
            }
            "open" -> {
                open()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun showToast(message: String) {
        Toast.makeText(context, message, Toast.LENGTH_LONG).show()
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    private fun getPhylloEnvironment(env: String): PhylloConnect.ENVIRONMENT {
        return when (env) {
            "development" -> {
                return PhylloConnect.ENVIRONMENT.DEVELOPMENT
            }
            "sandbox" -> {
                return PhylloConnect.ENVIRONMENT.SANDBOX
            }
            "staging" -> {
                return PhylloConnect.ENVIRONMENT.STAGING
            }
            "production" -> {
                return PhylloConnect.ENVIRONMENT.PRODUCTION
            }
            else -> PhylloConnect.ENVIRONMENT.DEVELOPMENT
        }
    }

    private fun initialize(config: HashMap<String, Any?>) {

        val callback = object : ConnectCallback() {

            override fun onAccountConnected(
                account_id: String?,
                work_platform_id: String?,
                user_id: String?,
            ) {
                onPhylloAccountConnected(account_id, work_platform_id, user_id)
            }

            override fun onAccountDisconnected(
                account_id: String?,
                work_platform_id: String?,
                user_id: String?,
            ) {
                onPhylloAccountDisconnected(account_id, work_platform_id, user_id)
            }

            override fun onTokenExpired(user_id: String?) {
                onPhylloTokenExpired(user_id)
            }

            override fun onExit(reason: String?, user_id: String?) {
                onPhylloExit(reason, user_id)
            }

            override fun onConnectionFailure(
                reason: String?,
                work_platform_id: String?,
                user_id: String?,
            ) {
                onPhylloConnectionFailure(reason, work_platform_id, user_id)
            }

        }

        val map = hashMapOf<String, Any?>()
        map.putAll(config)
        map["environment"] = getPhylloEnvironment(config["environment"] as String)
        map["external_sdk_name"] = "flutter" //for Analytics
        map["external_sdk_version"] = "0.3.6"  // for sdk version
        map["callback"] = callback
        PhylloConnect.initialize(context = context, map)

    }

    private fun open() {
        PhylloConnect.open()
    }

    private fun onPhylloAccountConnected(
        account_id: String?,
        work_platform_id: String?,
        user_id: String?,
    ) {
        val result: MutableMap<String, Any?> = HashMap()
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        channel.invokeMethod("onAccountConnected", result)
    }

    private fun onPhylloAccountDisconnected(
        account_id: String?,
        work_platform_id: String?,
        user_id: String?,
    ) {
        val result: MutableMap<String, Any?> = HashMap()
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        channel.invokeMethod("onAccountDisconnected", result)
    }

    private fun onPhylloTokenExpired(user_id: String?) {
        val result: MutableMap<String, Any?> = HashMap()
        result["user_id"] = user_id
        channel.invokeMethod("onTokenExpired", result)
    }

    private fun onPhylloExit(reason: String?, user_id: String?) {
        val result: MutableMap<String, Any?> = HashMap()
        result["reason"] = reason
        result["user_id"] = user_id
        channel.invokeMethod("onExit", result)
    }

    private fun onPhylloConnectionFailure(
        reason: String?,
        work_platform_id: String?,
        user_id: String?
    ) {
        val result: MutableMap<String, Any?> = HashMap()
        result["reason"] = reason
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        channel.invokeMethod("onConnectionFailure", result)
    }
}
