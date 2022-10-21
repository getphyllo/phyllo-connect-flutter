package com.phyllo.connect.phyllo_connect

import android.content.Context
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import com.getphyllo.ConnectCallback
import com.getphyllo.PhylloConnect
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


class PhylloConnectPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var context: Context

    private var eventSink: EventChannel.EventSink? = null

    val logTag: String = "PhylloConnect"

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "phyllo_connect")
        channel.setMethodCallHandler(this)

        eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "phyllo_connect/connect_callback")
        eventChannel.setStreamHandler(this)

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

                val clientDisplayName = call.argument<String?>("clientDisplayName")
                val userId = call.argument<String?>("userId")
                val token = call.argument<String?>("token")
                val environment = call.argument<String?>("environment")
                val workPlatformId = call.argument<String?>("workPlatformId") ?: ""
                val singleAccount = call.argument<Boolean?>("singleAccount") ?: false
                
                if (clientDisplayName == null) {
                    showToast("Please pass a valid clientDisplayName.")
                    result.success(false)
                }

                if (userId == null) {
                    showToast("Please pass a valid userId.")
                    result.success(false)
                }

                if (token == null) {
                    showToast("Please pass a valid token.")
                    result.success(false)
                }

                if (environment == null) {
                    showToast("Please pass a valid environment.")
                    result.success(false)
                }

                if (environment == null) {
                    showToast("Please pass a valid environment.")
                    result.success(false)
                } 


                initialize(
                    clientDisplayName!!,
                    userId!!,
                    token!!,
                    environment!!,
                    workPlatformId,
                    singleAccount
                )
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

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
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
        workPlatformId: String,
        singleAccount: Boolean
    ) {

        var callback = object : ConnectCallback() {

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

        val map = hashMapOf<String, Any?>(
            "clientDisplayName" to clientDisplayName,
            "token" to token,
            "workPlatformId" to workPlatformId,
            "userId" to userId,
            "environment" to getPhylloEnvironment(environment),
            "callback" to callback,
            "singleAccount" to singleAccount
        )
        PhylloConnect.initialize(context = context,map)

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
        result["callback"] = "onAccountConnected"
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        eventSink?.success(result)
    }

    private fun onPhylloAccountDisconnected(
        account_id: String?,
        work_platform_id: String?,
        user_id: String?,
    ) {
        val result: MutableMap<String, Any?> = HashMap()
        result["callback"] = "onAccountDisconnected"
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        eventSink?.success(result)
    }

    private fun onPhylloTokenExpired(user_id: String?) {
        val result: MutableMap<String, Any?> = HashMap()
        result["callback"] = "onTokenExpired"
        result["user_id"] = user_id
        eventSink?.success(result)
    }

    private fun onPhylloExit(reason: String?, user_id: String?) {
        val result: MutableMap<String, Any?> = HashMap()
        result["callback"] = "onExit"
        result["reason"] = reason
        result["user_id"] = user_id
        eventSink?.success(result)
    }

    private fun onPhylloConnectionFailure(
        reason: String?,
        user_id: String?,
        work_platform_id: String?,
    ) {
        val result: MutableMap<String, Any?> = HashMap()
        result["callback"] = "onConnectionFailure"
        result["reason"] = reason
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id

        eventSink?.success(result)
    }
}
