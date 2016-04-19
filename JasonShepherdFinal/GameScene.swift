//
//  GameScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/15/16.
//  Copyright (c) 2016 Jason Shepherd. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    // Define buttons
    var blueBtnUp: SKNode! = nil
    var blueBtnDown: SKNode! = nil
    var blueBtnLeft: SKNode! = nil
    var blueBtnRight: SKNode! = nil
    var redBtnUp: SKNode! = nil
    var redBtnDown: SKNode! = nil
    var redBtnLeft: SKNode! = nil
    var redBtnRight: SKNode! = nil
    
    // Define textures
    let btnTextureUp = SKTexture(imageNamed: "up-arrow.png")
    let btnTextureDown = SKTexture(imageNamed: "down-arrow.png")
    let btnTextureLeft = SKTexture(imageNamed: "left-arrow.png")
    let btnTextureRight = SKTexture(imageNamed: "right-arrow.png")
    
    // Array to store high scores
    var highScores = [String]()
    
    override func didMoveToView(view: SKView) {
        
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "BP"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))//(scene!.size.height - self.size.height))
        
        self.addChild(myLabel)
        
        // Setup and load all buttons
        setupButtons()
        
        // Add all buttons to scene
        self.addChild(blueBtnUp)
        self.addChild(blueBtnDown)
        self.addChild(blueBtnLeft)
        self.addChild(blueBtnRight)
        
        self.addChild(redBtnUp)
        self.addChild(redBtnDown)
        self.addChild(redBtnLeft)
        self.addChild(redBtnRight)
        
    }
    
    // Overriding touchesBegan to detect screen touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
           
            // Loop through the touches in event
            let location = touch.locationInNode(self)
            
            
            // Check if the touch locations are within button bounds
            if blueBtnUp.containsPoint(location) {
                print("blueBtnUp pressed")
            }
            if blueBtnDown.containsPoint(location) {
                print("blueBtnDown pressed")
            }
            if blueBtnLeft.containsPoint(location) {
                print("blueBtnLeft pressed")
            }
            if blueBtnRight.containsPoint(location) {
                print("blueBtnRight pressed")
            }
            if redBtnUp.containsPoint(location) {
                print("redBtnUp pressed")
            }
            if redBtnDown.containsPoint(location) {
                print("redBtnDown pressed")
            }
            if redBtnLeft.containsPoint(location) {
                print("redeBtnLeft pressed")
            }
            if redBtnRight.containsPoint(location) {
                print("redBtnRight pressed")
            }
        }
    }
   
    // Function to load all buttons
    func setupButtons() {
        
        // Assign as SKSpriteNodes and load textures
        blueBtnUp = SKSpriteNode(texture: btnTextureUp)
        blueBtnDown = SKSpriteNode(texture: btnTextureDown)
        blueBtnLeft = SKSpriteNode(texture: btnTextureLeft)
        blueBtnRight = SKSpriteNode(texture: btnTextureRight)
       
        // Assign button positions
        blueBtnUp.position = CGPoint(x: CGRectGetMidX(self.frame), y: scene!.frame.minY)
        blueBtnDown.position = CGPoint(x: CGRectGetMidX(self.frame)+50, y: scene!.frame.minY)
        blueBtnLeft.position = CGPoint(x: CGRectGetMidX(self.frame)+100, y: scene!.frame.minY)
        blueBtnRight.position = CGPoint(x: CGRectGetMidX(self.frame)+150, y: scene!.frame.minY)
        
        // Assign as SKSpriteNodes and load textures -- red buttons are inverted :)
        redBtnUp = SKSpriteNode(texture: btnTextureDown)
        redBtnDown = SKSpriteNode(texture: btnTextureUp)
        redBtnLeft = SKSpriteNode(texture: btnTextureRight)
        redBtnRight = SKSpriteNode(texture: btnTextureLeft)
        
        // Assign button positions
        redBtnUp.position = CGPoint(x: CGRectGetMidX(self.frame), y: scene!.frame.maxY)
        redBtnDown.position = CGPoint(x: CGRectGetMidX(self.frame)-50, y: scene!.frame.maxY)
        redBtnLeft.position = CGPoint(x: CGRectGetMidX(self.frame)-100, y: scene!.frame.maxY)
        redBtnRight.position = CGPoint(x: CGRectGetMidX(self.frame)-150, y: scene!.frame.maxY)
        
    }
    
    func showHighScores() {
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
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
