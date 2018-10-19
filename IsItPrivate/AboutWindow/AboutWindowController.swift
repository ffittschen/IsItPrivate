//
//  AboutWindowController.swift
//  IsItPrivate
//
//  Created by Florian Fittschen on 26.10.18.
//  Copyright © 2018 Florian Fittschen. All rights reserved.
//

import Cocoa

class AboutWindowController: NSWindowController {

    @IBOutlet weak var applicationNameLabel: NSTextField!
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var buildLabel: NSTextField!
    @IBOutlet weak var creatorLabel: ActionLabel!
    @IBOutlet weak var repositoryLabel: ActionLabel!
    @IBOutlet weak var maskCreatorLabel: ActionLabel!
    @IBOutlet weak var compassCreatorLabel: ActionLabel!
    @IBOutlet weak var licenseLabel: NSTextField!

    convenience init() {
        self.init(windowNibName: "AboutWindowController")
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        // close the window when the escape key is pressed
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            guard event.keyCode == 53 else { return event }

            self.closeAnimated()

            return nil
        }

        window?.collectionBehavior = [.transient, .ignoresCycle]
        window?.isMovableByWindowBackground = true

        guard let info = Bundle.main.infoDictionary else { return }

        configureUIFor(infoDictionary: info)
    }

    private func configureUIFor(infoDictionary info: [String: Any]) {
        applicationNameLabel.stringValue = info.stringOrEmpty(for: "CFBundleName")
        versionLabel.stringValue = info.stringOrEmpty(for: "CFBundleShortVersionString")
        buildLabel.stringValue = info.stringOrEmpty(for: "CFBundleVersionString")
        licenseLabel.stringValue = info.stringOrEmpty(for: "FFBundleLicenseName")
        creatorLabel.stringValue = info.stringOrEmpty(for: "FFBundleMainDeveloperName")
        repositoryLabel.stringValue = info.stringOrEmpty(for: "FFBundleRepositoryName")

        mainDeveloperWebsite = URL(string: info.stringOrEmpty(for: "FFBundleMainDeveloperWebsite"))
        repositoryWebsite = URL(string: info.stringOrEmpty(for: "FFBundleRepositoryWebsite"))
        maskCreatorWebsite = URL(string: info.stringOrEmpty(for: "FFBundleMaskIconCreatorWebsite"))
        compassCreatorWebsite = URL(string: info.stringOrEmpty(for: "FFBundleCompassIconCreatorWebsite"))

        configureActionLabel(creatorLabel, selector: #selector(openMainDeveloperWebsite))
        configureActionLabel(repositoryLabel, selector: #selector(openRepositoryWebsite))
        configureActionLabel(maskCreatorLabel, selector: #selector(openMaskIconCreatorWebsite))
        configureActionLabel(compassCreatorLabel, selector: #selector(openCompassIconCreatorWebsite))

    }

    private func configureActionLabel(_ label: ActionLabel, selector: Selector) {
        label.alphaValue = 0.8
        label.textColor = NSColor(red:0.023, green:0.752, blue:0.905, alpha:1)
        label.target = self
        label.action = selector
    }

    private var mainDeveloperWebsite: URL?
    private var repositoryWebsite: URL?
    private var maskCreatorWebsite: URL?
    private var compassCreatorWebsite: URL?

    @IBAction private func openMainDeveloperWebsite(_ sender: Any) {
        guard let mainDeveloperWebsite = mainDeveloperWebsite else { return }

        NSWorkspace.shared.open(mainDeveloperWebsite)
    }

    @IBAction private func openRepositoryWebsite(_ sender: Any) {
        guard let repositoryWebsite = repositoryWebsite else { return }

        NSWorkspace.shared.open(repositoryWebsite)
    }

    @IBAction private func openMaskIconCreatorWebsite(_ sender: Any) {
        guard let maskCreatorWebsite = maskCreatorWebsite else { return }

        NSWorkspace.shared.open(maskCreatorWebsite)
    }

    @IBAction private func openCompassIconCreatorWebsite(_ sender: Any) {
        guard let compassCreatorWebsite = compassCreatorWebsite else { return }

        NSWorkspace.shared.open(compassCreatorWebsite)
    }

    override func showWindow(_ sender: Any?) {
        window?.center()
        window?.alphaValue = 0.0

        super.showWindow(sender)

        window?.animator().alphaValue = 1.0
    }

    private func closeAnimated() {
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.4
        NSAnimationContext.current.completionHandler = {
            self.close()
        }
        window?.animator().alphaValue = 0.0
        NSAnimationContext.endGrouping()
    }

}

fileprivate extension Dictionary where Key == String, Value == Any {
    fileprivate func stringOrEmpty(for key: String) -> String {
        return (self[key] as? String) ?? ""
    }
}
