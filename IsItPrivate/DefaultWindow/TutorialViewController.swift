//
//  TutorialViewController.swift
//  IsItPrivate
//
//  Created by Florian Fittschen on 25.10.18.
//  Copyright © 2018 Florian Fittschen. All rights reserved.
//

import Cocoa

class TutorialViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        preferredContentSize = view.fittingSize
    }

    @IBAction func changeBrowsingMode(_ sender: NSSegmentedControl) {
        if sender.selectedSegment == 0 {
            imageView.image = #imageLiteral(resourceName: "Tutorial_Normal")
        } else if sender.selectedSegment == 1 {
            imageView.image = #imageLiteral(resourceName: "Tutorial_Private")
        }
    }
}
