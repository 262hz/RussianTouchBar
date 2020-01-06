//
//  RussianTouchBar.swift
//  RussianTouchBar
//
//  Created by 262Hz on 1/6/20.
//  Copyright © 2020 262Hz LLC. All rights reserved.
//

import Cocoa

class RussianTouchBar: NSTouchBar {

    // NOTE: the custom "РУ" button would NOT work when `private let items:` only had one item... no idea why
    private let items: [NSTouchBarItem] = [HackTouchBarItem(string: "1"), HackTouchBarItem(string: "2"), HackTouchBarItem(string: "3")]

    private let actualItems: [RussianAlphabetTouchBarItem] = [RussianAlphabetTouchBarItem(identifier: "alphabet")]

    override init() {
        super.init()

        templateItems = Set(actualItems)
        defaultItemIdentifiers = [actualItems[0].identifier]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
