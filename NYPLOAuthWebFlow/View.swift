import Foundation

final class View {

  static func centerInSuperview(_ view: UIView) {
    NSLayoutConstraint(
      item: view,
      attribute: .centerX,
      relatedBy: .equal,
      toItem: view.superview,
      attribute: .centerX,
      multiplier: 1.0,
      constant: 0.0).isActive = true

    NSLayoutConstraint(
      item: view,
      attribute: .centerY,
      relatedBy: .equal,
      toItem: view.superview,
      attribute: .centerY,
      multiplier: 1.0,
      constant: 0.0).isActive = true
  }
}
