//
//  Color+Extension.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/12/20.
//

import Foundation
import SwiftUI

extension Color {
    
    static let currencyGreen = Color.from(hex: "#1E8449")
    static let currencyRed = Color.from(hex: "#CB4335")
    
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
    
    func darker(by amount: CGFloat = 0.1) -> Color {
        let uiColor = UIColor(self)
        guard
            var red = uiColor.cgColor.components?[0],
            var green = uiColor.cgColor.components?[1],
            var blue = uiColor.cgColor.components?[2],
            let opacity = uiColor.cgColor.components?[3]
        else { return self }
        
        red = CGFloat.minimum(red - amount, 1)
        green = CGFloat.minimum(green - amount, 1)
        blue = CGFloat.minimum(blue - amount, 1)
        
        return Color(.sRGB, red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(opacity))
    }
    
    func lighter(by amount: CGFloat = 0.1) -> Color {
        let uiColor = UIColor(self)
        guard
            var red = uiColor.cgColor.components?[0],
            var green = uiColor.cgColor.components?[1],
            var blue = uiColor.cgColor.components?[2],
            let opacity = uiColor.cgColor.components?[3]
        else { return self }
        
        red = CGFloat.minimum(red + amount, 1)
        green = CGFloat.minimum(green + amount, 1)
        blue = CGFloat.minimum(blue + amount, 1)
        
        return Color(.sRGB, red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(opacity))
    }
}
