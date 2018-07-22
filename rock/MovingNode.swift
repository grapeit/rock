//
//  MovingNode.swift
//  rock
//
//  Created by AV on 7/21/18.
//  Copyright © 2018 grapeit. All rights reserved.
//

import Foundation
import SpriteKit

class MovingNode {
  let node: SKNode
  let touch: UITouch
  let diff: CGPoint
  var time: TimeInterval
  var velocity = [CGVector]()
  static let velocitySamples = 4

  init(node: SKNode, touch: UITouch, in scene: SKNode) {
    self.node = node
    self.touch = touch
    let pos = touch.location(in: scene)
    diff = CGPoint(x: node.position.x - pos.x, y: node.position.y - pos.y)
    time = touch.timestamp
    node.physicsBody?.isDynamic = false
  }

  func update(with touch: UITouch, in scene: SKScene) {
    updateVelocity(of: touch, in: scene)
    let pos = touch.location(in: scene)
    node.position = CGPoint(x: pos.x + diff.x, y: pos.y + diff.y)
    time = touch.timestamp
  }

  func release(with touch: UITouch, in scene: SKScene) {
    updateVelocity(of: touch, in: scene)
    let pos = touch.location(in: scene)
    node.position = CGPoint(x: pos.x + diff.x, y: pos.y + diff.y)
    node.physicsBody?.isDynamic = true
    node.physicsBody?.velocity = getVelocity()
  }

  private func updateVelocity(of touch: UITouch, in scene: SKScene) {
    if touch.timestamp == time {
      return
    }
    let pos = touch.location(in: scene)
    let prevPos = touch.previousLocation(in: scene)
    let t = CGFloat(touch.timestamp - time) * 2
    let v = CGVector(dx: (pos.x - prevPos.x) / t, dy: (pos.y - prevPos.y) / t)
    velocity.append(v)
    while velocity.count > MovingNode.velocitySamples {
      velocity.remove(at: 0)
    }
  }

  private func getVelocity() -> CGVector {
    var result = CGVector()
    if velocity.isEmpty {
      return result
    }
    for v in velocity {
      result += v
    }
    result /= CGFloat(velocity.count)
    return result
  }
}
