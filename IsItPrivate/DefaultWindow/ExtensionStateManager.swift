//
//  ExtensionStateManager.swift
//  IsItPrivate
//
//  Created by Florian Fittschen on 26.10.18.
//  Copyright © 2018 Florian Fittschen. All rights reserved.
//

import Foundation
import SafariServices

protocol ExtensionStateManagerDelegate: class {
    func extensionStateChanged(from oldExtensionState: SFSafariExtensionState?, to newExtensionState: SFSafariExtensionState)
}

final class ExtensionStateManager {

    static let shared = ExtensionStateManager()

    weak var delegate: ExtensionStateManagerDelegate?

    let extensionIdentifier = "com.fittschen.IsItPrivate.Browsing"

    private var extensionState: SFSafariExtensionState? {
        didSet {
            guard let newValue = extensionState else { return }
            delegate?.extensionStateChanged(from: oldValue, to: newValue)
        }
    }

    private init() {
        fetchExtensionState()
    }

    func fetchExtensionState() {
        SFSafariExtensionManager.getStateOfSafariExtension(withIdentifier: extensionIdentifier) { [weak self] (state, error) in
            if let error = error {
                NSLog("Error fetching Safari Extension State: \(error.localizedDescription)")
            } else if let state = state {
                DispatchQueue.main.async {
                    self?.extensionState = state
                }
            }
        }
    }
}
