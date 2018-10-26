//
//  SafariExtensionHandler.swift
//  Browsing
//
//  Created by Florian Fittschen on 19.10.18.
//  Copyright © 2018 Florian Fittschen. All rights reserved.
//

import SafariServices

class SafariExtensionHandler: SFSafariExtensionHandler {

    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").

        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
        }
    }
    
    override func toolbarItemClicked(in window: SFSafariWindow) {
        // This method will be called when your toolbar item is clicked.
        NSLog("The extension's toolbar item was clicked")
    }
    
    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        // This is called when Safari's state changed in some way that would require the extension's toolbar item to be validated again.
        NSLog("The extension's toolbar item was validated")

        IconFactory.icon(for: window) { icon in
            guard let icon = icon else { return }
            NSLog("Icon for window: \(icon)")
            window.getToolbarItem { toolbarItem in
                toolbarItem?.setImage(icon.image)
                toolbarItem?.setLabel(icon.label)
            }
        }

        validationHandler(true, "")
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

    override func popoverWillShow(in window: SFSafariWindow) {
        IconFactory.icon(for: window) { icon in
            guard let icon = icon else { return }
            SafariExtensionViewController.shared.configureLabel(with: icon)
        }
    }
}
