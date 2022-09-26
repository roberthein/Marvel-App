import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let charactersViewController = CharactersViewController()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = charactersViewController
        window?.makeKeyAndVisible()

        return true
    }
}
