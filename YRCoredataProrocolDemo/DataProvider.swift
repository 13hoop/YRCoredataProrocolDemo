//
//  DataProvider.swift
//  YRCoredataProrocolDemo
//
//  Created by YongRen on 16/9/5.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

// dataSource
protocol DataProvider: class {
    associatedtype Object // 可以是任意的类型
    // 得到具体的model
    func objectAtIndexPath(indexPath: NSIndexPath) -> Object
    // section
    func numberOfItemsInSection(section: Int) -> Int
}

// MARK: ---- FetchedResultsDataProvider -----
protocol DataProviderDelegate: class {
    associatedtype Object
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Object>]?)
}

enum DataProviderUpdate<T> {
    case Insert(NSIndexPath)
    case Update(NSIndexPath, T)
    case Move(NSIndexPath, NSIndexPath)
    case Delete(NSIndexPath)
}


// MARK: -- cell ---
// cell identifier
protocol DataSourceDelegate: class {
    associatedtype Object
    func cellIdentifierForObject(object: Object) -> String
}

// MARK: config cell protocol
protocol YRCellConfigurabled {
    associatedtype ModelData
    func configuireCellWithData(data: ModelData)
}




// MARK: *** class extension ***
extension NSURL {
    static var documentsURL: NSURL {
        return try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
    }
}
