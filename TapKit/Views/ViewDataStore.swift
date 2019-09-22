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
    private(set) var views:Set<View> = Set<View>()

    init() {
        let momdName = "Views"
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: momdName, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        persistentContainer = NSPersistentContainer(name: momdName, managedObjectModel: mom)
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription , error) in
            if error != nil {
                fatalError("Store would not load")
            }
            self.fetchViews()
        })
    }
    
    public func fetchViews() {
        let objectContext:NSManagedObjectContext = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "View")
        do {
            let results = try objectContext.fetch(request) as! [View]
            views = Set(results)
        } catch {
            fatalError("Favorite Results failed to load or failed to convert to Photo object")
        }
    }
    
    //@REQUIRE: View's names must follow format: ViewControllerClassName.VariableName
    public func getViews<T: UIViewController>(for controller: T) -> [View] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "View")
        request.predicate = NSPredicate(format: "name BEGINSWITH[cd] $class").withSubstitutionVariables(["class" : NSStringFromClass(controller.self as! AnyClass)])
        let results = try? persistentContainer.viewContext.fetch(request)
        return results as? [View] ?? []
    }
    
    public func save(views: [ViewResponse]){
        for viewResponse in views {
            if let view = view(for: viewResponse.name){
                if view.viewResponse() != viewResponse {
                    remove(view: view)
                    add(viewResponse: viewResponse)
                }
            }else {
                add(viewResponse: viewResponse)
            }
        }
        if persistentContainer.viewContext.hasChanges {
            try? persistentContainer.viewContext.save() //TODO: proper failure handling
        }
    }
    
    private func remove(view: View){
        guard views.contains(view) else { return }
        persistentContainer.viewContext.delete(view)
        views.remove(view)
    }
    
    private func add(viewResponse: ViewResponse){
        guard view(for: viewResponse.name) == nil else { return }
        let view = View.addView(from: viewResponse, context: persistentContainer.viewContext)
        views.insert(view)
    }
    
    private func view(for name: String) -> View? {
        return views.filter { $0.name == name }.first
    }
}
