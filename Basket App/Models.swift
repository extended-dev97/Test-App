//
//  Models.swift
//  Basket App
//
//  Created by Ярослав Стрельников on 02.07.2021.
//

import Foundation

typealias Description = String

enum ProductType: String, Decodable {
    case vegetable = "Овощи"
    case fruit = "Фрукты"
    case meat = "Мясо"
    case water = "Вода"
}

// MARK: - BasketData
struct BasketData: Decodable {
    let count: Int
    let response: Basket
}

// MARK: - Response
struct Basket: Decodable {
    let types: [ProductType]
    let items: [Item]
}

// MARK: - Item
struct Item: Decodable {
    let name: String
    let id: Int
    let type: String
    private let picUrl: String
    let info: Description
    
    var url: URL {
        return URL(string: picUrl)!
    }
    
    var productType: ProductType {
        if type == "vegetable" {
            return .vegetable
        } else if type == "fruit" {
            return .fruit
        } else if type == "meat" {
            return .meat
        } else {
            return .water
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case name, id, type
        case picUrl = "pic_url"
        case info
    }
}
