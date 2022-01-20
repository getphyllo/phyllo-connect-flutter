import Flutter
import UIKit
import PhylloConnect


public class SwiftPhylloConnectPlugin: NSObject, FlutterPlugin {
    
    var channel = FlutterMethodChannel()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftPhylloConnectPlugin()
        instance.channel = FlutterMethodChannel(name: "phyllo_connect", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: instance.channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getPhylloEnvironmentUrl" {
            if let args = call.arguments as? Dictionary<String, Any>{
                let envType = args["type"] as? String
                let env = getPhylloEnvironment(env: envType)
                result(env.rawValue)
            } else {
                result("error")
            }
        } else if call.method == "initialize" {
            print(call.arguments as Any)
            if let args  = call.arguments as? Dictionary<String, Any>{
                initialize(config: args)
            } else {
                result("error")
            }
        }else if call.method == "open" {
            open()
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func getPhylloEnvironment(env :String?) -> PhylloEnvironment {
        switch (env) {
        case ("development"):
            return PhylloEnvironment.dev
        case ("sandbox"):
            return PhylloEnvironment.sandbox
        case ("production"):
            return PhylloEnvironment.prod
        default:
            return PhylloEnvironment.dev
        }
    }
    
    func initialize(config : Dictionary<String, Any>){
       
        print("initialize")
        var phylloConfig = PhylloConfig()
        phylloConfig.clientDisplayName = (config["clientDisplayName"] as? String)!
        phylloConfig.token = "Bearer " + (config["token"] as? String)!
        phylloConfig.userId = (config["userId"] as? String)!
        phylloConfig.environment = getPhylloEnvironment(env: config["environment"] as? String)
        phylloConfig.workPlatformId = (config["workPlatformId"] as? String)!
        PhylloConnect.shared.initialize(config: phylloConfig)
    }
    
    func open() {
        PhylloConnect.shared.open()
        print("open sdk")
    }
    
    func onAccountConnected(account_id: String, work_platform_id: String, user_id: String) {
        var result = [String : Any]()
        result["accountId"] = account_id
        result["platformId"] = work_platform_id
        result["userId"] = user_id
        channel.invokeMethod("onAccountConnected", arguments: result)
    }
    
    func onAccountDisconnected(account_id: String, work_platform_id: String, user_id: String) {
        var result = [String : Any]()
        result["accountId"] = account_id
        result["platformId"] = work_platform_id
        result["userId"] = user_id
        channel.invokeMethod("onAccountDisconnected", arguments: result)
    }
    
    func onTokenExpired(user_id: String) {
        channel.invokeMethod("onTokenExpired", arguments: user_id)
    }
    
    func onExit(reason: String, user_id: String) {
        var result = [String : Any]()
        result["reason"] = reason
        result["userId"] = user_id
        channel.invokeMethod("onExit", arguments: result)
    }
}
