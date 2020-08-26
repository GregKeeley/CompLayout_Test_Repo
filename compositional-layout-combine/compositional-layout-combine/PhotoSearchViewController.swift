//
//  ViewController.swift
//  compositional-layout-combine
//
//  Created by Gregory Keeley on 8/25/20.
//  Copyright © 2020 Gregory Keeley. All rights reserved.
//

import UIKit
import Combine // asynchronous programming framework introduced in iOS 13
import Kingfisher

class PhotoSearchViewController: UIViewController {
    enum SectionKind: Int, CaseIterable {
        case main
        
    }
    private var collectionView: UICollectionView!
    typealias DataSource = UICollectionViewDiffableDataSource<SectionKind, Photo>
    private var searchController: UISearchController!
    @Published private var searchText = ""
    private var subscriptions: Set<AnyCancellable> = []
    private var dataSource: DataSource!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Photo Search"
        view.backgroundColor = .systemTeal
        configureCollectionView()
        configureDataSource()
        configureSearchController()
        $searchText
            .debounce(for: .seconds(1.0), scheduler: RunLoop.main )
        .removeDuplicates()
            .sink { [weak self] (text) in
                self?.searchPhotos(for: text)
                print(text)
        }
        .store(in: &subscriptions)
    }
    private func updateSnapshot(with photos: [Photo]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(photos)
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    private func searchPhotos(for query: String) {
        APIClient().searchPhotos(for: query)
            .sink(receiveCompletion: { (completion) in
                print(completion)
            }) { (photos) in
                dump(photos)
        }
    .store(in: &subscriptions)
    }
    private func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.obscuresBackgroundDuringPresentation = true
    }
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
    }
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let itemSpacing: CGFloat = 5
            item.contentInsets = NSDirectionalEdgeInsets(top: itemSpacing, leading: itemSpacing, bottom: itemSpacing, trailing: itemSpacing)
            let innerGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.50), heightDimension: .fractionalHeight(1.0))
            let leadingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 2)
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: innerGroupSize, subitem: item, count: 3)
            let nestedGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(1000))
            let nestedGroup = NSCollectionLayoutGroup.horizontal(layoutSize: nestedGroupSize, subitems: [leadingGroup, trailingGroup])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section
        
        // item
        
        // group
        
        // section
        }
        // layout
        return layout
    }
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, photo) -> UICollectionViewCell? in
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as? ImageCell else {
            fatalError("could not dequeue an ImageCell")
          }
          cell.imageView.kf.indicatorType = .activity
          cell.imageView.kf.setImage(with: URL(string: photo.webformatURL))
          cell.imageView.contentMode = .scaleAspectFill
          return cell
        })
        // setup initial snapshot
        var snapshot = dataSource.snapshot() // current snapshot
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
extension PhotoSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
            !text.isEmpty else {
                return
        }
        searchText = text
    }
}
