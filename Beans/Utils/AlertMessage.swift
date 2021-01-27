//
//  AlertMessage.swift
//  Beans
//
//  Created by Ricardo Gehrke on 18/01/21.
//

import Foundation

class AlertMessage: Identifiable, Equatable {
    
    let title: String
    let message: String
    
    static func == (lhs: AlertMessage, rhs: AlertMessage) -> Bool {
        lhs.title == rhs.title && lhs.message == rhs.message
    }
    
    init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
