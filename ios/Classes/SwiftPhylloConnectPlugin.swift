import Flutter
import UIKit
import PhylloConnect

public class SwiftPhylloConnectPlugin: NSObject, FlutterPlugin {
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
            
        } else if call.method == "launchPhylloConnectSdk" {
            
            print(call.arguments as Any)
        
            if let args  = call.arguments as? Dictionary<String, Any>{
                launchPhylloConnectSdk(arguments: args)
            } else {
                result("error")
            }
            
            
        } else {
            
            result(FlutterMethodNotImplemented)
            
        }
    }
    
    
    public func getPhylloEnvironment(env :String?) -> PhylloEnvironment {
        switch (env) {
        case ("dev"):
            return PhylloEnvironment.dev
        case ("sandbox"):
            return PhylloEnvironment.sandbox
        case ("prod"):
            return PhylloEnvironment.prod
        default:
            return PhylloEnvironment.dev
        }
    }
    
    func launchPhylloConnectSdk(arguments : Dictionary<String, Any>){
    
        var phylloConfig = PhylloConfig()
        phylloConfig.developerName =  "Etzy"
        phylloConfig.deepLinkURL = "https://etsy.ai"
        phylloConfig.sdkToken = (arguments["sdkToken"] as? String)!
        phylloConfig.userId = (arguments["userId"] as? String)!
        phylloConfig.env = getPhylloEnvironment(env: arguments["environment"] as? String)
        phylloConfig.phylloVC = getPhylloViewController()!
        
        let phyllo = PhylloConnectSDK(configuration: phylloConfig)
        phyllo.launchSDK(workPlatformId: (arguments["platformId"] as? String)!)
        
    }
    
    func getPhylloViewController() -> UIViewController? {
        var viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController as! FlutterViewController
        while viewController?.presentedViewController != nil {
            viewController = viewController?.presentedViewController
        }
        return viewController
    }
}
