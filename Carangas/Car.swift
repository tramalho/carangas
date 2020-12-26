//
//  Car.swift
//  Carangas
//
//  Created by Thiago Antonio Ramalho on 16/12/20.
//  Copyright © 2020 Eric Brito. All rights reserved.
//

import Foundation

class Car: Codable {
    var id: String?
    var brand: String?
    var gasType: Int = 0
    var name: String?
    var price: Double?
    
    var gas: String {
        switch gasType {
        case 0:
            return "Flex"
        case 1:
            return "Álcool"
        default:
            return "Gasolina"
        }
    }
}
