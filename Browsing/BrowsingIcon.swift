//
//  BrowsingIcon.swift
//  Browsing
//
//  Created by Florian Fittschen on 22.10.18.
//  Copyright © 2018 Florian Fittschen. All rights reserved.
//

import Foundation
import AppKit.NSImage

enum BrowsingIcon: String {
    case Mask
    case Compass
    case Unavailable
}

extension BrowsingIcon {
    var url: URL {
        return URL(fileURLWithPath: Bundle.main.path(forResource: rawValue, ofType: "pdf")!)
    }

    var label: String {
        switch self {
        case .Compass:
            return "Private Browsing: Off"
        case .Mask:
            return "Private Browsing: On"
        case .Unavailable:
            return "Private Browsing: ?"
        }
    }

    var image: NSImage {
        return NSImage(contentsOf: url)!
    }
}
