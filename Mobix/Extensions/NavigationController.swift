//
//  NavigationController.swift
//  Mobix
//
//  Created by Bartosz Kulasiewicz on 14/09/2021.
//

import Foundation
import UIKit


extension UINavigationController {
    func setupBaseNavigationController() {
        isNavigationBarHidden = false
        navigationBar.setupTransluentVC()
    }
}
