//
//  AlertMessage.swift
//  Beans
//
//  Created by Ricardo Gehrke on 18/01/21.
//

import Foundation

class AlertMessage: Identifiable {
    
    let title: String
    let message: String
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
