//
//  MenuScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/19/16.
//  Copyright © 2016 Salt Lake Community College. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene, UITextFieldDelegate {

    var singleLabel: SKLabelNode!
    var multiLabel: SKLabelNode!
    var playerOneNameTextField: UITextField!
    var playerTwoNameTextField: UITextField!
    
    let mainLabel = SKLabelNode(fontNamed:"Chalkduster")
    var p1NameLabel = SKLabelNode(fontNamed: "Chalkduster")
    var p2NameLabel = SKLabelNode(fontNamed: "Chalkduster")
    let enterNameLabel1 = SKLabelNode(fontNamed: "Chalkduster")
    let enterNameLabel2 = SKLabelNode(fontNamed: "Chalkduster")
    let enterNameLabel3 = SKLabelNode(fontNamed: "Chalkduster")
    let goLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    // Load menu view
    override func didMoveToView(view: SKView) {
        mainLabel.text = "Battle Penguins"
        mainLabel.fontSize = 35
        mainLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame ) + 85)
        self.addChild(mainLabel)
        
        addButtons()
        //if getPlayerOneName
        
    }
   
    // Check for menu touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            // Checks if the single player option is touched
            if singleLabel.containsPoint(location) {
                singleLabel.removeFromParent()
                GlobalVariables.singlePlayer = true
                print("One player game")
                getOneName()
            }
            
            // Checks if the multi player option is touched
            if multiLabel.containsPoint(location) {
                GlobalVariables.singlePlayer = false
                print("Two player game")
                getOneName()
                getTwoName()
            }
            if goLabel.containsPoint(location) {
                print("Game is starting...")
                startGame()
            }
            
            // Hide keyboards on touch if needed
            playerOneNameTextField.resignFirstResponder()
            if playerTwoNameTextField != nil {
                playerTwoNameTextField.resignFirstResponder()
            }
        }
    }
    
    // Get name for one player game
    private func getOneName() {
        
        // Remove existing labels from screen to make room
        mainLabel.removeFromParent()
        singleLabel.removeFromParent()
        multiLabel.removeFromParent()
        
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
        singleLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame ))
        self.addChild(singleLabel)
        
        // Multi player label / button
        multiLabel = SKLabelNode(fontNamed:"Chalkduster")
        multiLabel.text = "Two Players"
        multiLabel.fontSize = 35
        multiLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 50)
        self.addChild(multiLabel)
    
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
    
    private func startGame() {
        
        // Assign global names
        GlobalVariables.playerOneName = p1NameLabel.text
        
        // Remove textfields before starting game
        playerOneNameTextField.removeFromSuperview()
        if playerTwoNameTextField != nil {
            GlobalVariables.playerTwoName = p2NameLabel.text!
            playerTwoNameTextField.removeFromSuperview()
        }
        
        print("Player one is \(GlobalVariables.playerOneName)")
        print("Player two is \(GlobalVariables.playerTwoName)")
        
        let gameScene = GameScene(fileNamed: "GameScene")
        let transition = SKTransition.fadeWithDuration(0.15)
        
        gameScene!.scaleMode = .ResizeFill
        view!.presentScene(gameScene!, transition: transition)
    }
}
