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
  private var movingNodes = [MovingNode]()

  override func didMove(to view: SKView) {

  }

  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
  }

  func touchDown(_ touch: UITouch) {
    for m in self.nodes(at: touch.location(in: self)) {
      if m.name?.starts(with: "Object") == true && !movingNodes.contains(where: { $0.node === m }) {
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
