import Flutter
import UIKit
import PhylloConnect

public class SwiftPhylloConnectPlugin: NSObject, FlutterPlugin, PhylloConnectDelegate {
    
    private static var channel: FlutterMethodChannel?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "phyllo_connect", binaryMessenger: registrar.messenger())
        
        let instance = SwiftPhylloConnectPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        self.channel = channel
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
            
            if let config  = call.arguments as? Dictionary<String, Any>{
                
                guard config["environment"] is String else {
                    toastMessage("Please pass a valid environment.")
                    result(false)
                    return
                }
                
                guard config["clientDisplayName"] is String  else {
                    toastMessage("Please pass a valid clientDisplayName.")
                    result(false)
                    return
                }
                
                guard config["token"] is String else {
                    toastMessage("Please pass a valid token.")
                    result(false)
                    return
                }
                
                guard  config["userId"] is String else {
                    toastMessage("Please pass a valid userId.")
                    result(false)
                    return
                }
                
                initialize(config: config)
                result(true)
                
            } else {
                result("error")
            }
        } else if call.method == "open" {
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
        case ("staging"):
            return PhylloEnvironment.staging
        case ("production"):
            return PhylloEnvironment.prod
        default:
            return PhylloEnvironment.dev
        }
    }
    
    func initialize(config : Dictionary<String, Any>) {
        var phylloConfig = [String:Any]()
        phylloConfig = config
        phylloConfig["environment"] = getPhylloEnvironment(env: config["environment"] as? String)
        phylloConfig["delegate"] = self
        phylloConfig["external_sdk_name"] = "flutter" //for Analytics
        phylloConfig["external_sdk_version"] = "0.3.2"  // for sdk version
        
        PhylloConnect.shared.initialize(config: phylloConfig)
    }
    
    public func open() {
        PhylloConnect.shared.open()
    }
    
    public func onAccountConnected(account_id: String, work_platform_id: String, user_id: String) {
        var result = [String : Any]()
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        
        SwiftPhylloConnectPlugin.channel?.invokeMethod("onAccountConnected", arguments: result)
        return
    }
    
    public func onAccountDisconnected(account_id: String, work_platform_id: String, user_id: String) {
        var result = [String : Any]()
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        
        SwiftPhylloConnectPlugin.channel?.invokeMethod("onAccountDisconnected", arguments: result)
    }
    
    public func onTokenExpired(user_id: String) {
        var result = [String : Any]()
        result["user_id"] = user_id
        
        SwiftPhylloConnectPlugin.channel?.invokeMethod("onTokenExpired", arguments: result)
    }
    
    public func onExit(reason: String, user_id: String) {
        var result = [String : Any]()
        result["reason"] = reason
        result["user_id"] = user_id
        
        SwiftPhylloConnectPlugin.channel?.invokeMethod("onExit", arguments: result)
    }
    
    public func onConnectionFailure(reason: String, work_platform_id: String, user_id: String) {
        var result = [String : Any]()
        result["reason"] = reason
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        
        SwiftPhylloConnectPlugin.channel?.invokeMethod("onConnectionFailure", arguments: result)
    }
    
    func toastMessage(_ message: String){
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {return}
            let messageLbl = UILabel()
            messageLbl.text = message
            messageLbl.textAlignment = .center
            messageLbl.font = UIFont.systemFont(ofSize: 12)
            messageLbl.textColor = .white
            messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            let textSize:CGSize = messageLbl.intrinsicContentSize
            let labelWidth = min(textSize.width, window.frame.width - 40)
            
            messageLbl.frame = CGRect(x: 20, y: window.frame.height - 90, width: labelWidth + 30, height: textSize.height + 20)
            messageLbl.center.x = window.center.x
            messageLbl.layer.cornerRadius = messageLbl.frame.height/2
            messageLbl.layer.masksToBounds = true
            window.addSubview(messageLbl)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                UIView.animate(withDuration: 1, animations: {
                    messageLbl.alpha = 0
                }) { (_) in
                    messageLbl.removeFromSuperview()
                }
            }
        }
    }
}
