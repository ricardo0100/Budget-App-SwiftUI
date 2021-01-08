//
//  EditAccountModel.swift
//  Beans
//
//  Created by Ricardo Gehrke on 06/12/20.
//

import Foundation

class EditAccountModel: Identifiable, Equatable {
    
    var account: Account?
    
    init(account: Account? = nil) {
        self.account = account
    }
    
    static func == (lhs: EditAccountModel, rhs: EditAccountModel) -> Bool {
        if let left = lhs.account, let right = rhs.account {
            return left == right
        }
        if lhs.account == nil && rhs.account == nil {
            return true
        }
        return false
    }
}
