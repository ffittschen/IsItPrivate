//
//  NSViewController+Extension.swift
//  IsItPrivate
//
//  Created by Florian Fittschen on 26.10.18.
//  Copyright © 2018 Florian Fittschen. All rights reserved.
//

import Cocoa

@nonobjc extension NSViewController {
    func add(_ child: NSViewController, frame: CGRect? = nil) {
        addChild(child)

        if let frame = frame {
            child.view.frame = frame
        }

        view.addSubview(child.view)
    }

    func add(_ child: NSViewController, view: NSView) {
        addChild(child)
        view.addSubview(child.view)
    }

    func remove() {
        view.removeFromSuperview()
        removeFromParent()
    }
}
