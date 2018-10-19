//
//  IconFactory.swift
//  Browsing
//
//  Created by Florian Fittschen on 22.10.18.
//  Copyright © 2018 Florian Fittschen. All rights reserved.
//

import Foundation
import SafariServices

struct IconFactory {
    static func icon(for window: SFSafariWindow, _ completionHandler: @escaping (BrowsingIcon?) -> Void) {
        window.getActiveTab { tab in
            IconFactory.icon(for: tab, completionHandler)
        }
    }

    static func icon(for tab: SFSafariTab?, _ completionHandler: @escaping (BrowsingIcon?) -> Void) {
        guard let tab = tab else {
            completionHandler(nil)
            return
        }
        tab.getActivePage { page in
            IconFactory.icon(for: page, completionHandler)
        }
    }

    static func icon(for page: SFSafariPage?, _ completionHandler: @escaping (BrowsingIcon?) -> Void) {
        guard let page = page else {
            completionHandler(nil)
            return
        }
        page.getPropertiesWithCompletionHandler { properties in
            IconFactory.icon(for: properties, completionHandler)
        }
    }

    static func icon(for properties: SFSafariPageProperties?, _ completionHandler: @escaping (BrowsingIcon?) -> Void) {
        guard let properties = properties else {
            completionHandler(nil)
            return
        }
        let icon: BrowsingIcon = properties.usesPrivateBrowsing ? .Mask : .Compass
        completionHandler(icon)
    }
}
