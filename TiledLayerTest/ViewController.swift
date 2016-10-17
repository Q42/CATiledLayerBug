//
//  ViewController.swift
//  TiledLayerTest
//
//  Created by Tom Lokhorst on 2016-10-05.
//  Copyright © 2016 Q42. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

  var index = 0

  private let scrollView = UIScrollView()
  private let tiledView = TiledView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(scrollView)

    // Positioning
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

    tiledView.frame = CGRect(x: 0, y: 0, width: 10000, height: 10000)
    scrollView.addSubview(tiledView)

    // Setup
    scrollView.delegate = self
    scrollView.backgroundColor = .white
    scrollView.contentSize = CGSize(width: 10000, height: 10000)
    scrollView.minimumZoomScale = 0.05
    scrollView.maximumZoomScale = 1.0
    scrollView.zoomScale = 0.1 // 0.05

    // Start rendering
    update()
  }

  func update() {

//    let interval = DispatchTimeInterval.milliseconds(0) // Red tiles not even started before gray tiles
//    let interval = DispatchTimeInterval.milliseconds(5000) // Red tiles all completed before gray tiles
    let interval = DispatchTimeInterval.milliseconds(800) // Two red tiles remain


    DispatchQueue.main.asyncAfter(deadline: .now() + interval) {

      print("BEFORE setNeedsDisplay")

      // Change the updateID to reflect a new "data source" (tileColor in this case)
      self.tiledView.updateID = NSUUID()

      self.tiledView.tileColor = .lightGray
      self.tiledView.setNeedsDisplay()

      print("AFTER  setNeedsDisplay")
    }
  }

  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return tiledView
  }
}
