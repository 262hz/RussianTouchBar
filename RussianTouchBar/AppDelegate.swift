//
//  AppDelegate.swift
//  RussianTouchBar
//
//  Created by 262Hz on 1/6/20.
//  Copyright © 2020 262Hz LLC. All rights reserved.
//

import Cocoa


class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!

    private let customTouchBarIdentifier = "РУ" // similar to how we use "US" to designate the United States keyboard – Russian aka Русский is abbreviated with "РУ"

    private let russianTouchBarViewController = RussianTouchBarViewController()

    override init() {
        window = NSWindow(contentViewController: russianTouchBarViewController)
        super.init()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)

        let customTouchBarItem = NSCustomTouchBarItem(identifier: NSTouchBarItem.Identifier(rawValue: customTouchBarIdentifier))
        let customTouchBarItemButton = NSButton(title: customTouchBarIdentifier, target: self, action: #selector(AppDelegate.customTouchBarItemTapped))
        customTouchBarItem.view = customTouchBarItemButton
        NSTouchBarItem.addSystemTrayItem(customTouchBarItem)
        DFRElementSetControlStripPresenceForIdentifier(NSTouchBarItem.Identifier(rawValue: customTouchBarItem.identifier.rawValue), true)

        window.touchBar = russianTouchBarViewController.touchBar
        window.makeKeyAndOrderFront(nil)
    }

    @objc private func customTouchBarItemTapped() {
        NSTouchBar.presentSystemModalTouchBar(russianTouchBarViewController.touchBar, systemTrayItemIdentifier: NSTouchBarItem.Identifier(rawValue: customTouchBarIdentifier))
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

