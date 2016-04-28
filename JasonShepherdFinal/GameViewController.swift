//
//  GameViewController.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/14/16.
//  Copyright (c) 2016 Salt Lake Community College. All rights reserved.
//

import UIKit
import SpriteKit

// Define a struct to hold some global variables
struct GlobalVariables {
    
    // Global variables to control menu error checking
    static var inMenu = true
    static var inGameOverMenu = false
    static var singlePlayer = false
    static var blueScore = 0
    static var redScore = 0
    static var blueHealth = 3
    static var redHealth = 3
    static var winner = 0 // 0 is tie game, 1 is blue winner, 2 is red winner
    static var difficulty = 0.30 // difficulty setting for single player AI
    
    // Boolean values to store game type for error checking
    static var optionMade = false
    static var onePlayerGame = false
    static var twoPlayerGame = false
    
    // Defines Player names
    static var playerOneName: String!
    static var playerTwoName = "AI"
    
    // Sets audio 
    static var soundOn = true

}

class GameViewController: UIViewController {

    var scene: SKScene!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Setup SKView
        let skView = self.view as! SKView
        
        // Set inMenu and set menu screen if inMenu is true
        if GlobalVariables.inMenu == true {
            scene = MenuScene(size: view!.bounds.size)
        }
        
        // Scene is GameScene if not in menu
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
            
            // Sprite Kit applies additional optimizations to improve rendering performance
            skView.ignoresSiblingOrder = true
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .ResizeFill
            scene.size  = skView.bounds.size
            skView.presentScene(scene)
        }

    }

    // Autorotate is okay in game, forced portrait view in menu
    override func shouldAutorotate() -> Bool {
        
        // Allow auto-rotate in game, not in menu
        if GlobalVariables.inMenu == true || GlobalVariables.inGameOverMenu == true {
            return false
        } else {
            return true // only return true if not in menu
        }
        
    }
    
    // Supported orientation
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    // Check for memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // Hide status bar for full screen
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
