package com.phyllo.connect.phyllo_connect

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.getphyllo.ConnectCallback
import com.getphyllo.PhylloConnect

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** PhylloConnectPlugin */
class PhylloConnectPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    val logTag: String = "PhylloConnect"

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
                result.success(env!!.baseUrl)
            }
            "initialize" -> {

                Log.d(logTag, call.arguments.toString())

                val clientDisplayName = call.argument<String>("clientDisplayName")
                val userId = call.argument<String>("userId")
                val token = call.argument<String>("token")
                val environment = call.argument<String>("environment")
                val workPlatformId = call.argument<String>("workPlatformId")

                initialize(clientDisplayName!!, userId!!, token!!, environment!!, workPlatformId!!)
            }
            "open" -> {
                open()
            }
            else -> {
                result.notImplemented()
            }
        }
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
            "production" -> {
                return PhylloConnect.ENVIRONMENT.PRODUCTION
            }
            else -> PhylloConnect.ENVIRONMENT.DEVELOPMENT
        }
    }


    private fun initialize(
        clientDisplayName: String,
        userId: String,
        token: String,
        environment: String,
        workPlatformId: String
    ) {

        Log.d(logTag, "Initialize Phyllo Connect Sdk")

        PhylloConnect.initialize(context = context,
            name = clientDisplayName,
            userId = userId,
            token = token,
            platformId = workPlatformId,
            environment = getPhylloEnvironment(environment),
            callback = object : ConnectCallback {

                override fun onAccountConnected(
                    accountId: String?,
                    platformId: String?,
                    userId: String?
                ) {
                    Log.d(logTag, "onAccountConnected $accountId $platformId  $userId")
                    onPhylloAccountConnected(accountId, platformId, userId)
                }

                override fun onAccountDisconnected(
                    accountId: String?,
                    platformId: String?,
                    userId: String?
                ) {
                    Log.d(logTag, "onAccountDisconnected $accountId $platformId  $userId")
                    onPhylloAccountDisconnected(accountId, platformId, userId)
                }

                override fun onError(errorMsg: String?) {
                    Log.d(logTag, "onError $errorMsg")
                }

                override fun onTokenExpired(userId: String?) {
                    Log.d(logTag, "onTokenExpired $userId")
                    onPhylloTokenExpired(userId)
                }

                override fun onEvent(event: PhylloConnect.EVENT) {
                    Log.d(logTag, "onEvent $event")
                }

                override fun onExit(reason: String?, userId: String?) {
                    Log.d(logTag, "onExit $reason $userId")
                    onPhylloExit(reason, userId)
                }
            })

    }

    private fun open() {
        PhylloConnect.open()
    }


    private fun onPhylloAccountConnected(
        accountId: String?,
        platformId: String?,
        userId: String?
    ) {
        val result: MutableMap<String, Any?> = HashMap()
        result["accountId"] = accountId
        result["platformId"] = platformId
        result["userId"] = userId
        channel.invokeMethod("onAccountConnected", result)
    }

    private fun onPhylloAccountDisconnected(
        accountId: String?,
        platformId: String?,
        userId: String?
    ) {
        val result: MutableMap<String, Any?> = HashMap()
        result["accountId"] = accountId
        result["platformId"] = platformId
        result["›"] = userId
        channel.invokeMethod("onAccountDisconnected", result)
    }

    private fun onPhylloTokenExpired(userId: String?) {
        channel.invokeMethod("onTokenExpired", userId)
    }

    private fun onPhylloExit(reason: String?, userId: String?) {
        val result: MutableMap<String, Any?> = HashMap()
        result["reason"] = reason
        result["userId"] = userId
        channel.invokeMethod("onExit", result)
    }

}
