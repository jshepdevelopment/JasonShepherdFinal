//
//  GameOverScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/20/16.
//  Copyright © 2016 Salt Lake Community College. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    // Store high scores as array of strings
    var highScores = [String]()
    
    override func didMoveToView(view: SKView) {
        //addButtons()
        showHighScores()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        startMenu()
        
        for _: AnyObject in touches {
            print("Game Over Scene Touch detected!")
            //NSUserDefaults.standardUserDefaults().setBool(false, forKey:"SINGLEPLAYER")
        }
    }
    
    private func addButtons() {
        // TODO layout buttons here
    }
    
    // Scene to launch the menu
    private func startMenu() {
        let menuScene = MenuScene(size: view!.bounds.size)
        let transition = SKTransition.fadeWithDuration(0.15)
        
        menuScene.scaleMode = .ResizeFill
        view!.presentScene(menuScene, transition: transition)
    }
    
    // Function to show high scores
    func showHighScores() {
        
        // Sync high scores with permanent storage
        if NSUserDefaults.standardUserDefaults().objectForKey("HIGHSCORES") != nil {
            highScores = NSUserDefaults.standardUserDefaults().objectForKey("HIGHSCORES") as! [String]
        }
        
        // Testing append high score values
        highScores.append("Score 1")
        highScores.append("Score 2")
        highScores.append("Score 3")
        
        var scoreLabel = [SKLabelNode(fontNamed:"Chalkduster")]
        
        // Loop through high scores and display
        for i in 0 ..< highScores.count {
            scoreLabel.append(SKLabelNode(fontNamed:"ChalkDuster"))
            
            scoreLabel[i].text = highScores[i]
            scoreLabel[i].fontSize = 35
            scoreLabel[i].position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame ) + CGFloat(Double(i*35)))
            self.addChild(scoreLabel[i])
        }
    }
}
