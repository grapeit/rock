//
//  GameScene.swift
//  rock
//
//  Created by AV on 7/20/18.
//  Copyright © 2018 grapeit. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
  let bottomSpacing: CGFloat = 60
  var borderLeft: SKNode!
  var borderRight: SKNode!
  var borderTop: SKNode!
  var borderBottom: SKNode!
  private var boxes = [SKNode]()
  private var movingNodes = [MovingNode]()

  override func didMove(to view: SKView) {
    borderLeft = self.childNode(withName: "BorderLeft")
    borderRight = self.childNode(withName: "BorderRight")
    borderTop = self.childNode(withName: "BorderTop")
    borderBottom = self.childNode(withName: "BorderBottom")

    boxes.removeAll()
    for n in self.children {
      if n.name?.starts(with: "Box") == true {
        boxes.append(n)
      }
      n.physicsBody?.usesPreciseCollisionDetection = true
    }

    viewWillTransition(to: view.frame.size)
  }

  override func update(_ currentTime: TimeInterval) {
    for n in boxes {
      let p = n.position
      if p.x < borderLeft.frame.origin.x || p.x > borderRight.frame.origin.x || p.y > borderTop.frame.origin.y || p.y < borderBottom.frame.origin.y {
        n.position = CGPoint(x: 0, y: bottomSpacing)
        n.physicsBody?.velocity = CGVector()
        n.run(SKAction.repeat(SKAction.sequence([
          SKAction.fadeOut(withDuration: 0.1),
          SKAction.fadeIn(withDuration: 0.005)
        ]), count: 8))
        if let m = movingNodes.index(where: { $0.node === n }) {
          movingNodes[m].release()
          movingNodes.remove(at: m)
        }
      }
    }
    for m in movingNodes {
      m.reposition()
    }
  }

  func touchDown(_ touch: UITouch) {
    for m in self.nodes(at: touch.location(in: self)) {
      if m.name?.starts(with: "Box") == true && !movingNodes.contains(where: { $0.node === m }) {
        movingNodes.append(MovingNode(node: m, touch: touch, in: self))
        break
      }
    }
  }

  func touchMoved(_ touch: UITouch) {
    guard let m = movingNodes.first(where: { $0.touch === touch }) else {
      return
    }
    m.update(with: touch, in: self)
  }

  func touchUp(_ touch: UITouch) {
    guard let i = movingNodes.index(where: { $0.touch === touch }) else {
      return
    }
    movingNodes[i].release(with: touch, in: self)
    movingNodes.remove(at: i)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {
      self.touchDown(t)
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {
      self.touchMoved(t)
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {
      self.touchUp(t)
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches {
      self.touchUp(t)
    }
  }
}


protocol CanReceiveTransitionEvents {
  func viewWillTransition(to size: CGSize)
}

extension GameScene: CanReceiveTransitionEvents {
  func viewWillTransition(to size: CGSize) {
    self.size = size
    let d: TimeInterval = 1.0
    //TODO: use border node members
    if let l = self.childNode(withName: "BorderLeft") {
      l.run(SKAction.group([
        SKAction.resize(toHeight: size.height - bottomSpacing, duration: d),
        SKAction.moveTo(x: -size.width / 2 +  l.frame.size.width / 2, duration: d),
        SKAction.moveTo(y: bottomSpacing / 2, duration: d)]))
    }
    if let r = self.childNode(withName: "BorderRight") {
      r.run(SKAction.group([
        SKAction.resize(toHeight: size.height - bottomSpacing, duration: d),
        SKAction.moveTo(x: size.width / 2 - r.frame.size.width / 2, duration: d),
        SKAction.moveTo(y: bottomSpacing / 2, duration: d)]))
    }
    if let t = self.childNode(withName: "BorderTop") {
      t.run(SKAction.group([
        SKAction.resize(toWidth: size.width, duration: d),
        SKAction.moveTo(y: size.height / 2 - t.frame.size.height / 2, duration: d)]))
    }
    if let b = self.childNode(withName: "BorderBottom") {
      b.run(SKAction.group([
        SKAction.resize(toWidth: size.width, duration: d),
        SKAction.moveTo(y: -size.height / 2 - b.frame.size.height / 2 + bottomSpacing, duration: d)]))
    }
  }
}
