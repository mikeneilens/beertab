//
//  TextField.swift
//  beertab
//
//  Created by Michael Neilens on 17/11/2020.
//

import UIKit
extension UITextField {
    func inPence() -> Int {
        guard let text = self.text?
                .split(separator:" ").joined()
                .split(separator:"£").joined() else {return 0}
        return Currency(text).inPence
    }
}
extension Optional where Wrapped ==  UITextField {
    func inPence() -> Int {
        guard let textField = self else {return 0}
        return textField.inPence()
    }
}
