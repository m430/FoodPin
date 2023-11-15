//
//  Restaurant+CoreDataProperties.swift
//  FoodPin
//
//  Created by 郑敏 on 2023/11/15.
//
//

import Foundation
import CoreData


extension Restaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }

    @NSManaged public var image: Data?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var location: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var ratingText: String?
    @NSManaged public var summary: String?
    @NSManaged public var type: String?

}

extension Restaurant : Identifiable {

}
