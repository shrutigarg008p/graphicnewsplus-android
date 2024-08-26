import UIKit
import Flutter
import FirebaseCore


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  private var methodChannel: FlutterMethodChannel?
  private var eventChannel: FlutterEventChannel?
  private let linkStreamHandler = LinkStreamHandler()

    override func application(_ application: UIApplication,
                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool {
          
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window.makeKeyAndVisible()
            self.window.rootViewController = FlutterViewController()

            let controller = window?.rootViewController as! FlutterViewController
            methodChannel = FlutterMethodChannel(name: "https://graphicnewsplus.com/channel", binaryMessenger: controller.binaryMessenger)
            eventChannel = FlutterEventChannel(name: "https://graphicnewsplus.com/events", binaryMessenger: controller.binaryMessenger)
            GeneratedPluginRegistrant.register(with: self)
            eventChannel?.setStreamHandler(linkStreamHandler)
            methodChannel?.setMethodCallHandler({ (call: FlutterMethodCall, result: FlutterResult) in
              guard call.method == "initialLink" else { result(FlutterMethodNotImplemented)
                    return
              }
            })

            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
       
      }

    
 
      
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
       eventChannel?.setStreamHandler(linkStreamHandler)
       return linkStreamHandler.handleLink(url.absoluteString)
     }

 

 

}


class LinkStreamHandler:NSObject, FlutterStreamHandler {
  
  var eventSink: FlutterEventSink?
  
  // links will be added to this queue until the sink is ready to process them
  var queuedLinks = [String]()
  
  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    self.eventSink = events
    queuedLinks.forEach({ events($0) })
    queuedLinks.removeAll()
    return nil
  }
  
  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    self.eventSink = nil
    return nil
  }
  
  func handleLink(_ link: String) -> Bool {
    guard let eventSink = eventSink else {
      queuedLinks.append(link)
      return false
    }
    eventSink(link)
    return true
  }
}


enum  Digits{
    
    case one
    case twoo
}
