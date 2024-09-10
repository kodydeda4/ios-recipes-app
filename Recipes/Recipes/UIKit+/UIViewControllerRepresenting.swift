import Foundation
import SwiftUI

struct UIViewControllerRepresenting: UIViewControllerRepresentable {
  
  var viewControllerBuilder: () -> UIViewController
  
  init(_ viewControllerBuilder: @escaping () -> UIViewController) {
    self.viewControllerBuilder = viewControllerBuilder
  }
  
  func makeUIViewController(context: Context) -> some UIViewController {
    viewControllerBuilder()
  }
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
   // Nothing to do here
  }
}

