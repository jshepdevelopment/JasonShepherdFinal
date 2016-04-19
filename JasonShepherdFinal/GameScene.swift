//
//  GameScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/15/16.
//  Copyright (c) 2016 Jason Shepherd. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Define button nodes
    var blueBtnUp: SKNode! = nil
    var blueBtnDown: SKNode! = nil
    var blueBtnLeft: SKNode! = nil
    var blueBtnRight: SKNode! = nil
    var redBtnUp: SKNode! = nil
    var redBtnDown: SKNode! = nil
    var redBtnLeft: SKNode! = nil
    var redBtnRight: SKNode! = nil
    
    // Define button textures
    let btnTextureUp = SKTexture(imageNamed: "up-arrow.png")
    let btnTextureDown = SKTexture(imageNamed: "down-arrow.png")
    let btnTextureLeft = SKTexture(imageNamed: "left-arrow.png")
    let btnTextureRight = SKTexture(imageNamed: "right-arrow.png")
    
    // Define player nodes
    var bluePlayer: SKNode! = nil
    var redPlayer: SKNode! = nil
    
    // Define player textures
    let bluePlayerTexture = SKTexture(imageNamed: "blueoval.png")
    let redPlayerTexture = SKTexture(imageNamed: "redoval.png")
    
    // Boolean value for single player game
    let singlePlayer = false
    
    // Array to store high scores
    var highScores = [String]()
    
    
    override func didMoveToView(view: SKView) {
        
        // Setup physics world
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        
        // Setup and load players
        setupPlayers()
        
        // Add player nodes to the view
        self.addChild(bluePlayer)
        self.addChild(redPlayer)
        
        // Setup and load all buttons
        setupButtons()
        
        // Add button nodes to the view
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
                bluePlayer.physicsBody!.applyImpulse(CGVectorMake(0,10))
            }
            if blueBtnDown.containsPoint(location) {
                print("blueBtnDown pressed")
                bluePlayer.physicsBody!.applyImpulse(CGVectorMake(0,-10))
            }
            if blueBtnLeft.containsPoint(location) {
                print("blueBtnLeft pressed")
                bluePlayer.physicsBody!.applyImpulse(CGVectorMake(-10,0))
            }
            if blueBtnRight.containsPoint(location) {
                print("blueBtnRight pressed")
                bluePlayer.physicsBody!.applyImpulse(CGVectorMake(10,0))

            }
            if redBtnUp.containsPoint(location) {
                print("redBtnUp pressed")
                redPlayer.physicsBody!.applyImpulse(CGVectorMake(0,-10))

            }
            if redBtnDown.containsPoint(location) {
                print("redBtnDown pressed")
                redPlayer.physicsBody!.applyImpulse(CGVectorMake(0,10))
                
            }
            if redBtnLeft.containsPoint(location) {
                print("redBtnLeft pressed")
                redPlayer.physicsBody!.applyImpulse(CGVectorMake(10,0))

                
            }
            if redBtnRight.containsPoint(location) {
                print("redBtnRight pressed")
                redPlayer.physicsBody!.applyImpulse(CGVectorMake(-10,0))

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
        // Assign as SKSpriteNodes and load textures -- red buttons are inverted :)
        redBtnUp = SKSpriteNode(texture: btnTextureDown)
        redBtnDown = SKSpriteNode(texture: btnTextureUp)
        redBtnLeft = SKSpriteNode(texture: btnTextureRight)
        redBtnRight = SKSpriteNode(texture: btnTextureLeft)
       
        // Assign button positions
        blueBtnUp.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.minY + 50)
        blueBtnDown.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)+50, y: scene!.view!.bounds.minY + 50)
        blueBtnLeft.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)+100, y: scene!.view!.bounds.minY + 50)
        blueBtnRight.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)+150, y: scene!.view!.bounds.minY + 50)
        
        // Assign button positions
        redBtnUp.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.maxY - 50)
        redBtnDown.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)-50, y: scene!.view!.bounds.maxY - 50)
        redBtnLeft.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)-100, y: scene!.view!.bounds.maxY - 50)
        redBtnRight.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)-150, y: scene!.view!.bounds.maxY - 50)
        
    }
    
    func setupPlayers() {
        
        // Assign as SKSpriteNodes and load textures
        bluePlayer = SKSpriteNode(texture: bluePlayerTexture)
        redPlayer = SKSpriteNode(texture: redPlayerTexture)
        
        // Assign player positions
        bluePlayer.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.minY + 100)
        redPlayer.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.maxY - 100)
        
        // Assign player physics
        bluePlayer.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        bluePlayer.physicsBody!.dynamic = true
        bluePlayer.physicsBody!.allowsRotation = false
        bluePlayer.physicsBody!.affectedByGravity = false
        
        redPlayer.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        redPlayer.physicsBody!.dynamic = true
        redPlayer.physicsBody!.allowsRotation = false
        redPlayer.physicsBody!.affectedByGravity = false
        
        
    }
    
    // Function to implement some simple AI
    func updateAI() {
        
        // Assign AI difficulty
        let difficulty:CGFloat = 0.05

        // Update red position based on blue position and difficulty level
        if bluePlayer.position.x > redPlayer.position.x {
            redPlayer.physicsBody!.applyImpulse(CGVectorMake(difficulty,0))
        }
        if bluePlayer.position.x < redPlayer.position.x {
            redPlayer.physicsBody!.applyImpulse(CGVectorMake(-difficulty,0))
        }
        if bluePlayer.position.y > redPlayer.position.y {
            redPlayer.physicsBody!.applyImpulse(CGVectorMake(0,difficulty))
        }
        if bluePlayer.position.y < redPlayer.position.y {
            redPlayer.physicsBody!.applyImpulse(CGVectorMake(0,-difficulty))
        }
    }

    // Function to keep players within screen
    func updateBounds() {
        
        // Comparing position to view bounds and assigning accordingly
        // Set velocity to nothing, to allow quick recovery
        if bluePlayer.position.x < scene!.view!.bounds.minX {
            bluePlayer.position.x = scene!.view!.bounds.minX
            bluePlayer.physicsBody!.velocity = CGVectorMake(0,0)
        }
        if bluePlayer.position.x > scene!.view!.bounds.maxX {
            bluePlayer.position.x = scene!.view!.bounds.maxX
            bluePlayer.physicsBody!.velocity = CGVectorMake(0,0)
        }
        if bluePlayer.position.y < scene!.view!.bounds.minY {
            bluePlayer.position.y = scene!.view!.bounds.minY
            bluePlayer.physicsBody!.velocity = CGVectorMake(0,0)
        }
        if bluePlayer.position.y > scene!.view!.bounds.maxY {
            bluePlayer.position.y = scene!.view!.bounds.maxY
            bluePlayer.physicsBody!.velocity = CGVectorMake(0,0)
        }
        if redPlayer.position.x < scene!.view!.bounds.minX {
            redPlayer.position.x = scene!.view!.bounds.minX
            redPlayer.physicsBody!.velocity = CGVectorMake(0,0)
        }
        if redPlayer.position.x > scene!.view!.bounds.maxX {
            redPlayer.position.x = scene!.view!.bounds.maxX
            redPlayer.physicsBody!.velocity = CGVectorMake(0,0)
        }
        if redPlayer.position.y < scene!.view!.bounds.minY {
            redPlayer.position.y = scene!.view!.bounds.minY
            redPlayer.physicsBody!.velocity = CGVectorMake(0,0)
        }
        if redPlayer.position.y > scene!.view!.bounds.maxY {
            redPlayer.position.y = scene!.view!.bounds.maxY
            redPlayer.physicsBody!.velocity = CGVectorMake(0,0)
        }
    }
    
    // Function to show high scores
    func showHighScores() {
        
        // Sync high scores with permanent storage
        if NSUserDefaults.standardUserDefaults().objectForKey("highScores") != nil {
            highScores = NSUserDefaults.standardUserDefaults().objectForKey("highScores") as! [String]
        }
        
        // Testing append high score values
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
    
    // Function is called before each frame is rendered
    override func update(currentTime: CFTimeInterval) {
       
        // Check for boundary collisions
        updateBounds()
        
        // Update AI if it is a single player game
        if singlePlayer {
            updateAI()
        }

    }
}
