//
//  GameScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/15/16.
//  Copyright (c) 2016 Jason Shepherd. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var highScores = [String]()
    
    override func didMoveToView(view: SKView) {
        
        // Sync high scores with permanent storage
        if NSUserDefaults.standardUserDefaults().objectForKey("highScores") != nil {
            highScores = NSUserDefaults.standardUserDefaults().objectForKey("highScores") as! [String]
        }
        
        
        highScores.append("Score 1")
        highScores.append("Score 2")
        highScores.append("Score 3")

        var scoreLabel = [SKLabelNode(fontNamed:"Chalkduster")]
        
        // Loop through high scores and display
        for var i = 0; i < highScores.count; i++ {
            scoreLabel.append(SKLabelNode(fontNamed:"ChalkDuster"))
            
            scoreLabel[i].text = highScores[i]
            scoreLabel[i].fontSize = 35
            scoreLabel[i].position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame ) + CGFloat(Double(i*35)))
            self.addChild(scoreLabel[i])
        }
        
        
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y: (scene!.size.height - self.size.height))
        
        self.addChild(myLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
