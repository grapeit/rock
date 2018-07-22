//
//  Utils.swift
//  rock
//
//  Created by AV on 7/21/18.
//  Copyright © 2018 grapeit. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGVector {
  static func +=(l: inout CGVector, r: CGVector) {
    l.dx += r.dx
    l.dy += r.dy
  }

  static func /=(l: inout CGVector, r: CGFloat) {
    l.dx /= r
    l.dy /= r
  }
}
