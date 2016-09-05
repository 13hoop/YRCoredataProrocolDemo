//
//  YRCoredataHelper.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/8/18.
//  maybe hard for beginner, QQ: 9124531142
//  Copyright © 2016年 YongRen. All rights reserved.
//
import Foundation
import CoreData

// MARK: ---- ManagedObject in swift <--> NSManagedObject -----

public class ManagedObject: NSManagedObject {

}

// MARK: --- ManagedObjectType ---

// just using to simplify model class, keep code easy to maintain
public protocol ManagedObjectType: class {
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}
// default implementation protocal in Swift’s protocol extensions
extension ManagedObjectType {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    public static var sortedFetchRequest: NSFetchRequest {
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}


// MARK: ---- DataProviderDelegate -----

class FetchedResultsDataProvider<Delegate: DataProviderDelegate>: NSObject, NSFetchedResultsControllerDelegate, DataProvider {
    
    // T
    typealias Object = Delegate.Object
    
    private var fetchedResultsController: NSFetchedResultsController
    private weak var delegate: Delegate!
    private var updates: [DataProviderUpdate<Object>] = []
    
    init(fetchedResultController: NSFetchedResultsController, delegate: Delegate) {
        
        self.fetchedResultsController = fetchedResultController
        self.delegate = delegate
        super.init()
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        }catch {
            fatalError(" dataProvider can not performFetch error: /n \(error)")
        }
    }
    
    // DataProvider
    func objectAtIndexPath(indexPath: NSIndexPath) -> FetchedResultsDataProvider.Object {
        guard let result = fetchedResultsController.objectAtIndexPath(indexPath) as? Object else {
            fatalError(" unknow fetched result object type at \(indexPath)")
        }
        return result
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        guard let sectionInfoes = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfoes.numberOfObjects
    }
    
    // -- FetchedResultsControllerDelegate --
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        print(#function)

    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        print(#function)

    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        delegate.dataProviderDidUpdate(updates)
        print(#function)
    }
}