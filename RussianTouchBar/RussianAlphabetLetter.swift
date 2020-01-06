//
//  RussianAlphabetLetter.swift
//  RussianTouchBar
//
//  Created by 262Hz on 1/6/20.
//  Copyright © 2020 262Hz LLC. All rights reserved.
//

import Foundation

enum RussianAlphabetLetter: String {
    case А = "А"
    case Б = "Б"
    case В = "В"
    case Г = "Г"
    case Д = "Д"
    case Е = "Е"
    case Ё = "Ё"
    case Ж = "Ж"
    case З = "З"
    case И = "И"
    case Й = "Й"
    case К = "К"
    case Л = "Л"
    case М = "М"
    case Н = "Н"
    case О = "О"
    case П = "П"
    case Р = "Р"
    case С = "С"
    case Т = "Т"
    case У = "У"
    case Ф = "Ф"
    case Х = "Х"
    case Ц = "Ц"
    case Ч = "Ч"
    case Ш = "Ш"
    case Щ = "Щ"
    case Ъ = "Ъ"
    case Ы = "Ы"
    case Ь = "Ь"
    case Э = "Э"
    case Ю = "Ю"
    case Я = "Я"


    static func allUppercaseLetters() -> [RussianAlphabetLetter] {
        return [А, Б, В, Г, Д, Е, Ё, Ж, З, И, Й, К, Л, М, Н, О, П, Р, С, Т, У, Ф, Х, Ц, Ч, Ш, Щ, Ъ, Ы, Ь, Э, Ю, Я]
    }
}
