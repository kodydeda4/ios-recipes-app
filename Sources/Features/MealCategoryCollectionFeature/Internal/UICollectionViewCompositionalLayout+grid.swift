import UIKit

extension UICollectionViewCompositionalLayout {
  static func grid(columns: Int = 2) -> UICollectionViewCompositionalLayout {
    UICollectionViewCompositionalLayout { _, _ in
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      
      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
      
      let section = NSCollectionLayoutSection(group: group)
      section.interGroupSpacing = 10
      section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
      
      return section
    }
  }
}
