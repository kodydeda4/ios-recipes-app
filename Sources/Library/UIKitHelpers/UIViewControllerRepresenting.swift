import Foundation
import SwiftUI

/// A view that represents a UIKit view controller.
public struct UIViewControllerRepresenting: UIViewControllerRepresentable {
  
  public var viewControllerBuilder: () -> UIViewController
  
  public init(_ viewControllerBuilder: @escaping () -> UIViewController) {
    self.viewControllerBuilder = viewControllerBuilder
  }
  
  public func makeUIViewController(context: Context) -> some UIViewController {
    viewControllerBuilder()
  }
  
  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
   // Nothing to do here
  }
}

