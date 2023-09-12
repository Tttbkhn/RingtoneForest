//
//  ProductStore+CoreDataProperties.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/12/23.
//
//

import Foundation
import CoreData


extension ProductStore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductStore> {
        return NSFetchRequest<ProductStore>(entityName: "ProductStore")
    }

    @NSManaged public var dateBuy: Date?
    @NSManaged public var dateExpired: Date?
    @NSManaged public var id: String?
    @NSManaged public var name: String?

}

extension ProductStore : Identifiable {

}
