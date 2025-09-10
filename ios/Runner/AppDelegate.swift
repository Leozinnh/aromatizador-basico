import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Registrar plugins apenas se necessário
    if let pluginRegistry = self as? FlutterPluginRegistry {
      GeneratedPluginRegistrant.register(with: pluginRegistry)
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
