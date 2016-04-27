//
//  MenuScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/19/16.
//  Copyright © 2016 Salt Lake Community College. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene, UITextFieldDelegate {
    
    // UI labels and textfields for name input
    var singleLabel: SKLabelNode!
    var multiLabel: SKLabelNode!
    
    var playerOneNameTextField: UITextField!
    var playerTwoNameTextField: UITextField!
    
    // UI Labels for menu
    var mainLabel1 = SKLabelNode(fontNamed:"Chalkduster")
    var mainLabel2 = SKLabelNode(fontNamed:"Chalkduster")
    var p1NameLabel = SKLabelNode(fontNamed: "Chalkduster")
    var p2NameLabel = SKLabelNode(fontNamed: "Chalkduster")
    let enterNameLabel1 = SKLabelNode(fontNamed: "Chalkduster")
    let enterNameLabel2 = SKLabelNode(fontNamed: "Chalkduster")
    let enterNameLabel3 = SKLabelNode(fontNamed: "Chalkduster")
    let goLabel = SKLabelNode(fontNamed: "Chalkduster")
    let soundLabel = SKLabelNode(fontNamed: "Chalkduster")
    let onLabel = SKLabelNode(fontNamed: "Chalkduster")
    let offLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    let bg2 = SKSpriteNode(texture: SKTexture(imageNamed: "bpmenu.png"))
    
    // Load menu view
    override func didMoveToView(view: SKView) {
        
        super.didMoveToView(view)
        
        // Reset global variables if it happens to be a continued game
        GlobalVariables.blueScore = 0
        GlobalVariables.redScore = 0
        GlobalVariables.blueHealth = 3
        GlobalVariables.redHealth = 3
        
        // Add buttons
        if !GlobalVariables.optionMade {
            
            // Adding static background first
            let bg1 = SKSpriteNode(texture: SKTexture(imageNamed: "background1.png"))
            //bg1Texture.size.height = self.size.height
            bg1.size.width = self.size.width
            bg1.position = CGPointMake(self.size.width/2, self.size.height/2)
            bg1.setScale(2)
            bg1.zPosition = -5
            self.addChild(bg1)
            
            // Add scrolling stars to menu
            scrollBackground(SKTexture(imageNamed: "background2.png"), scrollSpeed: 0.01, bgzPosition: -3)
            
            // Add the battle penguin dudes
            //bg1Texture.size.height = self.size.height
            bg2.size.width = self.size.width
            bg2.position = CGPointMake(self.size.width/2, self.view!.bounds.minY+bg2.size.height/2)
            //bg2.setScale(2)
            bg2.zPosition = -3
            self.addChild(bg2)
            
            // Add menu label
            mainLabel1.text = "Battle"
            mainLabel1.fontSize = 50
            mainLabel1.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.maxY - 60)//+ 85)
            self.addChild(mainLabel1)
            
            mainLabel2.text = "Penguins!"
            mainLabel2.fontSize = 50
            mainLabel2.position = CGPoint(x: self.view!.bounds.midX, y: self.view!.bounds.maxY - 110)//+ 85)
            self.addChild(mainLabel2)
            
            // Add the buttons
            addButtons()
        }
    }
   
    // Check for menu touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Gets touches
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            // Checks if the single player option is touched
            if singleLabel.containsPoint(location) && !GlobalVariables.optionMade {
                mainLabel1.removeFromParent()
                mainLabel2.removeFromParent()
                singleLabel.removeFromParent()
                multiLabel.removeFromParent()
                soundLabel.removeFromParent()
                onLabel.removeFromParent()
                offLabel.removeFromParent()
                bg2.removeFromParent()
                GlobalVariables.singlePlayer = true
                print("One player game")
                GlobalVariables.optionMade = true
                GlobalVariables.onePlayerGame = true
                getOneName()
                
            }
            
            // Checks if the multi player option is touched
            if multiLabel.containsPoint(location) && !GlobalVariables.optionMade {
                mainLabel1.removeFromParent()
                mainLabel2.removeFromParent()
                singleLabel.removeFromParent()
                multiLabel.removeFromParent()
                soundLabel.removeFromParent()
                onLabel.removeFromParent()
                offLabel.removeFromParent()
                bg2.removeFromParent()
                GlobalVariables.singlePlayer = false
                print("Two player game")
                GlobalVariables.optionMade = true
                GlobalVariables.twoPlayerGame = true
                getOneName()
                getTwoName()
                
            }
           
            // Checks if begin button is touched
            if goLabel.containsPoint(location) {
                print("Game is starting...")
                startGame()
            }
            
            // Hide keyboards on touch if needed
            if playerOneNameTextField != nil {
                playerOneNameTextField.resignFirstResponder()
            }
            if playerTwoNameTextField != nil {
                playerTwoNameTextField.resignFirstResponder()
            }
        }
    }
    
    // Get name for one player game
    private func getOneName() {
        
        // Setup textfield for player one name prompt
        playerOneNameTextField = UITextField(frame: CGRectMake(view!.bounds.width / 2 - 160, view!.bounds.height / 2 - 80, 320, 40))
        view!.addSubview(playerOneNameTextField)
        playerOneNameTextField.delegate = self
        playerOneNameTextField.borderStyle = UITextBorderStyle.RoundedRect
        playerOneNameTextField.backgroundColor = SKColor.whiteColor()
        playerOneNameTextField.textColor = SKColor.blackColor()
        playerOneNameTextField.font = UIFont(name: "Chalkduster", size: 30)
        playerOneNameTextField.placeholder = "Player 1 name"
        playerOneNameTextField.autocorrectionType = UITextAutocorrectionType.Yes
        playerOneNameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        playerOneNameTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        playerOneNameTextField.tag = 100 // Useful for distinguishing between text fields in textFieldShouldReturn
        self.view!.addSubview(playerOneNameTextField)
        
        // Set up SKLabelNode to display name
        p1NameLabel.fontSize = 30
        p1NameLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 100)
        p1NameLabel.text = ""
        addChild(p1NameLabel)
        
        // Set up a title for name screen using multiple SKLabelNodes, becuase SKLabelNode only supports one line
        enterNameLabel1.fontSize = 35
        enterNameLabel1.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-50)
        enterNameLabel1.text = "Name"
        enterNameLabel2.fontSize = 35
        enterNameLabel2.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-85)
        enterNameLabel2.text = "your"
        enterNameLabel3.fontSize = 35
        enterNameLabel3.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame)-120)
        enterNameLabel3.text = "Penguin!"

        addChild(enterNameLabel1)
        addChild(enterNameLabel2)
        addChild(enterNameLabel3)
        
        goLabel.fontSize = 35
        goLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMinY(self.frame)+35)
        goLabel.text = "Begin"
        addChild(goLabel)
    }
    
    // Get another name for two player game
    private func getTwoName() {
        
        // Setup textfield for player one name prompt
        playerTwoNameTextField = UITextField(frame: CGRectMake(view!.bounds.width / 2 - 160, view!.bounds.height / 2 - 20, 320, 40))
        view!.addSubview(playerTwoNameTextField)
        playerTwoNameTextField.delegate = self
        playerTwoNameTextField.borderStyle = UITextBorderStyle.RoundedRect
        playerTwoNameTextField.backgroundColor = SKColor.whiteColor()
        playerTwoNameTextField.textColor = SKColor.blackColor()
        playerTwoNameTextField.font = UIFont(name: "Chalkduster", size: 30)
        playerTwoNameTextField.placeholder = "Player 2 name"
        playerTwoNameTextField.autocorrectionType = UITextAutocorrectionType.Yes
        playerTwoNameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        playerTwoNameTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        playerTwoNameTextField.tag = 101 // Useful for distinguishing between text fields in textFieldShouldReturn
        self.view!.addSubview(playerTwoNameTextField)
        
        p2NameLabel.fontSize = 30
        p2NameLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 150)
        p2NameLabel.text = ""
        addChild(p2NameLabel)
        
    }
    
    // Add buttons to menu
    private func addButtons() {
        
        // Single player label / button
        singleLabel = SKLabelNode(fontNamed:"Chalkduster")
        singleLabel.text = "One Player"
        singleLabel.fontSize = 35
        singleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame ) + 120)
        self.addChild(singleLabel)
        
        // Multi player label / button
        multiLabel = SKLabelNode(fontNamed:"Chalkduster")
        multiLabel.text = "Two Players"
        multiLabel.fontSize = 35
        multiLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) + 70)
        self.addChild(multiLabel)
        
        // Sound label / on off buttons
        soundLabel.text = "Sound"
        soundLabel.fontSize = 35
        soundLabel.position = CGPoint(x:CGRectGetMidX(self.frame)-soundLabel.frame.width/2, y:CGRectGetMidY(self.frame ) - 25)
        self.addChild(soundLabel)
        onLabel.text = "On"
        onLabel.fontSize = 30
        onLabel.fontColor = UIColor.greenColor()
        onLabel.position = CGPoint(x:CGRectGetMidX(self.frame)+onLabel.frame.width, y:CGRectGetMidY(self.frame ) - 25)
        self.addChild(onLabel)
        offLabel.text = "Off"
        offLabel.fontSize = 30
        offLabel.position = CGPoint(x:CGRectGetMidX(self.frame)+offLabel.frame.width*2, y:CGRectGetMidY(self.frame ) - 25)
        self.addChild(offLabel)
    
    }
    
    // Called when return is touched
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        if textField.tag == 100 {
            p1NameLabel.removeFromParent()
            p1NameLabel.text = textField.text
            // Prevent more than 8 characters in name
            if textField.text?.characters.count > 8 {
                p1NameLabel.text = textField.text?.substringToIndex(textField.text!.startIndex.advancedBy(9))
            }
            addChild(p1NameLabel)
        }
        
        if textField.tag == 101 {
            p2NameLabel.removeFromParent()
            p2NameLabel.text = textField.text
            // Prevent more than 8 characters in name
            if textField.text?.characters.count > 8 {
                p2NameLabel.text = textField.text?.substringToIndex(textField.text!.startIndex.advancedBy(9))
            }
            addChild(p2NameLabel)
        }
        
        // Hides the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    // Called if done editing a textfield
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.tag == 100 {
            p1NameLabel.removeFromParent()
            p1NameLabel.text = textField.text
            // Prevent more than 8 characters in name
            if textField.text?.characters.count > 8 {
                p1NameLabel.text = textField.text?.substringToIndex(textField.text!.startIndex.advancedBy(9))
            }
            addChild(p1NameLabel)
        }
        
        if textField.tag == 101 {
            p2NameLabel.removeFromParent()
            p2NameLabel.text = textField.text
            // Prevent more than 8 characters in name
            if textField.text?.characters.count > 8 {
                p2NameLabel.text = textField.text?.substringToIndex(textField.text!.startIndex.advancedBy(9))
            }
            addChild(p2NameLabel)
        }
    }
    
    // Function to start game
    private func startGame() {
        
        // Reset option made if continued game is needed
        
        // Assign global names and remove textfields based on game type
        if GlobalVariables.onePlayerGame {
            if playerOneNameTextField != nil {
                GlobalVariables.playerOneName = p1NameLabel.text
                playerOneNameTextField.removeFromSuperview()
            }
            GlobalVariables.onePlayerGame = false // Reset for next game if needed
        }
        if GlobalVariables.twoPlayerGame {
            if playerTwoNameTextField != nil {
                GlobalVariables.playerTwoName = p2NameLabel.text!
                playerTwoNameTextField.removeFromSuperview()
                GlobalVariables.playerOneName = p1NameLabel.text
                playerOneNameTextField.removeFromSuperview()
                
            }
            GlobalVariables.twoPlayerGame = false // Reset for next game if needed
        }
        
        // send to console for debugging
        print("Player one is \(GlobalVariables.playerOneName)")
        print("Player two is \(GlobalVariables.playerTwoName)")
        
        // Transistion to game scene
        let gameScene = GameScene(fileNamed: "GameScene")
        let transition = SKTransition.fadeWithDuration(0.15)
        
        gameScene!.scaleMode = .ResizeFill
        view!.presentScene(gameScene!, transition: transition)
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
}
