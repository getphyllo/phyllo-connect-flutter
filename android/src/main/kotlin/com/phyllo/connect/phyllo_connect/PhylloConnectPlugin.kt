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
import io.flutter.plugin.common.EventChannel
import java.util.logging.StreamHandler


/** PhylloConnectPlugin */
class PhylloConnectPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var context: Context

    private var onAccountConnected: EventChannel.EventSink? = null
    private var onAccountDisconnected: EventChannel.EventSink? = null
    private var onTokenExpired: EventChannel.EventSink? = null
    private var onExit: EventChannel.EventSink? = null


    val logTag: String = "PhylloConnect"

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "phyllo_connect")
        channel.setMethodCallHandler(this)

        eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "phyllo_connects/connect_callback")
        eventChannel.setStreamHandler(this)

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

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        when (arguments) {
            "onAccountConnected" -> {
                onAccountConnected = events!!
            }
            "onAccountDisconnected" -> {
                onAccountDisconnected = events!!
            }
            "onTokenExpired" -> {
                onTokenExpired = events!!
            }
            "onExit" -> {
                onExit = events!!
            }
        }
    }

    override fun onCancel(arguments: Any?) {
        when (arguments) {
            "onAccountConnected" -> {
                onAccountConnected = null
            }
            "onAccountDisconnected" -> {
                onAccountDisconnected = null
            }
            "onTokenExpired" -> {
                onTokenExpired = null
            }
            "onExit" -> {
                onExit = null
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
                    account_id: String?,
                    work_platform_id: String?,
                    user_id: String?
                ) {
                    Log.d(logTag, "onAccountConnected $account_id $work_platform_id $user_id")
                    onPhylloAccountConnected(account_id, work_platform_id, user_id)
                }

                override fun onAccountDisconnected(
                    account_id: String?,
                    work_platform_id: String?,
                    user_id: String?
                ) {
                    Log.d(logTag, "onAccountDisconnected $account_id $work_platform_id $user_id")
                    onPhylloAccountDisconnected(account_id, work_platform_id, user_id)
                }

                override fun onError(errorMsg: String?) {
                    Log.d(logTag, "onError $errorMsg")
                }

                override fun onTokenExpired(user_id: String?) {
                    Log.d(logTag, "onTokenExpired $user_id")
                    onPhylloTokenExpired(user_id)
                }

                override fun onEvent(event: PhylloConnect.EVENT) {
                    Log.d(logTag, "onEvent $event")
                }

                override fun onExit(reason: String?, user_id: String?) {
                    Log.d(logTag, "onExit $reason $user_id")
                    onPhylloExit(reason, user_id)
                }
            })

    }

    private fun open() {
        Log.d(logTag,"Open Phyllo Connect Sdk")
        PhylloConnect.open()
    }

    private fun onPhylloAccountConnected(
        account_id: String?,
        work_platform_id: String?,
        user_id: String?
    ) {
        val result: MutableMap<String, Any?> = HashMap()
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        onAccountConnected?.success(result)
    }

    private fun onPhylloAccountDisconnected(
        account_id: String?,
        work_platform_id: String?,
        user_id: String?
    ) {
        val result: MutableMap<String, Any?> = HashMap()
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        onAccountDisconnected?.success(result)
    }

    private fun onPhylloTokenExpired(user_id: String?) {
        onTokenExpired?.success(user_id)
    }

    private fun onPhylloExit(reason: String?, user_id: String?) {
        val result: MutableMap<String, Any?> = HashMap()
        result["reason"] = reason
        result["user_id"] = user_id
        onExit?.success(result)
    }
}
