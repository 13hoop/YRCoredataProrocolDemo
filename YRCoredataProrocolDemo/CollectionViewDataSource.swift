//
//  CollectionViewDataSource.swift
//  YRCoredataProrocolDemo
//
//  Created by YongRen on 16/9/5.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class YRCollectionViewDataSource<Delegate: DataSourceDelegate, Data: DataProvider, Cell: UICollectionViewCell where Delegate.Object == Data.Object, Cell: YRCellConfigurabled, Cell.ModelData == Data.Object>: NSObject, UICollectionViewDataSource {
    
    private let collectionView: UICollectionView
    private let dataProvider: Data
    private weak var delegate: Delegate!
    
    required init(collectionView: UICollectionView, dataProvider: Data, delegate: Delegate) {
        self.collectionView = collectionView
        self.dataProvider = dataProvider
        self.delegate = delegate
        super.init()
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func processUpdates(updates: [DataProviderUpdate<Data.Object>]?) {
        guard let updates = updates else { return collectionView.reloadData() }
        collectionView.performBatchUpdates({
            for update in updates {
                switch update {
                case .Insert(let indexPath):
                    self.collectionView.insertItemsAtIndexPaths([indexPath])
                case .Update(let indexPath, let object):
                    guard let cell = self.collectionView.cellForItemAtIndexPath(indexPath) as? Cell else { fatalError("wrong cell type") }
                    cell.configuireCellWithData(object)
                case .Move(let indexPath, let newIndexPath):
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                    self.collectionView.insertItemsAtIndexPaths([newIndexPath])
                case .Delete(let indexPath):
                    self.collectionView.deleteItemsAtIndexPaths([indexPath])
                }
            }
            }, completion: nil)
    }
    
    //  -- collectionViewDataSource --
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.numberOfItemsInSection(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let object = dataProvider.objectAtIndexPath(indexPath)
        let identifier = delegate.cellIdentifierForObject(object)
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? Cell
            else {
                fatalError("unknown cell identifer at \(indexPath)")
        }
        cell.configuireCellWithData(object)
        return cell
    }
}