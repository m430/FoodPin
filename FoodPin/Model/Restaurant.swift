//
//  Restaurant.swift
//  FoodPin
//
//  Created by 郑敏 on 2023/11/13.
//

import Foundation

class Restaurant: ObservableObject {
    @Published var name: String
    @Published var type: String
    @Published var location: String
    @Published var phone: String
    @Published var description: String
    @Published var image: String
    @Published var isFavorite: Bool
    @Published var rating: Rating?
    
    enum Rating: String, CaseIterable {
        case awesome
        case good
        case okay
        case bad
        case terrible
        
        var image: String {
            switch self {
            case .awesome: return "love"
            case .good: return "cool"
            case .okay: return "happy"
            case .bad: return "sad"
            case .terrible: return "angry"
            }
        }
    }
    
    init(name: String, type: String, location: String, phone :String, description: String, image: String, isFavorite: Bool, rating: Rating? = nil) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.description = description
        self.image = image
        self.isFavorite = isFavorite
        self.rating = rating
    }
    
    convenience init() {
        self.init(name: "", type: "", location: "", phone: "", description: "", image: "", isFavorite: false)
    }
}
