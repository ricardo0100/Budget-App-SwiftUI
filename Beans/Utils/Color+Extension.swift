//
//  Color+Extension.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/12/20.
//

import Foundation
import SwiftUI

extension Color {
    
    static func fieldBackgroundColor(for colorScheme: ColorScheme) -> Color? {
        colorScheme == .light ? Color.from(hex: "#F2F2F2") : Color.from(hex: "#363636")
    }
    
    static func redText(for colorScheme: ColorScheme) -> Color? {
        colorScheme == .light ? Color.from(hex: "#A80001") : Color.from(hex: "#EC7171")
    }
    
    static func greenText(for colorScheme: ColorScheme) -> Color? {
        colorScheme == .light ? Color.from(hex: "#027B18") : Color.from(hex: "#1DFF7B")
    }
    
    static func from(hex: String?) -> Color? {
        guard let hex = hex else { return nil }
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
                    return Color(.sRGB, red: Double(r), green: Double(g), blue: Double(b))
                }
            }
        }
        return nil
    }
}
