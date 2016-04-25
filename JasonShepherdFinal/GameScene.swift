//
//  GameScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/15/16.
//  Copyright (c) 2016 Jason Shepherd. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Define labels
    var blueScoreLabel = SKLabelNode()
    var redScoreLabel = SKLabelNode()
    var blueNameLabel = SKLabelNode()
    var redNameLabel = SKLabelNode()
    
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
    let bluePlayerTexture = SKTexture(imageNamed: "bluepenguin.png")
    let redPlayerTexture = SKTexture(imageNamed: "redpenguin.png")
    
    // Define other nodes
    var coin: SKNode! = nil
    var bomb: SKNode! = nil
    var fieldNode: SKFieldNode! = nil
    
    // Define other texture
    let coinTexture1 = SKTexture(imageNamed: "coin1.png")
    let coinTexture2 = SKTexture(imageNamed: "coin2.png")
    let coinTexture3 = SKTexture(imageNamed: "coin3.png")
    let coinTexture4 = SKTexture(imageNamed: "coin4.png")
    let coinTexture5 = SKTexture(imageNamed: "coin5.png")
    let coinTexture6 = SKTexture(imageNamed: "coin6.png")
    let coinTexture7 = SKTexture(imageNamed: "coin7.png")


    var bombTexture = SKTexture(imageNamed: "bomb.png")
    
    // Define particle effects    
    let rocketTrailParticle1 = SKEmitterNode(fileNamed: "RocketTrail.sks")
    let rocketTrailParticle2 = SKEmitterNode(fileNamed: "RocketTrail.sks")
    
    // Define sprite groups
    let blueCategory: UInt32 = 1
    let redCategory: UInt32 = 2
    let coinCategory: UInt32 = 3
    let bombCategory: UInt32 = 4
    let fieldNodeCategory: UInt32 = 0x1 << 5//5
    let noFieldCategory: UInt32 = 0x1 << 6//6
    
    // Vars to store red and blue score and health
    var blueScore = 0
    var redScore = 0
    var blueHealth = 3
    var redHealth = 3
    
    var stopBluePlayer = false
    var stopRedPlayer = false
    
    // Timers
    var coinTimer: NSTimer!
    var bombTimer: NSTimer!
    var stopBlueTimer: NSTimer!
    var stopRedTimer: NSTimer!
    
    // Boolean to handle game over check
    var gameOverFlag = false
    
    override func didMoveToView(view: SKView) {
        
        super.didMoveToView(view)
        
        // Prevents return to menu on orientation change
        GlobalVariables.inMenu = false
        
        // Setup physics world
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        // Setup and load players
        setupPlayers()
        
        // Add player nodes to the view
        self.addChild(bluePlayer)
        self.addChild(redPlayer)
        
        // Add some sweet particle fx to the penguins
        rocketTrailParticle1!.targetNode = self
        bluePlayer.addChild(rocketTrailParticle1!)
        rocketTrailParticle2!.targetNode = self
        redPlayer.addChild(rocketTrailParticle2!)
        
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
        
        coinTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameScene.addCoins), userInfo: nil, repeats: true)
        bombTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(GameScene.addBombs), userInfo: nil, repeats: true)
        
    }
    
    // Overriding touchesBegan to detect screen touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
           
            // Loop through the touches in event
            let location = touch.locationInNode(self)
            
            if !stopBluePlayer {
                // Check if the touch locations are within button bounds
                if blueBtnUp.containsPoint(location) {
                    bluePlayer.physicsBody!.applyImpulse(CGVectorMake(0,10))
                }
                if blueBtnDown.containsPoint(location) {
                    bluePlayer.physicsBody!.applyImpulse(CGVectorMake(0,-10))
                }
                if blueBtnLeft.containsPoint(location) {
                    bluePlayer.physicsBody!.applyImpulse(CGVectorMake(-10,0))
                }
                if blueBtnRight.containsPoint(location) {
                    bluePlayer.physicsBody!.applyImpulse(CGVectorMake(10,0))
                }
            }
            
            if !stopRedPlayer {
                if redBtnUp.containsPoint(location) {
                    redPlayer.physicsBody!.applyImpulse(CGVectorMake(0,-10))
                }
                if redBtnDown.containsPoint(location) {
                    redPlayer.physicsBody!.applyImpulse(CGVectorMake(0,10))
                }
                if redBtnLeft.containsPoint(location) {
                    redPlayer.physicsBody!.applyImpulse(CGVectorMake(10,0))
                }
                if redBtnRight.containsPoint(location) {
                    redPlayer.physicsBody!.applyImpulse(CGVectorMake(-10,0))
                }
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
        blueBtnUp.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)+100, y: scene!.view!.bounds.minY + 80)
        blueBtnDown.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)+100, y: scene!.view!.bounds.minY + 30)
        blueBtnLeft.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)+50, y: scene!.view!.bounds.minY + 30)
        blueBtnRight.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)+150, y: scene!.view!.bounds.minY + 30)
        blueBtnUp.zPosition = 10
        blueBtnDown.zPosition = 10
        blueBtnLeft.zPosition = 10
        blueBtnRight.zPosition = 10
        
        // Assign button positions
        redBtnUp.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)-100, y: scene!.view!.bounds.maxY - 80)
        redBtnDown.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)-100, y: scene!.view!.bounds.maxY - 30)
        redBtnLeft.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)-50, y: scene!.view!.bounds.maxY - 30)
        redBtnRight.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame)-150, y: scene!.view!.bounds.maxY - 30)
        redBtnUp.zPosition = 10
        redBtnDown.zPosition = 10
        redBtnLeft.zPosition = 10
        redBtnRight.zPosition = 10
        
    }
    
    // Setup player sprites
    func setupPlayers() {
        
        // Assign as SKSpriteNodes and load textures
        bluePlayer = SKSpriteNode(texture: bluePlayerTexture)
        redPlayer = SKSpriteNode(texture: redPlayerTexture)
        
        // Assign player positions
        bluePlayer.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.minY + 100)
        redPlayer.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.maxY - 100)
        
        // Assign player physics
        bluePlayer.physicsBody = SKPhysicsBody(circleOfRadius: bluePlayerTexture.size().width/2)
        bluePlayer.physicsBody!.dynamic = true
        bluePlayer.physicsBody!.allowsRotation = false
        bluePlayer.physicsBody!.affectedByGravity = false
        bluePlayer.physicsBody!.categoryBitMask = blueCategory
        bluePlayer.physicsBody!.contactTestBitMask = coinCategory | bombCategory
        bluePlayer.physicsBody!.fieldBitMask = noFieldCategory
        
        redPlayer.physicsBody = SKPhysicsBody(circleOfRadius: redPlayerTexture.size().width/2)
        redPlayer.physicsBody!.dynamic = true
        redPlayer.physicsBody!.allowsRotation = false
        redPlayer.physicsBody!.affectedByGravity = false
        redPlayer.physicsBody!.categoryBitMask = redCategory
        redPlayer.physicsBody!.contactTestBitMask = coinCategory | bombCategory
        redPlayer.physicsBody!.fieldBitMask = noFieldCategory
        
        // Add player name labels
        blueNameLabel.fontName = "Chalkduster"
        blueNameLabel.fontSize = 25
        blueNameLabel.text = GlobalVariables.playerOneName
        blueNameLabel.position = CGPointMake(scene!.view!.bounds.minX+25, scene!.view!.bounds.minY+60)
        self.addChild(blueNameLabel)
        redNameLabel.fontName = "Chalkduster"
        redNameLabel.fontSize = 25
        redNameLabel.text = GlobalVariables.playerTwoName
        redNameLabel.position = CGPointMake(scene!.view!.bounds.maxX-25, scene!.view!.bounds.maxY-60)
        redNameLabel.xScale = redNameLabel.xScale * -1
        redNameLabel.yScale = redNameLabel.yScale * -1
        self.addChild(redNameLabel)
        
        // Add player score labels
        blueScoreLabel.fontName = "Chalkduster"
        blueScoreLabel.fontSize = 25
        blueScoreLabel.text = "0"
        blueScoreLabel.position = CGPointMake(scene!.view!.bounds.minX+25, scene!.view!.bounds.minY+30)
        self.addChild(blueScoreLabel)
        redScoreLabel.fontName = "Chalkduster"
        redScoreLabel.fontSize = 25
        redScoreLabel.text = "0"
        redScoreLabel.position = CGPointMake(scene!.view!.bounds.maxX-25, scene!.view!.bounds.maxY-30)
        redScoreLabel.xScale = redScoreLabel.xScale * -1
        redScoreLabel.yScale = redScoreLabel.yScale * -1
        self.addChild(redScoreLabel)
        
    }
    
    // Update scores
    func updateScores() {
        redScoreLabel.text = String(redScore)
        blueScoreLabel.text = String(blueScore)
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
        if bluePlayer.position.x <= scene!.view!.bounds.minX {
            bluePlayer.position.x = scene!.view!.bounds.minX
            bluePlayer.physicsBody!.velocity = CGVectorMake(2,0)
        }
        if bluePlayer.position.x >= scene!.view!.bounds.maxX {
            bluePlayer.position.x = scene!.view!.bounds.maxX
            bluePlayer.physicsBody!.velocity = CGVectorMake(-2,0)
        }
        if bluePlayer.position.y <= scene!.view!.bounds.minY {
            bluePlayer.position.y = scene!.view!.bounds.minY
            bluePlayer.physicsBody!.velocity = CGVectorMake(0,2)
        }
        if bluePlayer.position.y >= scene!.view!.bounds.maxY {
            bluePlayer.position.y = scene!.view!.bounds.maxY
            bluePlayer.physicsBody!.velocity = CGVectorMake(0,-2)
        }
        if redPlayer.position.x <= scene!.view!.bounds.minX {
            redPlayer.position.x = scene!.view!.bounds.minX
            redPlayer.physicsBody!.velocity = CGVectorMake(2,0)
        }
        if redPlayer.position.x >= scene!.view!.bounds.maxX {
            redPlayer.position.x = scene!.view!.bounds.maxX
            redPlayer.physicsBody!.velocity = CGVectorMake(-2,0)
        }
        if redPlayer.position.y <= scene!.view!.bounds.minY {
            redPlayer.position.y = scene!.view!.bounds.minY
            redPlayer.physicsBody!.velocity = CGVectorMake(0,2)
        }
        if redPlayer.position.y >= scene!.view!.bounds.maxY {
            redPlayer.position.y = scene!.view!.bounds.maxY
            redPlayer.physicsBody!.velocity = CGVectorMake(0,-2)
        }
    }
    
    // Adds coins
    func addCoins() {
        
        // Make the sprite node
        coin = SKSpriteNode(texture: coinTexture1)
        
        // Set up coin animation
        let coinAnimation = SKAction.animateWithTextures([coinTexture1, coinTexture2, coinTexture3, coinTexture4, coinTexture5, coinTexture6, coinTexture7, coinTexture6, coinTexture5, coinTexture4, coinTexture3, coinTexture2, coinTexture1], timePerFrame: 0.1)
        
        // Add action to object to run indefinately
        let coinSpin = SKAction.repeatActionForever(coinAnimation)
        
        // Start the animation
        coin.runAction(coinSpin)
        
        // Set up random positions
        let x = CGFloat(arc4random() % UInt32(size.width) + UInt32(scene!.view!.bounds.maxX))
        let y = CGFloat(arc4random() % UInt32(size.height))// + scene!.view!.bounds.maxX)

        coin.position = CGPointMake(x,y)

        // Set up physics body
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coinTexture1.size().width/2)
        coin.physicsBody?.dynamic = true
        coin.physicsBody?.affectedByGravity = true
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.physicsBody?.contactTestBitMask = blueCategory | redCategory
        coin.physicsBody?.fieldBitMask = fieldNodeCategory
        coin.physicsBody?.velocity = CGVectorMake(-100,0)
        
        self.addChild(coin)

    }
    
    // Removes coins
    func removeCoins() {
         if coin.position.x < scene!.view!.bounds.minX {
            coin.removeFromParent()
        }
    }
    
    // Adds bombs
    func addBombs() {
        
        // Assign texture and position
        bomb = SKSpriteNode(texture: bombTexture)
        let x = CGFloat(arc4random() % UInt32(size.width) + UInt32(scene!.view!.bounds.maxX))
        let y = CGFloat(arc4random() % UInt32(size.height))// + scene!.view!.bounds.maxX)
        bomb.position = CGPointMake(x,y)
        
        // Assign physics body attributes
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        bomb.physicsBody?.dynamic = true
        bomb.physicsBody?.affectedByGravity = false
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = blueCategory | redCategory
        bomb.physicsBody?.velocity = CGVectorMake(-100,0)
        
        self.addChild(bomb)
        
    }
    
    // Removes bombs
    func removeBombs() {
        if bomb.position.x < scene!.view!.bounds.minX {
            bomb.removeFromParent()
        }
    }
    
    // Add candy powerup
    func addCandy() {
        

    }
    
    // Function to add a magnetic force for some time
    func addForce(x:CGFloat, y:CGFloat) {
        
        // Sets up field force as radial gravity
        fieldNode = SKFieldNode.radialGravityField()
        fieldNode.enabled = true
        fieldNode.position = CGPoint(x: x, y: y)
        fieldNode.strength = 0.01 // increase for more power
        //fieldNode.falloff = 1000.0
        fieldNode.categoryBitMask = fieldNodeCategory
        
        self.addChild(fieldNode)
    }
    
    // Handles collisions
    func didBeginContact(contact: SKPhysicsContact) {
        
        // Assigns contact.nodes to bodies and makes handling different collisions better
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Check for contact between players and coins
        if firstBody.categoryBitMask==blueCategory && secondBody.categoryBitMask==coinCategory {
            //print("blueCategory and coinCategory contact")
            blueScore+=1
            //print("bluePlayerScore is \(blueScore)")
            secondBody.node!.removeFromParent()
            
        }
        if firstBody.categoryBitMask==redCategory && secondBody.categoryBitMask==coinCategory {
            //print("redCategory and coinCategory contact")
            redScore+=1
            //print("redPlayerScore is\(redScore)")
            secondBody.node!.removeFromParent()
        }
        
        // Check for contact between players and bombs
        if firstBody.categoryBitMask==blueCategory && secondBody.categoryBitMask==bombCategory {
            //print("blueCategory and bombCategory contact")
            blueHealth-=1
            //print("blue health is \(blueHealth)")
            stopBluePlayerTimer() // = true
            secondBody.node!.removeFromParent()
            
        }
        if firstBody.categoryBitMask==redCategory && secondBody.categoryBitMask==bombCategory {
            //print("redCategory and bombCategory contact")
            redHealth-=1
            //print("red health is \(redHealth)")
            stopRedPlayerTimer() // = true
            secondBody.node!.removeFromParent()
        }
        
    }
    
    // Setup timer to stop blue player movement
    func stopBluePlayerTimer() {
        stopBluePlayer = true
        stopBlueTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(GameScene.startBluePlayer), userInfo: nil, repeats: false)
    }
    
    // Function is called after 3 seconds to allow movement
    func startBluePlayer() {
        stopBluePlayer = false
    }
    
    // Setup timer to stop red player movement
    func stopRedPlayerTimer() {
        stopRedPlayer = true
        stopRedTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(GameScene.startRedPlayer), userInfo: nil, repeats: false)
    }
    
    // Function is called after 3 seconds to allow movement
    func startRedPlayer() {
        stopRedPlayer = false
    }
    
    // Start game over
    func gameOver() {
        
        // Invalidate timers
        coinTimer.invalidate()
        bombTimer.invalidate()
        
        // Send scores to game over screen
        GlobalVariables.blueScore = blueScore
        GlobalVariables.redScore = redScore
        
        // Transisition into game over scene
        let gameOverScene = GameOverScene(size: view!.bounds.size)
        let transition = SKTransition.fadeWithDuration(0.15)
        
        gameOverScene.scaleMode = .ResizeFill
        view!.presentScene(gameOverScene, transition: transition)
    }
    
    // Function is called before each frame is rendered
    override func update(currentTime: CFTimeInterval) {
       
        // For debugging
        addForce(redPlayer.position.x, y: redPlayer.position.y)
        
        //print("force x/y \(fieldNode.position.x) \(fieldNode.position.y)")
        
        // Check for game over if conditions met
        if blueHealth <= 0 || redHealth <= 0 {
            
            // Check for winner according to health
            if blueHealth > redHealth {
                GlobalVariables.winner = 1 // blue winner
            }
            if redHealth > blueHealth {
                GlobalVariables.winner = 2 // red winner
            }
            if blueHealth == redHealth {
                GlobalVariables.winner = 0 // tie game
            }
            
            gameOverFlag = true
        }

        // Launch game over
        if gameOverFlag == true {
            gameOver()
        }
        
        // Update as long as game is not over
        if gameOverFlag == false {
            // Check for boundary collisions
            updateBounds()
            
            // Update score labels
            updateScores()
            
            // Update AI if it is a single player game
            if GlobalVariables.singlePlayer != false {
                updateAI()
            }
            
            // Remove coins and bombs from screen if needed
            if coin != nil {
                removeCoins()
            }
            if bomb != nil {
                removeBombs()
            }
        }
    }
}
