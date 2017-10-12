//
//  LLCollectionViewLayout.swift
//  WaterFallTest
//
//  Created by gleeeli on 2017/10/11.
//  Copyright © 2017年 gleeeli. All rights reserved.
//

import UIKit

class LLCollectionViewLayout: UICollectionViewLayout {
    //所有列最大的Y值数组
    var columnMaxYs = Array<Float>()
    var attrsArray = Array<UICollectionViewLayoutAttributes>()
    //行间距
    let defaultRowMargin = 10
    //列间距
    let defaultColumnMargin = 10
    //距离整个section的边距
    let defaultInsets:UIEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
    //列数
    let defaultColumsCount = 3
    
    
    //返回colletionView可滑动范围大小
    override var collectionViewContentSize: CGSize{
        var destMaxY  = self.columnMaxYs[0]
        for columnMaxY in self.columnMaxYs {
            if destMaxY<columnMaxY {
                destMaxY=columnMaxY
            }
        }
        
        return CGSize.init(width: 0, height: CGFloat(destMaxY)+defaultInsets.bottom)
    }
    
    //初始化
    override func prepare() {
        super.prepare()
        //初始保存每一列ite的y最大值都为0
        columnMaxYs.removeAll()
        columnMaxYs.append(0)
        columnMaxYs.append(0)
        columnMaxYs.append(0)
        
        self.attrsArray.removeAll()
        
        var counts:Int
        counts = (self.collectionView?.numberOfItems(inSection: 0))!
        for nums in 0...counts-1 {
            
            let indexP:NSIndexPath = NSIndexPath.init(item: nums, section: 0)
            //初始化每个cell按瀑布流布局
            let attrs  = self.layoutAttributesForItem(at: indexP as IndexPath)
            self.attrsArray.append(attrs!)
        }
        
        
    }
    
    //给每个cell重新设置frame
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        //取道对应cell的属性
        let itemAttrs:UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        //水平方向总间距
        let xTotalMargin = Float(defaultInsets.left)+Float(defaultInsets.right) + Float((defaultColumsCount-1)*defaultColumnMargin)
        let width:Float = (Float((self.collectionView?.frame.size.width)!) - xTotalMargin)/Float(defaultColumsCount)
        //设置一个随机的高度(可从后台获取图片高度进行计算)
        let height:Float = 50+Float(arc4random_uniform(150))
        
        var destMaxY:Float = Float(self.columnMaxYs[0])
        var destColumn = 0
        //找到每列Y坐标最大的
        for i in 0...self.columnMaxYs.count-1 {
            let columnMaxy:Float  = Float(self.columnMaxYs[i])
            if destMaxY>columnMaxy {
                destMaxY = columnMaxy
                destColumn = i;
            }
            
        }
        
        let x:Float = Float(defaultInsets.left)+Float(destColumn)*(width+Float(defaultColumnMargin))
        let y:Float = destMaxY+Float(defaultRowMargin)
        
        
        itemAttrs.frame = CGRect.init(x:  CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height))
        self.columnMaxYs[destColumn] = Float(itemAttrs.frame.origin.y+itemAttrs.frame.size.height)
        
        return itemAttrs
        
    }
    
    
    //返回已编辑好的item的frame属性数组
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    
    
    //重新定义每个cell的属性
    
    
}

