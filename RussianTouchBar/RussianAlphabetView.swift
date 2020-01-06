//
//  RussianAlphabetView.swift
//  RussianTouchBar
//
//  Created by 262Hz on 1/6/20.
//  Copyright © 2020 262Hz LLC. All rights reserved.
//

import Cocoa

protocol HasRussianAlphabetLetter {
    var russianAlphabetLetter: RussianAlphabetLetter? { get set }
}

class RussianAlphabetLetterTextField: NSTextField, HasRussianAlphabetLetter {
    var russianAlphabetLetter: RussianAlphabetLetter?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        unhighlight()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func highlight() {
        self.textColor = NSColor.black
    }

    func unhighlight() {
        self.textColor = NSColor.white
    }
}

class RussianAlphabetLetterTextFieldView: NSView, HasRussianAlphabetLetter {
    var russianAlphabetLetter: RussianAlphabetLetter?

    private var textField: RussianAlphabetLetterTextField? {
        for view in subviews {
            if let textField = view as? RussianAlphabetLetterTextField {
                return textField
            }
        }

        return nil
    }

    func highlight() {
        layer?.backgroundColor = NSColor.white.cgColor
        textField?.highlight()
    }

    func unhighlight() {
        layer?.backgroundColor = NSColor.clear.cgColor
        textField?.unhighlight()
    }
}

class RussianAlphabetView: NSView {
    static let horizontalPadding: CGFloat = 0.0
    static let textFieldViewCornerRadius: CGFloat = 3.0
    static let fontSize: CGFloat = 17.0

    private var shouldCapitalize = false
    private let textFieldViews: [RussianAlphabetLetterTextFieldView]

    // NSView by default doesn't accept first responder, so override this to allow it.
    override var acceptsFirstResponder: Bool { return true }

    override init(frame frameRect: NSRect) {

        // Create text views and text fields
        // NOTE: we put text fields inside views because layout on touch bar was not respecting constraints with only text fields
        self.textFieldViews = RussianAlphabetLetter.allUppercaseLetters().map { (letter) -> RussianAlphabetLetterTextFieldView in
            let textField = RussianAlphabetLetterTextField(labelWithString: letter.rawValue)
            textField.font = NSFont.systemFont(ofSize: RussianAlphabetView.fontSize)
            textField.russianAlphabetLetter = letter
            textField.translatesAutoresizingMaskIntoConstraints = false
            let textFieldView = RussianAlphabetLetterTextFieldView()
            textFieldView.wantsLayer = true
            textFieldView.layer?.cornerRadius = RussianAlphabetView.textFieldViewCornerRadius
            textFieldView.russianAlphabetLetter = letter
            textFieldView.addSubview(textField)
            textFieldView.addConstraint(NSLayoutConstraint(item: textField, attribute: .centerX, relatedBy: .equal, toItem: textFieldView, attribute: .centerX, multiplier: 1.0, constant: 0))
            textFieldView.addConstraint(NSLayoutConstraint(item: textField, attribute: .centerY, relatedBy: .equal, toItem: textFieldView, attribute: .centerY, multiplier: 1.0, constant: 0))

            return textFieldView
        }

        super.init(frame: frameRect)

        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) {
            switch $0.modifierFlags.intersection(.deviceIndependentFlagsMask) {
            case [.shift], [.capsLock], [.capsLock, .shift]: // if shift, or capsLock, or shift AND capsLock are held
                self.shouldCapitalize = true
            default:
                self.shouldCapitalize = false
            }
        }

