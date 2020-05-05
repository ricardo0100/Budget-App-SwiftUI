//
//  SceneDelegate.swift
//  BlackBeans
//
//  Created by Ricardo Gehrke on 05/01/20.
//  Copyright © 2020 Ricardo Gehrke Filho. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      let view = HomeView().environment(\.managedObjectContext, Persistency.shared.context)
      window.rootViewController = UIHostingController(rootView: view)
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}
