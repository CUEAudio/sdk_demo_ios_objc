//
//  SwiftFile.swift
//  CUEControllerDemo
//
//  Created by Jameson Rader on 1/28/19.
//  Copyright © 2019 CUE Audio, LLC. All rights reserved.
//

import Foundation
import CUELive

@objc class SwiftHelper: NSObject {

    @objc static func getInitialViewController() -> UIViewController {
        return NavigationManager.initialController()
    }
}
