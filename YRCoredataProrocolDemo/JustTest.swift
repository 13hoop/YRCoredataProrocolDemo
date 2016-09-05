//
//  JustTest.swift
//  YRCoredataProrocolDemo
//
//  Created by YongRen on 16/9/5.
//  Copyright © 2016年 YongRen. All rights reserved.
//

import UIKit

class CollectonVCHelper: NSObject, UICollectionViewDataSource {
    
    private var collectionView: UICollectionView
    required init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        self.collectionView.dataSource = self
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YRChartListCell", forIndexPath: indexPath)
        return cell
    }
}