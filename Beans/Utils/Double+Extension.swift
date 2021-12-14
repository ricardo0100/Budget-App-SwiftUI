//
//  Double+Extension.swift
//  Beans
//
//  Created by Ricardo Gehrke Filho on 13/12/21.
//

import Foundation

extension Double {
    
    func toIntegerPercentString() -> String {
        String(format: "%.1f%%", self)
    }
}
