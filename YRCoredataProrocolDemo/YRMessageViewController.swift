//
//  YRMessageViewController.swift
//  YRQuxinagtou
//
//  Created by YongRen on 16/6/14.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit
import CoreData

class YRMessageViewController: UIViewController {
    
    var dataHelper: CollectonVCHelper?
    
    private let defaultTitles = ["访客", "配对" , "最爱"]
    private let defaultInfo = ["看看最近谁来过", "与你互相喜欢的会员", "看看最爱"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    private func setUpView() {

        layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .Vertical
        layout?.minimumLineSpacing = 0.0
        layout?.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width, 76)
        view.addSubview(collectionView)
        
        let viewsDict = ["collectionView" : collectionView]
        let vflDict = ["H:|-0-[collectionView]-0-|",
                       "V:|-60-[collectionView]-0-|"]
        for obj in vflDict {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(obj as String, options: [], metrics: nil, views: viewsDict))
        }
        
        setDataController()
    }
    
    private typealias UserDataProvider = FetchedResultsDataProvider<YRMessageViewController>
    private var dataSource: YRCollectionViewDataSource<YRMessageViewController, UserDataProvider, YRChartListCell>!
    
    private func setDataController() {
        let request = YRChatUser.sortedFetchRequest
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: NSIsNilTransformerName, cacheName: nil)
        let dataProvider = FetchedResultsDataProvider(fetchedResultController: frc, delegate: self)
        dataSource = YRCollectionViewDataSource(collectionView: collectionView, dataProvider: dataProvider, delegate: self)
    }
    
    private var layout: UICollectionViewFlowLayout?
    lazy private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerClass(YRChartListCell.self, forCellWithReuseIdentifier: "YRChartListCell")
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .grayColor()
        return collectionView
    }()
}

extension YRMessageViewController: ManagedObjectContextSettable {
    
    // you can set if you wish, but here, is only getter used
    var managedObjectContext: NSManagedObjectContext! {
        set {
            self.managedObjectContext = newValue
        }
        get {
            return AppDelegate().managedObjcetContext
        }
    }
}

extension YRMessageViewController: DataProviderDelegate {
    // pass the updates from the dataProvider to tableView datascource
    func dataProviderDidUpdate(updates: [DataProviderUpdate<YRChatUser>]?) {
        dataSource.processUpdates(updates)
    }
}

extension YRMessageViewController: DataSourceDelegate {
    func cellIdentifierForObject(object: YRChatUser) -> String {
        return "YRChartListCell"
    }
}





