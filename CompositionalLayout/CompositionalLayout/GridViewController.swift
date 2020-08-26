//
//  ViewController.swift
//  CompositionalLayout
//
//  Created by Gregory Keeley on 8/24/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit

class GridViewController: UIViewController {
    enum Section {
        case main
    }
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        }
    
    private func configureCollectionView() {
        // Programattically
        // collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        // Storyboard
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .systemTeal
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let spacing: CGFloat = 5
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "labelCell", for: indexPath) as? LabelCell else {
                fatalError("could not dequeue a labelCell")
            }
            cell.textLabel.text = "\(item)"
            cell.backgroundColor = .orange
            return cell
        })
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(1...100))
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
}

