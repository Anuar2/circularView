//
//  CardCell.swift
//  CircularCollection
//
//  Created by Anuar Orazbekov on 30.04.2024.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    var getindex: Int {
        return index ?? 0
    }
    
    private var containerView: UIView = {
       let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.cornerRadius = 20
        cv.layer.cornerCurve = .continuous
        return cv
    }()
    
    private var textLabel: UILabel = {
       let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 20, weight: .semibold)
        lbl.textColor = .black
        return lbl
    }()
    
    private var index: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(containerView)
        containerView.addSubview(textLabel)
        
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        
        textLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let circularlayoutAttributes = layoutAttributes as? CircularCollectionViewLayoutAttributes else { return }
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }
    
    func set(color: UIColor, index: Int) {
        self.index = index
        containerView.backgroundColor = color
        textLabel.text = "\(index)"
    }
}
