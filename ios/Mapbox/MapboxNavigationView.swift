//
//  NavigationView.swift
//  SafeRideTests
//
//  Created by Clement on 1/22/19.
//

import UIKit
import Foundation
import MapboxDirections
import MapboxCoreNavigation
import MapboxNavigation

extension UIView {
  var parentViewController: UIViewController? {
    var parentResponder: UIResponder? = self
    while parentResponder != nil {
      parentResponder = parentResponder!.next
      if let viewController = parentResponder as? UIViewController {
        return viewController
      }
    }
    return nil
  }
}

class MapboxNavigationView: UIView {
  
  weak var navigationViewController: NavigationViewController?
  var embedding: Bool
  var embedded: Bool
  
  @objc
  var origin: NSDictionary = [:] {
    didSet {
      setNeedsLayout()
    }
  }
  
  @objc
  var destination: NSDictionary = [:] {
    didSet {
      setNeedsLayout()
    }
  }
  
  override init(frame: CGRect) {
    self.embedded = false
    self.embedding = false
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError("nope") }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    if navigationViewController == nil && !embedding && !embedded{
      embed()
    } else {
      navigationViewController?.view.frame = bounds
    }
  }
  
  private func embed() {
    guard
      let parentVC = parentViewController,
      let originLat = origin["lat"] as? Double,
      let originLong = origin["long"] as? Double,
      let destinationLat = destination["lat"] as? Double,
      let destinationLong = destination["long"] as? Double
      else {
        return
    }
    
    embedding = true
    
    let originWayPoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: originLat, longitude: originLong), name: "Origin")
    let destinationWayPoint = Waypoint(coordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong), name: "Destination")
    let options = NavigationRouteOptions(waypoints: [originWayPoint, destinationWayPoint])
    
    Directions.shared.calculate(options) { (waypoints, routes, error) in
      guard let route = routes?.first else { return }
      let vc = NavigationViewController(for: route)
      parentVC.addChild(vc)
      self.addSubview(vc.view)
      vc.view.frame = self.bounds
      vc.didMove(toParent: parentVC)
      self.navigationViewController = vc
      self.embedded = true
      self.embedding = false
    }
  }
}
