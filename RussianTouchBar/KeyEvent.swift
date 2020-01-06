//
//  KeyEvent.swift
//  Russian Touch Bar
//
//  Created by 262Hz on 1/6/20.
//  Copyright © 2020 262Hz LLC. All rights reserved.
//

import Cocoa

struct KeyEvent {
    // NOTE: this func was inspired by Touch Bar Emojis app: https://github.com/gabriellorin/touch-bar-emojis
    static func typeRussianLetter(russianLetter: String) {

        let source = CGEventSource(stateID: .hidSystemState)
        // event for key down event:
        let eventKey = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true)
        // event for key up event:
        let eventKeyUp = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false)

        // split the string into an array:
        var utf16array = Array(russianLetter.utf16)

        // set the string for the key down event:
        eventKey?.keyboardSetUnicodeString(stringLength: utf16array.count, unicodeString: &utf16array)
        // set the string for the key up event:
        eventKeyUp?.keyboardSetUnicodeString(stringLength: utf16array.count, unicodeString: &utf16array)
        // post key down event:
        eventKey?.post(tap: CGEventTapLocation.cghidEventTap)
        // post key up event:
        eventKeyUp?.post(tap: CGEventTapLocation.cghidEventTap)
    }
}
