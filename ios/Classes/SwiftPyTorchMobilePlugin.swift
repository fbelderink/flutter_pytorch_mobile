import Flutter
import UIKit

public class SwiftPyTorchMobilePlugin: NSObject, FlutterPlugin {
  let models = []
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "pytorch_mobile", binaryMessenger: registrar.messenger())
    let instance = SwiftPyTorchMobilePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "loadModule":
      do {
        let args = call.arguments
        models.append(TorchModule(path: args[0]))
      } catch {
        print(call.arguments[1] + "is not a proper model!")
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
