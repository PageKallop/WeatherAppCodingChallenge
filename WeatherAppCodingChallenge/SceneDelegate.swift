import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let viewScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: viewScene)
    window?.makeKeyAndVisible()
    let viewModel = HomeWeatherViewModel()
    let vc = UINavigationController(rootViewController: HomeWeatherViewController(viewModel: viewModel))
    window?.rootViewController = vc
  }

  func sceneDidDisconnect(_ scene: UIScene) {

  }

  func sceneDidBecomeActive(_ scene: UIScene) {

  }

  func sceneWillResignActive(_ scene: UIScene) {

  }

  func sceneWillEnterForeground(_ scene: UIScene) {

  }

  func sceneDidEnterBackground(_ scene: UIScene) {

  }


}

