//
//  DownloadCell.swift
//  CircularCollection
//
//  Created by Anuar Orazbekov on 30.04.2024.
//

import UIKit

class DownloadCell: UICollectionViewCell {
    
    private let label: UILabel = {
       let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 20, weight: .semibold)
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 30
        contentView.layer.cornerCurve = .continuous
    }
    
    func set(color: UIColor, index: Int)  {
        contentView.backgroundColor = color
        label.text = "\(index)"
    }
}

