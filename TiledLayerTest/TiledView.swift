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

    let info = DebugInfo(context: context, rect: rect, tileSize: tiledLayer.tileSize)
    print("BEGIN drawTile \(info.row),\(info.col) - \(tileColor)")

    tileColor.set()
    context.fill(rect)
    drawDebugString(context: context, rect: rect, info: info)

    // Sleep to simulate "expensive" work on this render thread
    Thread.sleep(forTimeInterval: 0.1)

    print("END   drawTile \(info.row),\(info.col) - \(tileColor)")
  }


  private func drawDebugString(context: CGContext, rect: CGRect, info: DebugInfo) {
    let level = 1 / info.scale
    let attributes: [String: AnyObject] = [
      NSForegroundColorAttributeName: UIColor.white,
      NSFontAttributeName: UIFont.systemFont(ofSize: level * 25)
    ]

    NSAttributedString(string: "\(info.row),\(info.col) / \(info.scale)", attributes: attributes)
      .draw(in: rect.insetBy(dx: level * 10, dy: level * 10))
  }
}

private struct DebugInfo {
  let col: Int
  let row: Int
  let scale: CGFloat

  init(context: CGContext, rect: CGRect, tileSize: CGSize) {
    let scaleX = context.ctm.a
    let scaleY = -context.ctm.d

    let width = tileSize.width / scaleX
    let height = tileSize.height / scaleY

    col = Int(rect.minX / width)
    row = Int(rect.minY / height)
    scale = scaleX
  }
}
