import Flutter
import UIKit
import PhylloConnect


public class SwiftPhylloConnectPlugin: NSObject, FlutterPlugin, PhylloConnectDelegate {
    
    var channel = FlutterMethodChannel()
     //var delegate : IDelegate
    
    // init(pluginRegistrar: FlutterPluginRegistrar) {
    //     delegate = PhylloConnectPluginDelegate(registrar: pluginRegistrar)
    // }

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
        PhylloConnect.shared.phylloConnectDelegate = self
    }
    
   public func open() {
        PhylloConnect.shared.open()
        print("open sdk")
    }
    
   public func onAccountConnected(account_id: String, work_platform_id: String, user_id: String) {
        print("onAccountConnected => account_id : \(account_id),work_platform_id : \(work_platform_id),user_id : \(user_id)")
        var result = [String : Any]()
        result["accountId"] = account_id
        result["platformId"] = work_platform_id
        result["userId"] = user_id
        channel.invokeMethod("onAccountConnected", arguments: result)
    }
    
   public func onAccountDisconnected(account_id: String, work_platform_id: String, user_id: String) {
        print("onAccountDisconnected => account_id : \(account_id),work_platform_id : \(work_platform_id),user_id : \(user_id)")
        var result = [String : Any]()
        result["accountId"] = account_id
        result["platformId"] = work_platform_id
        result["userId"] = user_id
        channel.invokeMethod("onAccountDisconnected", arguments: result)
    }
    
   public func onTokenExpired(user_id: String) {
        print("onTokenExpired => user_id : \(user_id)")
        channel.invokeMethod("onTokenExpired", arguments: user_id)
    }
    
   public func onExit(reason: String, user_id: String) {
        print("onExit => reason : \(reason),user_id : \(user_id)")
        var result = [String : Any]()
        result["reason"] = reason
        result["userId"] = user_id
        channel.invokeMethod("onExit", arguments: result)
    }
}

// protocol IDelegate {
    
//     func onAccountConnected(account_id:String,work_platform_id:String, user_id:String)
//     func onAccountDisconnected(account_id:String,work_platform_id:String, user_id:String)
//     func onTokenExpired(user_id:String)
//     func onExit(reason:String,user_id:String)
// }

// class PhylloConnectPluginDelegate : IDelegate,  PhylloConnectDelegate {

//     private let flutterRegistrar: FlutterPluginRegistrar
//     init(registrar: FlutterPluginRegistrar) {
//         self.flutterRegistrar = registrar
//     }
// }