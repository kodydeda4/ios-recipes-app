import UIKit
import Epoxy

final class ProductViewController: CollectionViewController {
  init() {
    super.init(layout: UICollectionViewCompositionalLayout.list)
    setItems(items, animated: false)
  }
  
  private enum DataID {
    enum Item {
      case headerImage, titleRow, imageRow
    }
  }
  
  @ItemModelBuilder private var items: [ItemModeling] {
    ImageMarquee.itemModel(
      dataID: DataID.Item.headerImage,
      content: .init(imageURL: URL(string: "https://picsum.photos/id/350/500/500")!),
      style: .init(height: 250, contentMode: .scaleAspectFill))
  }
}

