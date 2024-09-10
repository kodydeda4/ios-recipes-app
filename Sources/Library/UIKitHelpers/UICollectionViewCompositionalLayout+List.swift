import Foundation
import UIKit

// MARK: - UICollectionViewCompositionalLayout

public extension UICollectionViewCompositionalLayout {
  static var list: UICollectionViewCompositionalLayout {
    if #available(iOS 14, *) {
      return UICollectionViewCompositionalLayout { _, layoutEnvironment in
        .list(layoutEnvironment: layoutEnvironment)
      }
    }
    return listNoDividers
  }
  
  static var listNoDividers: UICollectionViewCompositionalLayout {
    UICollectionViewCompositionalLayout { _, _ in
      let item = NSCollectionLayoutItem(
        layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
      )
      
      let group = NSCollectionLayoutGroup.vertical(
        layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50)),
        subitems: [item]
      )
      
      return NSCollectionLayoutSection(group: group)
    }
  }
}

// MARK: - NSCollectionLayoutSection

extension NSCollectionLayoutSection {
  static func list(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
    if #available(iOS 14, *) {
      return .list(using: .init(appearance: .plain), layoutEnvironment: layoutEnvironment)
    }
    
    let item = NSCollectionLayoutItem(
      layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
    )
    
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50)),
      subitems: [item]
    )
    
    return NSCollectionLayoutSection(group: group)
  }
}
