//
//  GameViewController.swift
//  JasonShepherdFinal
//
//  Created by Mac on 4/14/16.
//  Copyright (c) 2016 Salt Lake Community College. All rights reserved.
//

import UIKit
import SpriteKit

// Define a struct to hold some global variables
struct GlobalVariables {
    static var inMenu = true
    static var singlePlayer = true
    static var blueScore = 0
    static var redScore = 0

}

class GameViewController: UIViewController {

    var scene: SKScene!
 
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
        //if let scene = GameScene(fileNamed:"GameScene") {
        //if let scene = MenuScene(size: view!.bounds.size) {

        let skView = self.view as! SKView
  
        if GlobalVariables.inMenu == true {
            scene = MenuScene(size: view!.bounds.size)
        }
        if GlobalVariables.inMenu == false {
            scene = GameScene(fileNamed: "GameScene")
            scene.size  = skView.bounds.size
            skView.presentScene(scene)
        }
        
        // Check so scene wont be created twice.
        if skView.scene == nil {
            //scene = MenuScene(size: view!.bounds.size)
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            scene.size  = skView.bounds.size
            skView.presentScene(scene)
        }

    }

    
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
