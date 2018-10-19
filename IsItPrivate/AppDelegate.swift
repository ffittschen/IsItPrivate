//
//  AppDelegate.swift
//  IsItPrivate
//
//  Created by Florian Fittschen on 19.10.18.
//  Copyright © 2018 Florian Fittschen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    private lazy var aboutWindowController: AboutWindowController = {
        return AboutWindowController()
    }()

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationWillBecomeActive(_ notification: Notification) {
        ExtensionStateManager.shared.fetchExtensionState()
        
    }

    @IBAction func showAboutWindow(_ sender: NSMenuItem) {
        aboutWindowController.showWindow(nil)
    }
}
