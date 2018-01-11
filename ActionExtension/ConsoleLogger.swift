//
//  ConsoleLogger.swift
//  ActionExtension
//
//  Created by Andrew Eades on 11/01/2018.
//  Copyright © 2018 Andrew Eades. All rights reserved.
//

import Foundation

protocol ConsoleLogging {
    var appID: String { get }
    
    func log(_ message: String)
}

extension ConsoleLogging {
    func log(_ message: String) {
        NSLog("[\(appID)] \(message)")
    }
}

