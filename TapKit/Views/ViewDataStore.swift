//
//  ViewDataStore.swift
//  TapKit
//
//  Created by Rob Caraway on 7/23/19.
//  Copyright © 2019 Rob Caraway. All rights reserved.
//

import UIKit
import CoreData

public class ViewDataStore {
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "TapKit.views")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription , error) in
            if error != nil {
                fatalError("Store would not load")
            }
        })
    }
    
    public func fetchViews() -> [View] {
        let objectContext:NSManagedObjectContext = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "View")
        do {
            let results = try objectContext.fetch(request) as! [View]
            return results 
        } catch {
            fatalError("Favorite Results failed to load or failed to convert to Photo object")
        }
    }

}
