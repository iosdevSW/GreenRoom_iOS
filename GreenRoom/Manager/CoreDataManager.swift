//
//  CoreDataManager.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/26.
//

import UIKit
import CoreData

enum CoreDataName: String {
    case recentSearch = "RecentSearchKeyword"
}

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    // MARK: - 해당 정보를 저장한다
    func saveRecentSearch(keyword: String, date: Date, completion: @escaping (Bool) -> Void) {
        guard let context = self.context,
            let entity = NSEntityDescription.entity(forEntityName: CoreDataName.recentSearch.rawValue, in: context)
            else { return }

        guard let recentTerms = NSManagedObject(entity: entity, insertInto: context) as? RecentSearchKeyword else { return }
        
        recentTerms.keyword = keyword
        recentTerms.date = date

        do {
            try context.save()
            completion(true)
        } catch {
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    // MARK: - 저장된 모든 정보를 가져온다
    func loadFromCoreData<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        guard let context = self.context else { return [] }
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
