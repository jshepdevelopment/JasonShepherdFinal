//
//  GameScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/15/16.
//  Copyright (c) 2016 Jason Shepherd. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Define labels
    var blueScoreLabel = SKLabelNode()
    var redScoreLabel = SKLabelNode()
    var blueNameLabel = SKLabelNode()
    var redNameLabel = SKLabelNode()
    
    var gameOverLabel = SKLabelNode()
    
    // Define button nodes
    var blueBtnUp: SKSpriteNode! = nil //SKNode! = nil
    var blueBtnDown: SKSpriteNode! = nil //SKNode! = nil
    var blueBtnLeft: SKSpriteNode! = nil //SKNode! = nil
    var blueBtnRight: SKSpriteNode! = nil // SKNode! = nil
    var redBtnUp: SKSpriteNode! = nil //SKNode! = nil
    var redBtnDown: SKSpriteNode! = nil //SKNode! = nil
    var redBtnLeft: SKSpriteNode! = nil //SKNode! = nil
    var redBtnRight: SKSpriteNode! = nil //SKNode! = nil
    
    // Define button textures
    let btnTextureUp = SKTexture(imageNamed: "up-arrow.png")
    let btnTextureDown = SKTexture(imageNamed: "down-arrow.png")
    let btnTextureLeft = SKTexture(imageNamed: "left-arrow.png")
    let btnTextureRight = SKTexture(imageNamed: "right-arrow.png")
    
    let btnTextureUpOn = SKTexture(imageNamed: "up-arrow-on.png")
    let btnTextureDownOn = SKTexture(imageNamed: "down-arrow-on.png")
    let btnTextureLeftOn = SKTexture(imageNamed: "left-arrow-on.png")
    let btnTextureRightOn = SKTexture(imageNamed: "right-arrow-on.png")
    
    // Define a coin icon node
    let blueCoinIcon = SKSpriteNode(texture: SKTexture(imageNamed: "coin1.png")) //SKNode! = nil
    let redCoinIcon = SKSpriteNode(texture: SKTexture(imageNamed: "coin1.png")) //SKNode! = nil
    
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
    let candyTexture = SKTexture(imageNamed: "candy.png")
    var bombTexture = SKTexture(imageNamed: "bomb.png")
    let bg1Texture = SKTexture(imageNamed: "background1.png")
    let bg2Texture = SKTexture(imageNamed: "background2.png")
    
    // Define particle effects    
    let rocketTrailParticle1 = SKEmitterNode(fileNamed: "RocketTrail.sks")
    let rocketTrailParticle2 = SKEmitterNode(fileNamed: "RocketTrail.sks")
    let bombHitParticle = SKEmitterNode(fileNamed: "bombHit.sks")
    let coinHitParticle = SKEmitterNode(fileNamed: "CollectCoin.sks")
    
    // Define sprite groups
    let blueCategory: UInt32 = 1
    let redCategory: UInt32 = 2
    let coinCategory: UInt32 = 3
    let bombCategory: UInt32 = 4
    let fieldNodeCategory: UInt32 = 0x1 << 5//5
    let noFieldCategory: UInt32 = 0x1 << 6//6
    
    // Variables for sound and music
    var coinCollectSound: NSURL!
    var bombHitSound: NSURL!
    var gameOverSound: NSURL!
    var gameBeginSound: NSURL!
    var music: NSURL!
    
    // Variables for audio
    var audioPlayer = AVAudioPlayer()
    var gameMusicPlayer = AVAudioPlayer()
    
    // Check to stop players after losing health
    var stopBluePlayer = false
    var stopRedPlayer = false
    
    // Timers
    var coinTimer: NSTimer!
    var bombTimer: NSTimer!
    var stopBlueTimer: NSTimer!
    var stopRedTimer: NSTimer!
    var stopCoinParticleTimer: NSTimer!
    
    // Boolean to handle game over check
    var gameOverFlag = false
    
    override func didMoveToView(view: SKView) {
        
        super.didMoveToView(view)
        
        // Prevents return to menu on orientation change
        GlobalVariables.inMenu = false
        
        // Setup physics world
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -5)
        
        // Setup and scroll parallax background
        scrollBackground(bg1Texture, scrollSpeed: 0.50, bgzPosition: -3)
        scrollBackground(bg2Texture, scrollSpeed: 0.02, bgzPosition: -2)
        scrollBackground(bg2Texture, scrollSpeed: 0.005, bgzPosition: -1)

        // Setup and load players
        setupPlayers()
        
        // Add player nodes to the view
        bluePlayer.zPosition = -1
        redPlayer.zPosition = -1
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
        
        // Only add second player buttons if it is not single player game
        if GlobalVariables.singlePlayer == false {
            self.addChild(redBtnUp)
            self.addChild(redBtnDown)
            self.addChild(redBtnLeft)
            self.addChild(redBtnRight)
        }
        
        if GlobalVariables.soundOn {
            // Assign sounds
            coinCollectSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("coincollected", ofType: "wav")!)
            bombHitSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bombhit", ofType: "wav")!)
            gameOverSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gameover", ofType: "wav")!)
            gameBeginSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gamebegin", ofType: "wav")!)
            
            // Assign music
            music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gamemusic", ofType: "mp3")!)
            
            // Play the game begin sound
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: gameBeginSound)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print("error playing sound")
            }
            
            // Play the music or catch an error
            do {
                try gameMusicPlayer = AVAudioPlayer(contentsOfURL: music)
                gameMusicPlayer.numberOfLoops = -1
                gameMusicPlayer.prepareToPlay()
                gameMusicPlayer.play()
            } catch {
                print("error playing music!")
            }
        }
        
        coinTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameScene.addCoins), userInfo: nil, repeats: true)
        bombTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(GameScene.addBombs), userInfo: nil, repeats: true)
        
    }
    
    // Overriding touchesBegan to detect screen touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
           
            // Loop through the touches in event
            let location = touch.locationInNode(self)
            
            // Blue player change button texture and apply impulse to player
            if !stopBluePlayer {
                // Check if the touch locations are within button bounds
                if blueBtnUp.containsPoint(location) {
                    blueBtnUp.texture = btnTextureUpOn
                    bluePlayer.physicsBody!.applyImpulse(CGVectorMake(0,10))
                }
                if blueBtnDown.containsPoint(location) {
                    blueBtnDown.texture = btnTextureDownOn
                    bluePlayer.physicsBody!.applyImpulse(CGVectorMake(0,-10))
                }
                if blueBtnLeft.containsPoint(location) {
                    blueBtnLeft.texture = btnTextureLeftOn
                    bluePlayer.physicsBody!.applyImpulse(CGVectorMake(-10,0))
                }
                if blueBtnRight.containsPoint(location) {
                    blueBtnRight.texture = btnTextureRightOn
                    bluePlayer.physicsBody!.applyImpulse(CGVectorMake(10,0))
                }
            }
            
            // Red player change button texture and apply impulse to player
            if !stopRedPlayer && GlobalVariables.singlePlayer == false {
                if redBtnUp.containsPoint(location) {
                    redBtnUp.texture = btnTextureDownOn
                    redPlayer.physicsBody!.applyImpulse(CGVectorMake(0,-10))
                }
                if redBtnDown.containsPoint(location) {
                    redBtnDown.texture = btnTextureUpOn
                    redPlayer.physicsBody!.applyImpulse(CGVectorMake(0,10))
                }
                if redBtnLeft.containsPoint(location) {
                    redBtnLeft.texture = btnTextureRightOn
                    redPlayer.physicsBody!.applyImpulse(CGVectorMake(10,0))
                }
                if redBtnRight.containsPoint(location) {
                    redBtnRight.texture = btnTextureLeftOn
                    redPlayer.physicsBody!.applyImpulse(CGVectorMake(-10,0))
                }
            }
        }
    }
    
    // Overriding touchesBegan to detect screen touches
    // Touches ended will return button texture to original state
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            // Loop through the touches in event
            let location = touch.locationInNode(self)
            
            // Return button texture to original texture on button end
            if !stopBluePlayer {
                // Check if the touch locations are within button bounds
                if blueBtnUp.containsPoint(location) {
                    blueBtnUp.texture = btnTextureUp
                }
                if blueBtnDown.containsPoint(location) {
                    blueBtnDown.texture = btnTextureDown
                }
                if blueBtnLeft.containsPoint(location) {
                    blueBtnLeft.texture = btnTextureLeft
                }
                if blueBtnRight.containsPoint(location) {
                    blueBtnRight.texture = btnTextureRight
                }
            }
            
            // Return button texture to original texture on button end
            if !stopRedPlayer && GlobalVariables.singlePlayer == false {
                if redBtnUp.containsPoint(location) {
                    redBtnUp.texture = btnTextureDown
                }
                if redBtnDown.containsPoint(location) {
                    redBtnDown.texture = btnTextureUp
                }
                if redBtnLeft.containsPoint(location) {
                    redBtnLeft.texture = btnTextureRight
                }
                if redBtnRight.containsPoint(location) {
                    redBtnRight.texture = btnTextureLeft
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
        
        // Only assign second player buttons if game is multiplayer
        if GlobalVariables.singlePlayer == false {
            // Assign as SKSpriteNodes and load textures -- red buttons are inverted :)
            redBtnUp = SKSpriteNode(texture: btnTextureDown)
            redBtnDown = SKSpriteNode(texture: btnTextureUp)
            redBtnLeft = SKSpriteNode(texture: btnTextureRight)
            redBtnRight = SKSpriteNode(texture: btnTextureLeft)
        }
        // Assign button positions
        blueBtnUp.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.minY + 80)
        blueBtnDown.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.minY + 30)
        blueBtnLeft.position = CGPoint(x: CGRectGetMinX(scene!.view!.frame)+50, y: scene!.view!.bounds.minY + 30)
        blueBtnRight.position = CGPoint(x: CGRectGetMaxX(scene!.view!.frame)-50, y: scene!.view!.bounds.minY + 30)
        blueBtnUp.zPosition = 10
        blueBtnDown.zPosition = 10
        blueBtnLeft.zPosition = 10
        blueBtnRight.zPosition = 10
        
        // Only assign if not a single player game
        if GlobalVariables.singlePlayer == false {
        // Assign button positions
            redBtnUp.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.maxY - 80)
            redBtnDown.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.maxY - 30)
            redBtnLeft.position = CGPoint(x: CGRectGetMaxX(scene!.view!.frame)-50, y: scene!.view!.bounds.maxY - 30)
            redBtnRight.position = CGPoint(x: CGRectGetMinX(scene!.view!.frame)+50, y: scene!.view!.bounds.maxY - 30)
            redBtnUp.zPosition = 10
            redBtnDown.zPosition = 10
            redBtnLeft.zPosition = 10
            redBtnRight.zPosition = 10
        }
        
    }
    
    // Setup player sprites
    func setupPlayers() {
        
        // Assign as SKSpriteNodes and load textures
        bluePlayer = SKSpriteNode(texture: bluePlayerTexture)
        redPlayer = SKSpriteNode(texture: redPlayerTexture)
        
        // Assign player positions
        bluePlayer.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.minY + 130)
        redPlayer.position = CGPoint(x: CGRectGetMidX(scene!.view!.frame), y: scene!.view!.bounds.maxY - 130)
        
        // Assign player physics
        bluePlayer.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 30))//circleOfRadius: bluePlayerTexture.size().height/2)
        bluePlayer.physicsBody!.dynamic = true
        bluePlayer.physicsBody!.allowsRotation = false
        bluePlayer.physicsBody!.affectedByGravity = false
        bluePlayer.physicsBody!.categoryBitMask = blueCategory
        bluePlayer.physicsBody!.contactTestBitMask = coinCategory | bombCategory
    
        redPlayer.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(50, 30))//CGRectMake(0, 0, 60, 30))//SKPhysicsBody(circleOfRadius: redPlayerTexture.size().height/2)
        redPlayer.physicsBody!.dynamic = true
        redPlayer.physicsBody!.allowsRotation = false
        redPlayer.physicsBody!.affectedByGravity = false
        redPlayer.physicsBody!.categoryBitMask = redCategory
        redPlayer.physicsBody!.contactTestBitMask = coinCategory | bombCategory
        
        // Add player name labels
        blueNameLabel.fontName = "Chalkduster"
        blueNameLabel.fontSize = 25
        blueNameLabel.text = GlobalVariables.playerOneName
        blueNameLabel.position = CGPointMake(scene!.view!.bounds.minX+blueNameLabel.frame.width/2, scene!.view!.bounds.minY+80)
        self.addChild(blueNameLabel)
        redNameLabel.fontName = "Chalkduster"
        redNameLabel.fontSize = 25
        redNameLabel.text = GlobalVariables.playerTwoName
        redNameLabel.position = CGPointMake(scene!.view!.bounds.maxX-redNameLabel.frame.width/2, scene!.view!.bounds.maxY-80)
        redNameLabel.xScale = redNameLabel.xScale * -1
        redNameLabel.yScale = redNameLabel.yScale * -1
        self.addChild(redNameLabel)
        
        // Add player score labels
        blueCoinIcon.position = CGPointMake(scene!.view!.bounds.maxX-50, scene!.view!.bounds.minY+80)
        self.addChild(blueCoinIcon)
        blueScoreLabel.fontName = "Chalkduster"
        blueScoreLabel.fontSize = 25
        blueScoreLabel.text = "0"
        blueScoreLabel.position = CGPointMake(scene!.view!.bounds.maxX-25, scene!.view!.bounds.minY+80)
        self.addChild(blueScoreLabel)
        
        redCoinIcon.position = CGPointMake(scene!.view!.bounds.minX+50, scene!.view!.bounds.maxY-80)
        self.addChild(redCoinIcon)
        redScoreLabel.fontName = "Chalkduster"
        redScoreLabel.fontSize = 25
        redScoreLabel.text = "0"
        redScoreLabel.position = CGPointMake(scene!.view!.bounds.minX+25, scene!.view!.bounds.maxY-80)
        redScoreLabel.xScale = redScoreLabel.xScale * -1
        redScoreLabel.yScale = redScoreLabel.yScale * -1
        self.addChild(redScoreLabel)
        
    }
    
    // Update scores
    func updateScores() {
        redScoreLabel.text = String(GlobalVariables.redScore)
        blueScoreLabel.text = String(GlobalVariables.blueScore)
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
        // Set velocity to 2, to allow quick recovery and prevent sticky edges
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
        let x = CGFloat(arc4random() % UInt32(size.width) + UInt32(size.width))//(scene!.view!.bounds.maxX))
        let y = CGFloat(arc4random() % UInt32(size.height))// + scene!.view!.bounds.maxX)
        coin.position = CGPointMake(x,y)

        // Set up physics body
        coin.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        coin.physicsBody?.dynamic = true
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.categoryBitMask = coinCategory
        coin.physicsBody?.contactTestBitMask = blueCategory | redCategory
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
        let x = CGFloat(arc4random() % UInt32(size.width) + UInt32(size.width))//(scene!.view!.bounds.maxX))
        let y = CGFloat(arc4random() % UInt32(size.height))// + scene!.view!.bounds.maxX)
        bomb.position = CGPointMake(x,y)
        
        // Assign physics body attributes
        bomb.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        bomb.physicsBody?.dynamic = true
        bomb.physicsBody?.affectedByGravity = false
        bomb.physicsBody?.categoryBitMask = bombCategory
        bomb.physicsBody?.contactTestBitMask = blueCategory | redCategory
        bomb.physicsBody?.fieldBitMask = noFieldCategory
        bomb.physicsBody?.velocity = CGVectorMake(-100,0)
        bomb.runAction(SKAction.rotateByAngle(45, duration: 5))
        self.addChild(bomb)
        
    }
    
    // Removes bombs
    func removeBombs() {
        if bomb.position.x < scene!.view!.bounds.minX {
            bomb.removeFromParent()
        }
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
            GlobalVariables.blueScore+=1
            print("bluePlayerScore is \(GlobalVariables.blueScore)")
            if secondBody.node != nil {
                secondBody.node!.removeFromParent()
            }
            if coinHitParticle != nil {
                coinHitParticle?.removeFromParent() // Removes existing coinhit particle
            }
            
            // Add the coin collected particle effect
            coinHitParticle!.targetNode = self
            bluePlayer.addChild(coinHitParticle!)

            
            // Play the coin collected sound
            if GlobalVariables.soundOn {
                do {
                    try audioPlayer = AVAudioPlayer(contentsOfURL: coinCollectSound)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                } catch {
                    print("error playing sound")
                }
            }
            
        } else if firstBody.categoryBitMask==redCategory && secondBody.categoryBitMask==coinCategory {
            //print("redCategory and coinCategory contact")
            GlobalVariables.redScore+=1
            print("redPlayerScore is \(GlobalVariables.redScore)")
            if secondBody.node != nil {
                secondBody.node!.removeFromParent()
            }
            if coinHitParticle != nil {
                coinHitParticle?.removeFromParent() // Removes existing coinhit particle
                stopCoinParticleTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameScene.stopSparkle), userInfo: nil, repeats: false)
            }
            
            // Add the coin collected particle
            coinHitParticle!.targetNode = self
            redPlayer.addChild(coinHitParticle!)
            
            // Play the coin collected sound
            if GlobalVariables.soundOn {
                do {
                    try audioPlayer = AVAudioPlayer(contentsOfURL: coinCollectSound)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                } catch {
                    print("error playing sound")
                }
            }
        }
        
        // Check for contact between players and bombs
        if firstBody.categoryBitMask==blueCategory && secondBody.categoryBitMask==bombCategory {
            print("blueCategory and bombCategory contact")
            GlobalVariables.blueHealth-=1
            print("blue health is \(GlobalVariables.blueHealth)")
            if bombHitParticle != nil {
                bombHitParticle?.removeFromParent() // Removes existing bombhit particle
            }
            
            // add the bomb hit particle
            bombHitParticle!.targetNode = self
            bluePlayer.addChild(bombHitParticle!)
            
            stopBluePlayerTimer() // = true
            if secondBody.node != nil {
                secondBody.node!.removeFromParent()
            }
            
            // Play the bomb hit sound
            if GlobalVariables.soundOn {
                do {
                    try audioPlayer = AVAudioPlayer(contentsOfURL: bombHitSound)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                } catch {
                    print("error playing sound")
                }
            }
            
        } else if firstBody.categoryBitMask==redCategory && secondBody.categoryBitMask==bombCategory {
            print("redCategory and bombCategory contact")
            GlobalVariables.redHealth-=1
            print("red health is \(GlobalVariables.redHealth)")
            if bombHitParticle != nil {
                bombHitParticle?.removeFromParent() // Removes existing bombhit particle
            }
            
            // Add the bomb hit particle
            bombHitParticle!.targetNode = self
            redPlayer.addChild(bombHitParticle!)
            stopRedPlayerTimer() // = true
            if secondBody.node != nil {
                secondBody.node!.removeFromParent()
            }
            
            // Play the bomb hit sound
            if GlobalVariables.soundOn {
                do {
                    try audioPlayer = AVAudioPlayer(contentsOfURL: bombHitSound)
                    audioPlayer.prepareToPlay()
                    audioPlayer.play()
                } catch {
                    print("error playing sound")
                }
            }
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
        bombHitParticle?.removeFromParent()
    }
    
    // Setup timer to stop red player movement
    func stopRedPlayerTimer() {
        stopRedPlayer = true
        stopRedTimer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(GameScene.startRedPlayer), userInfo: nil, repeats: false)
    }
    
    // Function is called after 3 seconds to allow movement
    func startRedPlayer() {
        stopRedPlayer = false
        bombHitParticle?.removeFromParent()
    }
    
    // Function is called after 1 second to clear coin collect sparkle effect
    func stopSparkle() {
        if coinHitParticle  != nil {
            coinHitParticle!.removeFromParent()
        }
    }
    
    // Start game over
    func gameOver() {
        
        print("Game over started.")
        
        // Only stop music if it is on and play game over sound
        if GlobalVariables.soundOn {
            gameMusicPlayer.stop()
            // stop the music or catch an error
            do {
                try gameMusicPlayer = AVAudioPlayer(contentsOfURL: gameOverSound)
                gameMusicPlayer.numberOfLoops = 0
                gameMusicPlayer.prepareToPlay()
                gameMusicPlayer.play()
            } catch {
                print("error stopping music!")
            }
        }
        
        // Add game over label
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 45
        gameOverLabel.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY)//+ 85)
        self.addChild(gameOverLabel)
        
        // Set the winner and loser labels
        if GlobalVariables.winner == 1 {
            // Add game over label
            let winnerLabel = SKLabelNode(fontNamed: "Chalkduster")
            winnerLabel.text = "\(GlobalVariables.playerOneName) Wins!"
            winnerLabel.fontSize = 30
            winnerLabel.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY - 30)//+ 85)
            self.addChild(winnerLabel)
            
            let loserLabel = SKLabelNode(fontNamed: "Chalkduster")
            loserLabel.text = "\(GlobalVariables.playerTwoName) Loses!"
            loserLabel.fontSize = 30
            loserLabel.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY - 60)//+ 85)
            self.addChild(loserLabel)
        }
        
        if GlobalVariables.winner == 2 {
            // Add game over label
            let winnerLabel = SKLabelNode(fontNamed: "Chalkduster")
            winnerLabel.text = "\(GlobalVariables.playerTwoName) Wins!"
            winnerLabel.fontSize = 30
            winnerLabel.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY - 30)//+ 85)
            self.addChild(winnerLabel)
            
            let loserLabel = SKLabelNode(fontNamed: "Chalkduster")
            loserLabel.text = "\(GlobalVariables.playerOneName) Loses!"
            loserLabel.fontSize = 30
            loserLabel.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.midY - 60)//+ 85)
            self.addChild(loserLabel)
        }
        
        // Invalidate timers
        coinTimer.invalidate()
        bombTimer.invalidate()
        print("Timers invalidated")
        // Transisition into game over scene
        let gameOverScene = GameOverScene(size: view!.bounds.size)
        let transition = SKTransition.fadeWithDuration(0.15)
        print("transitions loaded")
        gameOverScene.scaleMode = .ResizeFill
        view!.presentScene(gameOverScene, transition: transition)
        print("view presented")
    }
    
    // Scrolling background
    func scrollBackground(backgroundTexture: SKTexture, scrollSpeed: CGFloat, bgzPosition: CGFloat) {
        
        // Moves from left to right.
        let moveBackground = SKAction.moveByX(-backgroundTexture.size().width, y: 0, duration: NSTimeInterval(scrollSpeed * backgroundTexture.size().width))
        
        // Resets on right side
        let resetBackGround = SKAction.moveByX(backgroundTexture.size().width, y: 0, duration: 0.0)
        
        // Move forever
        let moveBackgoundForever = SKAction.repeatActionForever(SKAction.sequence([moveBackground, resetBackGround]))
        
        // This loop makes alignment from end to end
        for var i:CGFloat = 0; i<2 + self.frame.size.width / (backgroundTexture.size().width); ++i {
            let sprite = SKSpriteNode(texture: backgroundTexture)
            sprite.setScale(2.0)
            sprite.position = CGPointMake(i * sprite.size.width, sprite.size.height / 2)
            sprite.zPosition = bgzPosition
            
            sprite.runAction(moveBackgoundForever)
            self.addChild(sprite)
        }
    }
    
    // Function is called before each frame is rendered
    override func update(currentTime: CFTimeInterval) {
       
        // Check for game over if conditions met
        if GlobalVariables.blueHealth <= 0 || GlobalVariables.redHealth <= 0 {
            
            // Check for winner according to health
            if GlobalVariables.blueHealth > GlobalVariables.redHealth {
                GlobalVariables.winner = 1 // blue winner
            }
            if GlobalVariables.redHealth > GlobalVariables.blueHealth {
                GlobalVariables.winner = 2 // red winner
            }
            if GlobalVariables.blueHealth == GlobalVariables.redHealth {
                GlobalVariables.winner = 0 // tie game
            }
            
            gameOverFlag = true
        }

        // Launch game over
        if gameOverFlag == true {
            
            // Begin game over sequence
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
