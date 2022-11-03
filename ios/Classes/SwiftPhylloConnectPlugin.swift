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
            name: "phyllo_connect/connect_callback",
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
            
            if let config  = call.arguments as? Dictionary<String, Any>{

                guard let environment = config["environment"] as? String else {
                    toastMessage("Please pass a valid environment.")
                    result(false)
                    return
                }

                guard let clientDisplayName =  config["clientDisplayName"] as? String  else {
                    toastMessage("Please pass a valid clientDisplayName.")
                    result(false)
                    return
                }
            
                guard let token =  config["token"] as? String else {
                    toastMessage("Please pass a valid token.")
                    result(false)
                    return
                }
            
                guard  let userId =  config["userId"] as? String else {
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
    
    func initialize(config : Dictionary<String, Any>) {
        var phylloConfig = [String:Any]()
        phylloConfig["environment"] = getPhylloEnvironment(env: config["environment"] as? String)
        phylloConfig["clientDisplayName"] = config["clientDisplayName"] as? String
        phylloConfig["token"] = config["token"] as? String
        phylloConfig["userId"] = config["userId"] as? String
        phylloConfig["workPlatformId"] = config["workPlatformId"] as? String
        phylloConfig["delegate"] = self
        phylloConfig["external_sdk_name"] = "flutter" //for Tracking
        phylloConfig["external_sdk_version"] = "0.3.0"  // for version
        
        PhylloConnect.shared.initialize(config: phylloConfig)
    }
    
    public func open() {
        PhylloConnect.shared.open()
    }
    
    public func onAccountConnected(account_id: String, work_platform_id: String, user_id: String) {
        var result = [String : Any]()
        result["callback"] = "onAccountConnected"
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        
        guard let sink = onEventSink else { return }
        sink(result)
    }
    
    public func onAccountDisconnected(account_id: String, work_platform_id: String, user_id: String) {
        var result = [String : Any]()
        result["callback"] = "onAccountDisconnected"
        result["account_id"] = account_id
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        
        guard let sink = onEventSink else { return }
        sink(result)
    }
    
    public func onTokenExpired(user_id: String) {
        var result = [String : Any]()
        result["callback"] = "onTokenExpired"
        result["user_id"] = user_id
        
        guard let sink = onEventSink else { return }
        sink(result)
    }
    
    public func onExit(reason: String, user_id: String) {
        var result = [String : Any]()
        result["callback"] = "onExit"
        result["reason"] = reason
        result["user_id"] = user_id
        
        guard let sink = onEventSink else { return }
        sink(result)
    }
    
    public func onConnectionFailure(reason: String, work_platform_id: String, user_id: String) {
        var result = [String : Any]()
        result["callback"] = "onConnectionFailure"
        result["reason"] = reason
        result["work_platform_id"] = work_platform_id
        result["user_id"] = user_id
        
        guard let sink = onEventSink else { return }
        sink(result)
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
