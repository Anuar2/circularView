//
//  CircularCollectionViewLayoutAttributes.swift
//  CircularCollection
//
//  Created by Anuar Orazbekov on 30.04.2024.
//

import UIKit

protocol LayoutDelegate: AnyObject {
    func getAtt(attr: [CircularCollectionViewLayoutAttributes])
}

class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var anchorPoint = CGPoint(x: 0.5, y: 0.5)

    var angle: CGFloat = 0 {
        
        didSet {
            zIndex = Int(angle * 1000000)
            transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
      let copiedAttributes: CircularCollectionViewLayoutAttributes = super.copy(with: zone) as! CircularCollectionViewLayoutAttributes
      copiedAttributes.anchorPoint = self.anchorPoint
      copiedAttributes.angle = self.angle
      return copiedAttributes
    }
}

class CircularCollectionViewLayout: UICollectionViewLayout {
    let itemSize = CGSize(width: 170, height: 170)

    var angleAtExteme: CGFloat {
        return collectionView!.numberOfItems(inSection: 0) > 0 ?
          -CGFloat(collectionView!.numberOfItems(inSection: 0) - 1) * anglePerItem : 0
    }
    
    var angle: CGFloat {
      return angleAtExteme * collectionView!.contentOffset.x / (collectionViewContentSize.width -
        collectionView!.bounds.width)
    }
    
    var radius: CGFloat = 500 {
      didSet {
        invalidateLayout()
      }
    }
    
    var anglePerItem: CGFloat {
      return atan((itemSize.width + 20) / radius)
    }
    
    var attributesList = [CircularCollectionViewLayoutAttributes]()

    var allItems = [CircularCollectionViewLayoutAttributes]()

    weak var delegate: LayoutDelegate?
    
    
    func getFrame(at index: IndexPath) -> CGRect {
        guard let att = attributesList[safe: index.item] else { return .zero }
        return att.frame
    }
    
    override var collectionViewContentSize: CGSize {
      let collection = collectionView!
      let width = CGFloat(collection.numberOfItems(inSection: 0)) * itemSize.width
      let height = collectionView!.bounds.height
      
      return CGSize(width: width, height: height)
    }
    
    class func layoutAttributesClass() -> AnyClass {
      return CircularCollectionViewLayoutAttributes.self
    }
    
    override func prepare() {
        super.prepare()
        
        let centerX = collectionView!.contentOffset.x + (collectionView!.bounds.width / 2.0)
        let anchorPointY = ((itemSize.height / 2.0) + radius) / itemSize.height
        
        let theta = atan2(collectionView!.bounds.width / 2.0,
                          radius + (itemSize.height / 2.0) - (collectionView!.bounds.height / 2.0))
        // 2
        var startIndex = 0
        var endIndex = collectionView!.numberOfItems(inSection: 0) - 1
        // 3
        if (angle < -theta) {
            startIndex = Int(floor((-theta - angle) / anglePerItem))
        }
        // 4
        endIndex = min(endIndex, Int(ceil((theta - angle) / anglePerItem)))
        // 5
        if (endIndex < startIndex) {
            endIndex = 0
            startIndex = 0
        }
        
        //    attributesList = (0..<collectionView!.numberOfItemsInSection(0)).map { (i)
        //      -> CircularCollectionViewLayoutAttributes in
        attributesList = (startIndex...endIndex).map { (i)
            -> CircularCollectionViewLayoutAttributes in
            // 1
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            
            attributes.size = self.itemSize
            // 2
            attributes.center = CGPoint(x: centerX, y: self.collectionView!.bounds.midY)
            // 3
            //attributes.angle = self.anglePerItem*CGFloat(i)
            attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
            
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            return attributes
        }
        
        allItems = (0..<collectionView!.numberOfItems(inSection: 0)).map { (i) -> CircularCollectionViewLayoutAttributes in
            let attributes = CircularCollectionViewLayoutAttributes(forCellWith: IndexPath(item: i, section: 0))
            attributes.size = self.itemSize
            attributes.center = CGPoint(x: centerX, y: self.collectionView!.bounds.midY)
            attributes.angle = self.angle + (self.anglePerItem * CGFloat(i))
            attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
            return attributes
        }
        
        
        if !allItems.isEmpty {
            delegate?.getAtt(attr: allItems)
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      return attributesList
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesList[safe: indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
      return true
    }
    
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var finalContentOffset = proposedContentOffset
        let factor = -angleAtExteme/(collectionViewContentSize.width - collectionView!.bounds.width)
        let proposedAngle = proposedContentOffset.x*factor
        let ratio = proposedAngle/anglePerItem
        var multiplier: CGFloat
        if (velocity.x > 0) {
            multiplier = ceil(ratio)
        } else if (velocity.x < 0) {
            multiplier = floor(ratio)
        } else {
            multiplier = round(ratio)
        }
        finalContentOffset.x = multiplier*anglePerItem/factor
        return finalContentOffset
    }
    
    func setTarget(forProposedContentOffset proposedContentOffset: CGPoint, multiplier: CGFloat) -> CGPoint {
        var finalContentOffset = proposedContentOffset
        let factor = -angleAtExteme/(collectionViewContentSize.width - collectionView!.bounds.width)
        finalContentOffset.x = multiplier*anglePerItem/factor
        return finalContentOffset
    }
}


extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