        // Layout views
        for i in 0..<textFieldViews.count {
            let textFieldView = textFieldViews[i]
            textFieldView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(textFieldView)
            if i == 0 { // first letter
                addConstraint(NSLayoutConstraint(item: textFieldView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: RussianAlphabetView.horizontalPadding))
            } else { // NOT the first letter
                addConstraint(NSLayoutConstraint(item: textFieldView, attribute: .left, relatedBy: .equal, toItem: textFieldViews[i-1], attribute: .right, multiplier: 1.0, constant: 0))
                addConstraint(NSLayoutConstraint(item: textFieldView, attribute: .width, relatedBy: .equal, toItem: textFieldViews[i-1], attribute: .width, multiplier: 1.0, constant: 0))

                if i == textFieldViews.count - 1 { // last letter
                    addConstraint(NSLayoutConstraint(item: textFieldView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: -RussianAlphabetView.horizontalPadding))
                }
            }

            addConstraint(NSLayoutConstraint(item: textFieldView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
            addConstraint(NSLayoutConstraint(item: textFieldView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func textFieldView(for letter: RussianAlphabetLetter) -> RussianAlphabetLetterTextFieldView? {
        return textFieldViews.first(where: { $0.russianAlphabetLetter == letter })
    }

    override func touchesBegan(with event: NSEvent) {

        //TODO: probably don't want to do .first here... we want ALL touches that just began

        for touch in event.touches(matching: .began, in: self) {
            guard touch.type == .direct else { continue }
            let location = touch.location(in: self)
            var letter: RussianAlphabetLetter? = nil
            if let view = self.hitTest(location) {
                if let view = view as? HasRussianAlphabetLetter {
                    letter = view.russianAlphabetLetter
                }
            }

            if let letter = letter {
                textFieldView(for: letter)?.highlight()

                var stringValue = letter.rawValue
                if shouldCapitalize == false {
                    stringValue = stringValue.lowercased()
                }
                KeyEvent.typeRussianLetter(russianLetter: stringValue)
            }
        }
    }

    override func touchesMoved(with event: NSEvent) {
        for touch in event.touches(matching: .moved, in: self) {
            guard touch.type == .direct else { continue }
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            var letter: RussianAlphabetLetter? = nil
            var previousLetter: RussianAlphabetLetter? = nil

            if let view = self.hitTest(location) {
                if let view = view as? HasRussianAlphabetLetter {
                    letter = view.russianAlphabetLetter
                }
            }

            if let view = self.hitTest(previousLocation) {
                if let view = view as? HasRussianAlphabetLetter {
                    previousLetter = view.russianAlphabetLetter
                }
            }

            if let previousLetter = previousLetter, letter != previousLetter {
                textFieldView(for: previousLetter)?.unhighlight()
            }
        }
    }

    override func touchesEnded(with event: NSEvent) {
        for touch in event.touches(matching: .ended, in: self) {
            guard touch.type == .direct else { continue }
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            var letter: RussianAlphabetLetter? = nil
            var previousLetter: RussianAlphabetLetter? = nil

            if let view = self.hitTest(location) {
                if let view = view as? HasRussianAlphabetLetter {
                    letter = view.russianAlphabetLetter
                }
            }

            if let view = self.hitTest(previousLocation) {
                if let view = view as? HasRussianAlphabetLetter {
                    previousLetter = view.russianAlphabetLetter
                }
            }

            if let previousLetter = previousLetter, letter != previousLetter {
                textFieldView(for: previousLetter)?.unhighlight()
            }

            if let letter = letter {
                textFieldView(for: letter)?.unhighlight()
            }
        }
    }

    override func touchesCancelled(with event: NSEvent) {
        for touch in event.touches(matching: .cancelled, in: self) {
            guard touch.type == .direct else { continue }
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            var letter: RussianAlphabetLetter? = nil
            var previousLetter: RussianAlphabetLetter? = nil

            if let view = self.hitTest(location) {
                if let view = view as? HasRussianAlphabetLetter {
                    letter = view.russianAlphabetLetter
                }
            }

            if let view = self.hitTest(previousLocation) {
                if let view = view as? HasRussianAlphabetLetter {
                    previousLetter = view.russianAlphabetLetter
                }
            }

            if let previousLetter = previousLetter, letter != previousLetter {
                textFieldView(for: previousLetter)?.unhighlight()
            }

            if let letter = letter {
                textFieldView(for: letter)?.unhighlight()
            }
        }
    }
}
