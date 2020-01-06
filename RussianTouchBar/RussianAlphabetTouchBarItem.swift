//
//  RussianAlphabetTouchBarItem.swift
//  RussianTouchBar
//
//  Created by 262Hz on 1/6/20.
//  Copyright © 2020 262Hz LLC. All rights reserved.
//

import Cocoa

class RussianAlphabetTouchBarItem: NSTouchBarItem {

    private let russianAlphabetView = RussianAlphabetView()

    override var view: NSView? {
        return russianAlphabetView
    }

    init(identifier: String) {
        super.init(identifier: NSTouchBarItem.Identifier(rawValue: identifier))

        russianAlphabetView.wantsLayer = true
        russianAlphabetView.allowedTouchTypes = .direct
        //russianAlphabetView.layer?.backgroundColor = NSColor.systemBlue.cgColor // uncomment to see size of custom view in touch bar
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// NOTE: HackTouchBarItem was created because the custom "РУ" button would NOT work when `private let items:` only had one item... no idea why
class HackTouchBarItem: NSTouchBarItem {

    private var textField: NSTextField = {
        let textField = NSTextField(labelWithString: "")
        return textField
    }()

    override var view: NSView? {
        return textField
    }

    init(string: String) {
        super.init(identifier: NSTouchBarItem.Identifier(rawValue: string))
        textField.stringValue = identifier.rawValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
