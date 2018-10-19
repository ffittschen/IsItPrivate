//
//  ViewController.swift
//  IsItPrivate
//
//  Created by Florian Fittschen on 19.10.18.
//  Copyright © 2018 Florian Fittschen. All rights reserved.
//

import Cocoa
import SafariServices

enum ContainerContent: String {
    case preferences
    case tutorial
}

extension ContainerContent {
    init(extensionState: SFSafariExtensionState) {
        if extensionState.isEnabled {
            self = .tutorial
        } else {
            self = .preferences
        }
    }
}

class ViewController: NSViewController {

    @IBOutlet weak var extensionStateLabel: NSTextField!
    @IBOutlet weak var openSafariPreferencesButton: NSButton!
    @IBOutlet weak var containerView: NSView!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    private var content: ContainerContent?
    private var shownViewController: NSViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        ExtensionStateManager.shared.delegate = self
        ExtensionStateManager.shared.fetchExtensionState()
    }

    @IBAction func openSafariPreferences(_ sender: NSButton) {
        SFSafariApplication.showPreferencesForExtension(withIdentifier: ExtensionStateManager.shared.extensionIdentifier) { error in
            if let error = error {
                NSLog("Error opening Safari Preferences: \(error.localizedDescription)")
            }
        }
    }

    private func transition(to content: ContainerContent) {
        shownViewController?.remove()
        let vc = createViewController(for: content)
        add(vc, view: containerView)

        shownViewController = vc
        self.content = content

        containerWidthConstraint.constant = vc.view.frame.width
        containerHeightConstraint.constant = vc.view.frame.height
    }

    private func createViewController(for content: ContainerContent) -> NSViewController {
        guard let storyboard = storyboard else {
            preconditionFailure("Can't transition to other ViewControllers without storyboard.")
        }

        switch content {
        case .preferences:
            return storyboard.instantiateController(withIdentifier: "PreferencesViewController") as! PreferencesViewController
        case .tutorial:
            return storyboard.instantiateController(withIdentifier: "TutorialViewController") as! TutorialViewController
        }
    }

    private func updateUI(for state: SFSafariExtensionState) {
        if state.isEnabled {
            extensionStateLabel.stringValue = "enabled ✅"
            openSafariPreferencesButton.title = "Open Safari Preferences"
        } else {
            extensionStateLabel.stringValue = "disabled ❌"
            openSafariPreferencesButton.title = "Enable Private Browsing Detector"
        }
    }
}

extension ViewController: ExtensionStateManagerDelegate {
    func extensionStateChanged(from oldExtensionState: SFSafariExtensionState?, to newExtensionState: SFSafariExtensionState) {
        let firstStateChange = oldExtensionState == nil
        let statesDiffer = oldExtensionState != nil && oldExtensionState!.isEnabled != newExtensionState.isEnabled

        guard firstStateChange || statesDiffer else {
            // We don't want to react to the same state
            return
        }

        updateUI(for: newExtensionState)
        transition(to: ContainerContent(extensionState: newExtensionState))
    }
}
