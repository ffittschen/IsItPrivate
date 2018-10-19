//
//  PreferencesViewController.swift
//  IsItPrivate
//
//  Created by Florian Fittschen on 25.10.18.
//  Copyright © 2018 Florian Fittschen. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        preferredContentSize = view.fittingSize
    }
    
}
