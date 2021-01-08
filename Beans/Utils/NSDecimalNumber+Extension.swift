//
//  NSDecimalNumber+Extension.swift
//  Beans
//
//  Created by Ricardo Gehrke on 04/12/20.
//

import Foundation

extension NSDecimalNumber {
    
    func toCurrency(with locale: Locale = .current) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: self)
    }
}
