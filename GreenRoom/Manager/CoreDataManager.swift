//
//  CoreDataManager.swift
//  GreenRoom
//
//  Created by Doyun Park on 2022/08/26.
//

import UIKit
import CoreData
import RxSwift

enum CoreDataName: String {
    case recentSearch = "RecentSearchKeyword"
}

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    // MARK: - 해당 정보를 저장한다
    func saveRecentSearch(keyword: String, date: Date) -> Observable<Bool> {
        
        return Observable<Bool>.create { observer in
            guard let context = self.context,
                let entity = NSEntityDescription.entity(forEntityName: CoreDataName.recentSearch.rawValue, in: context),
                  let recentTerms = NSManagedObject(entity: entity, insertInto: context) as? RecentSearchKeyword
            else { return Disposables.create() }
            
            recentTerms.keyword = keyword
            recentTerms.date = date
            
            do {
                try context.save()
                observer.onNext(true)
            } catch {
                print(error.localizedDescription)
                observer.onNext(false)
            }
            return Disposables.create()
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
