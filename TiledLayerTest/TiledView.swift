//
//  TiledView.swift
//  TiledLayerTest
//
//  Created by Tom Lokhorst on 2016-10-05.
//  Copyright © 2016 Q42. All rights reserved.
//

import UIKit

class TiledView : UIView {
  override class var layerClass: AnyClass {
    return CATiledLayer.self
  }

  var tiledLayer: CATiledLayer {
    return self.layer as! CATiledLayer
  }

  // Force contentScaleFactor of 1, even on retina displays
  // For the CATiledLayer
  override var contentScaleFactor: CGFloat {
    didSet {
      super.contentScaleFactor = 1
    }
  }

  var tileColor = UIColor.red

  init() {
    super.init(frame: CGRect())

    tiledLayer.tileSize = CGSize(width: 256, height: 256)
    tiledLayer.levelsOfDetail = 6
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func draw(_ rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }

    tileColor.set()
    context.fill(rect)

    // Sleep to simulate "expensive" work on this render thread
    Thread.sleep(forTimeInterval: 0.1)
  }
}
