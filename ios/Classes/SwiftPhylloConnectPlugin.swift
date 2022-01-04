import Flutter
import UIKit
import PhylloConnect


public class SwiftPhylloConnectPlugin: NSObject, FlutterPlugin {
    var phylloConfig = PhylloConfig()
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "phyllo_connect", binaryMessenger: registrar.messenger())
        let instance = SwiftPhylloConnectPlugin()
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
        phylloConfig.clientDisplayName =  (config["clientDisplayName"] as? String)!
        phylloConfig.token = "Bearer " + (config["token"] as? String)!
        phylloConfig.userId = (config["userId"] as? String)!
        phylloConfig.environment = getPhylloEnvironment(env: config["environment"] as? String)
        phylloConfig.workPlatformId = (config["workPlatformId"] as? String)!
    }
    
    func open() {
        let phyllo = PhylloConnect.init(config: phylloConfig)
        phyllo.open()
    }
}
