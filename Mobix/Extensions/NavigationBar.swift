//
//  NavigationBar.swift
//  Mobix
//
//  Created by Bartosz Kulasiewicz on 14/09/2021.
//

import Foundation
import UIKit



extension UINavigationBar {
    
    func setupTransluentVC() {
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        barStyle = .black
        tintColor = .white
    }
}


