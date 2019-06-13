//
//  UIViewController+Storyboards.swift
//  AppRealTestTask
//
//  Created by Roman Rybachenko on 6/13/19.
//  Copyright © 2019 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    static func storyboardInstance(_ storyboard: Storyboard) -> Self {
        return storyboard.viewController(self)
    }
    
}


enum Storyboard: String {
    
    case main = "Main"
    
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
    
    func viewController<T: UIViewController> (_ vcClass: T.Type) -> T {
        let storyboardId = String(describing: T.self)
        return self.instance.instantiateViewController(withIdentifier: storyboardId) as! T
    }
    
}
