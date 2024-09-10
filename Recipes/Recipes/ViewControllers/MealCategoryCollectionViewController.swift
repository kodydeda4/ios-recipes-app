import Epoxy
import UIKit
import SwiftUI
import Combine

// @DEDA - FlowLayoutViewController for grid?

class MealCategoryCollectionViewController: CollectionViewController {
  
  init(state: State) {
    self.state = state
    super.init(layout: UICollectionViewCompositionalLayout.list)
    self.title = "Meal Categories"
    self.onAppear()
    self.setItems(items, animated: false)
  }
  
  private enum DataID: Hashable  {
    case row(ApiClient.MealCategory.ID)
  }
  
  struct State {
    var mealCategories = [ApiClient.MealCategory]()
    var cancellables = Set<AnyCancellable>()
  }
  
  private struct Environment {
    var api = ApiClient.liveValue
    var mainQueue = DispatchQueue.main
  }
  
  var state: State {
    didSet { setItems(items, animated: true) }
  }
  
  private let environment = Environment()
  
  private func onAppear() {
    self.environment.api.fetchAllMealCategories()
      .receive(on: self.environment.mainQueue)
      .sink { error in
        print(error)
      } receiveValue: { [weak self] value in
        print(value)
        self?.state.mealCategories = value
      }
      .store(in: &state.cancellables)
  }
  
  @ItemModelBuilder private var items: [ItemModeling] {
    self.state.mealCategories.map { (mealCategory: ApiClient.MealCategory) in
      CardContainer<BarStackView>.itemModel(
        dataID: DataID.row(mealCategory.id),
        content: .init(
          models: [
            TextRow.barModel(
              content: .init(title: "\(mealCategory.strCategory)"),
              style: .small
            ),
            ImageMarquee.barModel(
              content: .init(imageURL: mealCategory.strCategoryThumb),
              style: .init(height: 150, contentMode: .scaleAspectFill)
            )
          ],
          selectedBackgroundColor: .secondarySystemBackground),
        style: .init(card: .init())
      )
      .didSelect { _ in
        RootViewController.shared.navigate(mealCategory: mealCategory)
      }
    }
  }
}

// MARK: - ImageMarquee

private final class ImageMarquee: UIView, EpoxyableView {
  
  // MARK: Lifecycle
  
  init(style: Style) {
    self.style = style
    super.init(frame: .zero)
    contentMode = style.contentMode
    clipsToBounds = true
    addSubviews()
    constrainSubviews()
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Internal
  
  struct Style: Hashable {
    var height: CGFloat
    var contentMode: UIView.ContentMode
  }
  
  struct Content: Equatable {
    var imageURL: URL?
  }
  
  func setContent(_ content: Content, animated _: Bool) {
    imageView.setURL(content.imageURL)
  }
  
  // MARK: Private
  
  private let style: Style
  private let imageView = UIImageView()
  
  private func addSubviews() {
    addSubview(imageView)
  }
  
  private func constrainSubviews() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    let heightAnchor = imageView.heightAnchor.constraint(equalToConstant: style.height)
    heightAnchor.priority = .defaultHigh
    NSLayoutConstraint.activate([
      heightAnchor,
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
}

// MARK: - CardContainer

/// A container that draws a card around a content view.
final class CardContainer<ContentView: EpoxyableView>: UIView, EpoxyableView {
  
  // MARK: Lifecycle
  
  init(style: Style) {
    self.style = style.card
    if ContentView.Style.self == Never.self {
      contentView = ContentView()
    } else {
      contentView = ContentView(style: style.content)
    }
    super.init(frame: .zero)
    addSubviews()
    setUpConstraints()
    applyStyle()
  }
  
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Internal
  
  struct Style: Hashable {
    init(content: ContentView.Style, card: CardStyle) {
      self.content = content
      self.card = card
    }
    
    init(card: CardStyle) where ContentView.Style == Never {
      self.card = card
    }
    
    // swiftlint:disable implicitly_unwrapped_optional
    fileprivate var content: ContentView.Style!
    fileprivate var card: CardStyle
  }
  
  struct CardStyle: Hashable {
    var cornerRadius: CGFloat = 10
    var layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    var cardBackgroundColor = UIColor.secondarySystemBackground
    var borderColor = UIColor.tertiarySystemBackground
    var borderWidth: CGFloat = 1
    var shadowColor = UIColor.black
    var shadowOffset = CGSize(width: 0, height: 2)
    var shadowRadius: CGFloat = 4
    var shadowOpacity: Float = 0.2
  }
  
  let contentView: ContentView
  
  func setContent(_ content: ContentView.Content, animated: Bool) {
    contentView.setContent(content, animated: animated)
  }
  
  // MARK: Private
  
  private let style: CardStyle
  
  private lazy var contentContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.clipsToBounds = true
    view.layer.cornerRadius = style.cornerRadius
    view.backgroundColor = style.cardBackgroundColor
    view.layer.borderWidth = style.borderWidth
    view.layer.borderColor = style.borderColor.cgColor
    return view
  }()
  
  private lazy var shadow: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.clipsToBounds = false
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = style.cornerRadius
    view.layer.shadowColor = style.shadowColor.cgColor
    view.layer.shadowOffset = style.shadowOffset
    view.layer.shadowOpacity = style.shadowOpacity
    view.layer.shadowRadius = style.shadowRadius
    return view
  }()
  
  private func addSubviews() {
    addSubview(shadow)
    contentContainer.addSubview(contentView)
    addSubview(contentContainer)
  }
  
  private func setUpConstraints() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      shadow.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      shadow.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      shadow.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      shadow.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
      contentView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
      contentView.topAnchor.constraint(equalTo: contentContainer.topAnchor),
      contentView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor),
      contentContainer.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      contentContainer.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      contentContainer.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      contentContainer.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
    ])
  }
  
  private func applyStyle() {
    layoutMargins = style.layoutMargins
  }
  
}

// MARK: - UIEdgeInsets + Hashable

extension UIEdgeInsets: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(left)
    hasher.combine(right)
    hasher.combine(top)
    hasher.combine(bottom)
  }
}

// MARK: - CGSize + Hashable

extension CGSize: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(height)
    hasher.combine(width)
  }
}


// MARK: - Previews

struct MealCategoryListViewController_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UIKitPreview {
        MealCategoryCollectionViewController(state: .init())
      }
      .navigationTitle("Category")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}
