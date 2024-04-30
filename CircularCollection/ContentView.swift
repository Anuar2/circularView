//
//  ContentView.swift
//  CircularCollection
//
//  Created by Anuar Orazbekov on 30.04.2024.
//

import UIKit

final class ContentView: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let col = UICollectionView(frame: .zero, collectionViewLayout: layout)
        col.translatesAutoresizingMaskIntoConstraints = false
        col.register(DownloadCell.self, forCellWithReuseIdentifier: "cell")
        col.translatesAutoresizingMaskIntoConstraints = false
        col.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        col.showsHorizontalScrollIndicator = false
        //col.isPagingEnabled = true
        col.isScrollEnabled = false
        return col
    }()
    
    private var colors: [UIColor] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DownloadCell else { return UICollectionViewCell() }
        let color = colors[indexPath.item]
        cell.set(color: color, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.bounds.width - 40, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func set(colors: [UIColor]) {
        self.colors = colors
        collectionView.reloadData()
    }
    
    func set(index: IndexPath, animated: Bool) {
        collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: animated)
    }
}
