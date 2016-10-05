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
    drawTiles(inRect: rect)
  }

  private func drawTile(
    in context: CGContext,
    row: Int,
    col: Int,
    scale: CGFloat,
    tileRect: CGRect)
  {
    tileColor.set()
    context.fill(tileRect)

    // Sleep to simulate "expensive" work on this render thread
    Thread.sleep(forTimeInterval: 0.01)

    print("drawTile \(row),\(col) - \(tileColor)")
  }

  private func debugBorder(
    in context: CGContext,
    row: Int,
    col: Int,
    scale: CGFloat,
    tileRect: CGRect)
  {
    // Border
    UIColor.green.set()
    context.setLineWidth(6.0 / scale)
    context.stroke(tileRect)

    // Info
    let level = 1 / scale
    let attributes: [String: AnyObject] = [
      NSForegroundColorAttributeName: UIColor.white,
      NSFontAttributeName: UIFont.systemFont(ofSize: level * 25)
    ]

    NSAttributedString(string: "\(row),\(col) / \(scale)", attributes: attributes)
      .draw(in: tileRect.insetBy(dx: level * 10, dy: level * 10))
  }

  private func drawTiles(inRect rect: CGRect) {
    guard let context = UIGraphicsGetCurrentContext() else { return }


    // Note that at certain zoom levels a != -d
    // Therefor we must use both scales, otherwise we get black lines between tiles
    let scaleX = context.ctm.a
    let scaleY = -context.ctm.d

    var tileSize = tiledLayer.tileSize

    tileSize.width /= scaleX
    tileSize.height /= scaleY

    // calculate the rows and columns of tiles that intersect the rect we have been asked to draw
    let firstCol = Int(rect.minX / tileSize.width)
    let lastCol = Int(rect.maxX / tileSize.width)
    let firstRow = Int(rect.minY / tileSize.height)
    let lastRow = Int(rect.maxY / tileSize.height)

    for row in firstRow...lastRow {
      for col in firstCol...lastCol {
        var tileRect = CGRect(
          x: tileSize.width * CGFloat(col),
          y: tileSize.height * CGFloat(row),
          width: tileSize.width,
          height: tileSize.height)

        // if the tile would stick outside of our bounds, we need to truncate it so as
        // to avoid stretching out the partial tiles at the right and bottom edges
        tileRect = self.bounds.intersection(tileRect)

        drawTile(in: context, row: row, col: col, scale: scaleY, tileRect: tileRect)

        // Add border and info for debugging
        debugBorder(in: context, row: row, col: col, scale: scaleY, tileRect: tileRect)
      }
    }
  }
}
