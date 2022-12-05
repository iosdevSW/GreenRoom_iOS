//
//  RecentSearchKeyword+CoreDataProperties.swift
//  
//
//  Created by Doyun Park on 2022/08/26.
//
//

import Foundation
import CoreData


extension RecentSearchKeyword {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearchKeyword> {
        return NSFetchRequest<RecentSearchKeyword>(entityName: "RecentSearchKeyword")
    }

    @NSManaged public var date: Date?
    @NSManaged public var keyword: String?
    @NSManaged public var index: Int32

}
