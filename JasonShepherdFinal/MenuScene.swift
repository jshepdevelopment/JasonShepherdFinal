//
//  MenuScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/19/16.
//  Copyright © 2016 Salt Lake Community College. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        addButtons()
    }
   
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        startGame()
        
       for touch: AnyObject in touches {
            print("Touch detected!")
        }
    }
    
    private func addButtons() {
        // TODO layout buttons here
    }
    
    
    
    private func startGame() {
        let gameScene = GameScene(fileNamed: "GameScene")
        let transition = SKTransition.fadeWithDuration(0.15)
        
        gameScene!.scaleMode = .ResizeFill
        view!.presentScene(gameScene!, transition: transition)
    }
}
