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
            "launchPhylloConnectSdk" -> {

                Log.d(logTag, call.arguments.toString())

                val appName = call.argument<String>("appName")
                val userId = call.argument<String>("userId")
                val sdkToken = call.argument<String>("sdkToken")
                val environment = call.argument<String>("environment")
                val platformId = call.argument<String>("platformId")

                launchPhylloConnectSdk(appName!!, userId!!, sdkToken!!, environment!!, platformId!!)
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


    private fun launchPhylloConnectSdk(
        name: String,
        userId: String,
        sdkToken: String,
        environment: String,
        platformId: String
    ) {

        Log.d(logTag, "Initialize Phyllo Connect Sdk")

        PhylloConnect.initialize(context = context,
            name = name,
            userId = userId,
            token = sdkToken,
            platformId = platformId,
            environment = getPhylloEnvironment(environment),
            callback = object : ConnectCallback {

                override fun onAccountConnected(platformId: String?, userId: String?) {
                    Log.d(logTag, "onAccountConnected $platformId  $userId")
                }

                override fun onAccountDisconnected(platformId: String?, userId: String?) {
                    Log.d(logTag, "onAccountDisconnected $platformId  $userId")
                }

                override fun onError(errorMsg: String?) {
                    Log.d(logTag, "on Error errorMsg")
                }

                override fun onTokenExpired() {
                    Log.d(logTag, "onTokenExpired")
                }

                override fun onEvent(event: PhylloConnect.EVENT) {
                    Log.d(logTag, "onEvent $event")
                }

                override fun onExit() {
                    Log.d(logTag, "onExit")
                }
            })

        PhylloConnect.startSDK()
    }
}
