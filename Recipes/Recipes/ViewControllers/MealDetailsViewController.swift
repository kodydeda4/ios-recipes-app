import UIKit
import Epoxy
import SwiftUI

final class MealDetailsViewController: CollectionViewController {
  let mealDetails: ApiClient.MealDetails
  
  init(mealDetails: ApiClient.MealDetails) {
    self.mealDetails = mealDetails
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
      content: .init(imageURL: URL(string: "\(mealDetails.strMealThumb)")!),
      style: .init(height: 250, contentMode: .scaleAspectFill)
    )
  }
}

// MARK: - Previews

struct MealDetailsViewController_Previews: PreviewProvider {
  static var previews: some View {
    UIKitPreview {
      MealDetailsViewController(mealDetails: .previewValue)
    }
  }
}
