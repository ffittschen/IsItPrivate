//
//  SafariExtensionViewController.swift
//  Browsing
//
//  Created by Florian Fittschen on 19.10.18.
//  Copyright © 2018 Florian Fittschen. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    @IBOutlet private weak var textField: NSTextField!
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width: 160, height: 42)
        return shared
    }()

    func configureLabel(with icon: BrowsingIcon) {
        NSLog("Label for Popover: \(icon.label)")
        textField.stringValue = icon.label
    }
}
