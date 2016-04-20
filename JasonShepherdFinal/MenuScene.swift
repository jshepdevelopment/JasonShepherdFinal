//
//  MenuScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/19/16.
//  Copyright © 2016 Salt Lake Community College. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {

    var singleLabel: SKLabelNode!
    var multiLabel: SKLabelNode!
    
    // Load menu view
    override func didMoveToView(view: SKView) {
        let mainLabel = SKLabelNode(fontNamed:"Chalkduster")
        mainLabel.text = "Battle Penguins"
        mainLabel.fontSize = 35
        mainLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame ) + 85)
        self.addChild(mainLabel)
        
        addButtons()
        
    }
   
    // Check for menu touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if singleLabel.containsPoint(location) {
                GlobalVariables.singlePlayer = true
                print("One player game")
                startGame()
            }
            if multiLabel.containsPoint(location) {
                GlobalVariables.singlePlayer = false
                print("Two player game")
                startGame()
            }
            
            //NSUserDefaults.standardUserDefaults().setBool(false, forKey:"SINGLEPLAYER")

        }
    }
    
    // Add buttons to menu
    private func addButtons() {
        
        singleLabel = SKLabelNode(fontNamed:"Chalkduster")
        singleLabel.text = "One Player"
        singleLabel.fontSize = 35
        singleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame ))
        self.addChild(singleLabel)
        
        multiLabel = SKLabelNode(fontNamed:"Chalkduster")
        multiLabel.text = "Two Players"
        multiLabel.fontSize = 35
        multiLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 50)
        self.addChild(multiLabel)
    
    }
    
    private func startGame() {
        let gameScene = GameScene(fileNamed: "GameScene")
        let transition = SKTransition.fadeWithDuration(0.15)
        
        gameScene!.scaleMode = .ResizeFill
        view!.presentScene(gameScene!, transition: transition)
    }
}
