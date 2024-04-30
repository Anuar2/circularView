//
//  ViewController.swift
//  CircularCollection
//
//  Created by Anuar Orazbekov on 30.04.2024.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    let collectionView: UICollectionView = {
        let layout = CircularCollectionViewLayout()
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.translatesAutoresizingMaskIntoConstraints = false
        col.register(CardCell.self, forCellWithReuseIdentifier: "cell")
        col.showsHorizontalScrollIndicator = false
        return col
    }()
    
    let contentView = ContentView()
    
    private var attributes: [CircularCollectionViewLayoutAttributes] = []
    
    private var color: [UIColor] = [.red, .green, .orange, .blue, .systemPink, .brown, .purple]
//    color = color.withCustomAlpha(0.5)
    
    private var updated: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        view.addSubview(collectionView)
        
        contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -60).isActive = true
        
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        contentView.set(colors: color)
        
        if let layout = collectionView.collectionViewLayout as? CircularCollectionViewLayout {
            layout.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        test()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return color.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CardCell
        let color = color[indexPath.item]
        cell.set(color: color, index: indexPath.row)
        return cell
    }
    
    private func test() {
        let indexPath = IndexPath(item: 6, section: 0)
        print("1111- test")
        if let layout = collectionView.collectionViewLayout as? CircularCollectionViewLayout {
            let size = layout.itemSize.width
            let calculated = (size * CGFloat(indexPath.row))

            
            let staticOffset = layout.setTarget(forProposedContentOffset: .init(x: calculated, y: 15.0), multiplier: CGFloat(indexPath.row))
            print("1111-Offset ", staticOffset)
            let newOffset: CGPoint = .init(x: staticOffset.x, y: staticOffset.y)
            print("1111-NewOffset ", newOffset)
            collectionView.setContentOffset(newOffset, animated: false)
//            scrollViewDidEndDecelerating(collectionView)
        }
        
//        if let att = attributes[safe: indexPath.item] {
//            let point: CGPoint = .init(x: att.frame.origin.x, y: att.frame.origin.y)
//            //collectionView.setContentOffset(point, animated: false)
//            print(point)
//        }
        /*
        if let layout = collectionView.collectionViewLayout as? CircularCollectionViewLayout {
            
            if !layout.allItems.isEmpty {
                for att in layout.allItems {
                    print("1111- frames: ", att.indexPath)
                    if att.indexPath == indexPath {
                        print("Scroll To Here")
                        let size = layout.itemSize
                        let point: CGPoint = .init(x: size.width * CGFloat(indexPath.item), y: att.center.y)
                        let point2: CGPoint = .init(x: att.frame.origin.x, y: att.frame.origin.y)
                        let offset = layout.targetContentOffset(forProposedContentOffset: point, withScrollingVelocity: .init(x: 0, y: 0))
                        contentView.set(index: indexPath, animated: false)
                        collectionView.setContentOffset(offset, animated: false)
                        print("What a fuck ", point)
                        break
                    }
                }
            }
        }
        */
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let cell = collectionView.centerMostCell as? CardCell else {
            print("Nothing")
            return
        }
        
        let indexPath: IndexPath = IndexPath(item: cell.getindex, section: 0)
        print("1111- Cell ", cell.frame)
        contentView.set(index: indexPath, animated: true)
    }
}

extension ViewController: LayoutDelegate {
    func getAtt(attr: [CircularCollectionViewLayoutAttributes]) {
        self.attributes = []
        self.attributes = attr
        if updated == false {
            //test()
            updated = true
        }
        
    }
}

extension UICollectionView {
    
    var centerMostCell:UICollectionViewCell? {
        guard let superview = superview else { return nil }
        let centerInWindow = superview.convert(center, to: nil)
        guard visibleCells.count > 0 else { return nil }
        var closestCell:UICollectionViewCell?
        for cell in visibleCells {
            guard let sv = cell.superview else { continue }
            let cellFrameInWindow = sv.convert(cell.frame, to: nil)
            if cellFrameInWindow.contains(centerInWindow) {
                closestCell = cell
                break
            }
        }
        return closestCell
    }
    
}


extension Array where Element == UIColor {
    func withCustomAlpha(_ alpha: CGFloat) -> [UIColor] {
        return self.map { $0.withAlphaComponent(alpha) }
    }
}
