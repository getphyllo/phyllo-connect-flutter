import Flutter
import UIKit
import PhylloConnect


public class SwiftPhylloConnectPlugin: NSObject, FlutterPlugin, FlutterStreamHandler,
                                       PhylloConnectDelegate {
    
    private var onEventSink: FlutterEventSink?
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "phyllo_connect", binaryMessenger: registrar.messenger())
        
        let instance = SwiftPhylloConnectPlugin()
        
        let eventChannel = FlutterEventChannel(
            name: "phyllo_connects/connect_callback",
            binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
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
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        onEventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        onEventSink = nil
        return nil
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
        
       
        let phylloConfig = PhylloConfig (
                                            environment: getPhylloEnvironment(env: config["environment"] as? String),
                                            clientDisplayName: (config["clientDisplayName"] as? String)!,
                                            token: "Bearer " + (config["token"] as? String)!,
                                            userId: (config["userId"] as? String)!,
                                            delegate:self,
                                            workPlatformId: (config["workPlatformId"] as? String)!
                                        )
        PhylloConnect.shared.initialize(config: phylloConfig)
        PhylloConnect.shared.phylloConnectDelegate = self
        
        print("Initialize Phyllo Connect Sdk")
    }
    
    public func open() {
        PhylloConnect.shared.open()
        print("Open Phyllo Connect Sdk")
    }
    
    public func onAccountConnected(account_id: String, work_platform_id: String, user_id: String) {
        print("onAccountConnected => account_id : \(account_id), work_platform_id : \(work_platform_id), user_id : \(user_id)")
        
        var result = [String : Any]()
        result["callback"] = "onAccountConnected"
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        
        guard let sink = onEventSink else { return }
        sink(result)
    }
    
    public func onAccountDisconnected(account_id: String, work_platform_id: String, user_id: String) {
        print("onAccountDisconnected => account_id : \(account_id), work_platform_id : \(work_platform_id), user_id : \(user_id)")
        
        var result = [String : Any]()
        result["callback"] = "onAccountDisconnected"
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        
        guard let sink = onEventSink else { return }
        sink(result)
    }
    
    public func onTokenExpired(user_id: String) {
        print("onTokenExpired => user_id : \(user_id)")
        
        var result = [String : Any]()
        result["callback"] = "onTokenExpired"
        result["user_id"] = user_id
        
        guard let sink = onEventSink else { return }
        sink(result)
    }
    
    public func onExit(reason: String, user_id: String) {
        print("onExit => reason : \(reason), user_id : \(user_id)")
        
        var result = [String : Any]()
        result["callback"] = "onExit"
        result["reason"] = reason
        result["user_id"] = user_id
        
        guard let sink = onEventSink else { return }
        sink(result)
    }
}
