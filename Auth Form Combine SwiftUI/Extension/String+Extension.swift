//
//  String+Extension.swift
//  Auth Form Combine SwiftUI
//
//  Created by Dmitry Novosyolov on 14/03/2021.
//

import Foundation

extension String {
    var isEmail: Bool {
        guard !lowercased().hasPrefix("mailto:") else { return false }
        var matches: [NSTextCheckingResult] = []
        do {
            matches =
                try
                NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                .matches(in: self, options: .anchored, range: NSRange(0..<count))
        } catch {
            print(#function, error.localizedDescription)
        }
        return
            matches.count != 0 ? matches[0].url?.scheme == "mailto" : false
    }
}
