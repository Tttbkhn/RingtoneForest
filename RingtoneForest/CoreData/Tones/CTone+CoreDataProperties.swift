//
//  CTone+CoreDataProperties.swift
//  RingtoneForest
//
//  Created by Thu Truong on 9/12/23.
//
//

import Foundation
import CoreData


extension CTone {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CTone> {
        return NSFetchRequest<CTone>(entityName: "CTone")
    }

    @NSManaged public var name: String?
    @NSManaged public var fileName: String?
    @NSManaged public var duration: Double
    @NSManaged public var id: String?
    @NSManaged public var timestamp: Date?

}

extension CTone : Identifiable {

}
