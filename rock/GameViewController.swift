//
//  GameViewController.swift
//  rock
//
//  Created by AV on 7/20/18.
//  Copyright © 2018 grapeit. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    if let view = self.view as! SKView? {
      if let scene = SKScene(fileNamed: "GameScene") {
        scene.scaleMode = .aspectFit
        view.presentScene(scene)
      }

      view.ignoresSiblingOrder = true
      //view.showsPhysics = true
      view.showsFPS = true
      //view.showsNodeCount = true
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }
}
