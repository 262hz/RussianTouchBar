//
//  RussianTouchBarViewController.swift
//  RussianTouchBar
//
//  Created by 262Hz on 1/6/20.
//  Copyright © 2020 262Hz LLC. All rights reserved.
//

import Cocoa

class RussianTouchBarViewController: NSViewController {

    private let russianTouchBar = RussianTouchBar()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = NSView()
    }

    override func makeTouchBar() -> NSTouchBar? {
        return russianTouchBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
