//
//  GetResourceResponse.swift
//  Beans
//
//  Created by Ricardo Gehrke on 13/02/21.
//

import Foundation

protocol GetResourceResponse: Decodable {
    
    var id: Int { get }
}
