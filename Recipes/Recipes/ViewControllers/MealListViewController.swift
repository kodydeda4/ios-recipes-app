import Epoxy
import UIKit
import SwiftUI
import Combine

class MealListViewController: CollectionViewController {
  
  // MARK: Lifecycle
  
  init(
    didSelectMealID: @escaping (ApiClient.Meal.ID) -> Void = { _ in }
  ) {
    self.didSelectMealID = didSelectMealID
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.title = "Recipes"
    self.onAppear()
    setItems(items, animated: false)
  }
  
  var didSelectMealID: (ApiClient.Meal.ID) -> Void
  
  // MARK: Private
  
  private enum DataID: Hashable  {
    case row(ApiClient.Meal.ID)
  }
  
  private struct State {
    let mealCategory = ApiClient.MealCategory.dessert
    var meals = [ApiClient.Meal]()
    var cancellables = Set<AnyCancellable>()
  }
  
  private struct Environment {
    var api = ApiClient.liveValue
    var mainQueue = DispatchQueue.main
  }
  
  private var state = State() {
    didSet { setItems(items, animated: true) }
  }
  
  private let environment = Environment()
  
  private func onAppear() {
    self.environment.api.fetchAllMeals(self.state.mealCategory)
      .receive(on: self.environment.mainQueue)
      .sink { error in
        print(error)
      } receiveValue: { [weak self] value in
        print(value)
        self?.state.meals = value
      }
      .store(in: &state.cancellables)
  }
  
  @ItemModelBuilder private var items: [ItemModeling] {
    self.state.meals.map { meal in
      TextRow.itemModel(
        dataID: DataID.row(meal.id),
        content: .init(title: "\(meal.strMeal)")
      )
      .didSelect { [weak self] _ in
        self?.didSelectMealID(meal.id)
      }
    }
  }
}

// MARK: - TextRow

private final class TextRow: UIView, EpoxyableView {
  
  // MARK: Lifecycle
  
  init() {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    layoutMargins = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
    group.install(in: self)
    group.constrainToMarginsWithHighPriorityBottom()
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Internal
  
  struct Content: Equatable {
    let title: String
  }
  
  func setContent(_ content: Content, animated _: Bool) {
    let titleStyle: UIFont.TextStyle
    titleStyle = .body
    
    group.setItems {
      Label.groupItem(
        dataID: DataID.title,
        content: content.title,
        style: .style(with: titleStyle)
      )
      .adjustsFontForContentSizeCategory(true)
      .textColor(UIColor.label)
    }
  }
  
  // MARK: Private
  
  private enum DataID {
    case title
  }
  
  private let group = VGroup(spacing: 8)
}

// MARK: SelectableView

extension TextRow: SelectableView {
  func didSelect() {
    // Handle this row being selected, e.g. to trigger haptics:
    UISelectionFeedbackGenerator().selectionChanged()
  }
}

// MARK: HighlightableView

extension TextRow: HighlightableView {
  func didHighlight(_ isHighlighted: Bool) {
    UIView.animate(withDuration: 0.15, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction]) {
      self.transform = isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
    }
  }
}

// MARK: DisplayRespondingView

extension TextRow: DisplayRespondingView {
  func didDisplay(_: Bool) {
    // Handle this row being displayed.
  }
}

// MARK: - Previews

struct MealListViewController_Previews: PreviewProvider {
  static var previews: some View {
    UIKitPreview {
      MealListViewController()
    }
  }
}
