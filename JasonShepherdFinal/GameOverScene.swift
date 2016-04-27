//
//  GameOverScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/20/16.
//  Copyright © 2016 Salt Lake Community College. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameOverScene: SKScene {
    
    // Labels that are needed for Game Over scene UI
    var gameOverLabel = SKLabelNode(fontNamed:"Chalkduster")
    var highScoreLabel = SKLabelNode(fontNamed:"Chalkduster")
    var playAgainLabel = SKLabelNode(fontNamed:"Chalkduster")
    var yesLabel = SKLabelNode(fontNamed:"Chalkduster")
    var noLabel = SKLabelNode(fontNamed:"Chalkduster")
    var winnerLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    // Store high scores as array of strings
    var highScores = [1,10,20]
    var highScoreNames = ["Billy", "Bobby", "Timmy"]
    var currentHighScore = 0
    var currentHighScoreName = "CPU"
    
    override func didMoveToView(view: SKView) {
        
        // Tell the global view controller that we are in the game over menu
        GlobalVariables.inGameOverMenu = true
        
        // Setup and display game over UI lables
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 35
        gameOverLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame ) - 50)
        self.addChild(gameOverLabel)
        
        highScoreLabel.text = "High Scores"
        highScoreLabel.fontSize = 35
        highScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame ) - 100 )
        self.addChild(highScoreLabel)
        
        winnerLabel.text = ""
        winnerLabel.fontSize = 35
        winnerLabel.fontColor = UIColor.yellowColor()
        winnerLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMinY(self.frame ) + 150)
        self.addChild(winnerLabel)
        
        playAgainLabel.text = "Play Again?"
        playAgainLabel.fontSize = 35
        playAgainLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMinY(self.frame ) + 90 )
        self.addChild(playAgainLabel)
        
        yesLabel.text = "Yes"
        yesLabel.fontSize = 35
        yesLabel.position = CGPoint(x:CGRectGetMidX(self.frame)-65, y:CGRectGetMinY(self.frame ) + 35 )
        self.addChild(yesLabel)
        
        noLabel.text = "No"
        noLabel.fontSize = 35
        noLabel.position = CGPoint(x:CGRectGetMidX(self.frame)+35, y:CGRectGetMinY(self.frame ) + 35 )
        self.addChild(noLabel)
        
        //saveHighScores()
        checkHighScores()
        showHighScores()
        saveHighScores()
    }
    
    // Begins on touch
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        // Loop through objects on touch
        for touch: AnyObject in touches {
            
            // Set location of touch
            let location = touch.locationInNode(self)
            
            // Checks if yes option is touched
            if yesLabel.containsPoint(location) {
                print("Yes to play again. Starting menu")
                startMenu()
            }
            
            // Checks if no option is touched
            if noLabel.containsPoint(location) {
                print("No to play again. Suspending application")
                //GlobalVariables.inGameOverMenu = false
                //GlobalVariables.in
                UIControl().sendAction(#selector(NSURLSessionTask.suspend), to: UIApplication.sharedApplication(), forEvent: nil)
            }
        }
    }
    
    // Scene to launch the menu
    private func startMenu() {
        
        // Reset game type selection for new game if needed
        GlobalVariables.optionMade = false
        GlobalVariables.onePlayerGame = false
        GlobalVariables.twoPlayerGame = false
        GlobalVariables.inMenu = true
        GlobalVariables.inGameOverMenu = false
        
        // Transition to menu
        let menuScene = MenuScene(size: view!.bounds.size)
        let transition = SKTransition.fadeWithDuration(0.15)
        
        menuScene.scaleMode = .ResizeFill
        view!.presentScene(menuScene, transition: transition)
    }
    
    // Function to save highs scores
    func saveHighScores() {
        
        //Sets high scores and synchs with storage
        NSUserDefaults.standardUserDefaults().setObject(highScores, forKey: "highScoresInt")
        NSUserDefaults.standardUserDefaults().setObject(highScoreNames, forKey: "highScoresStr")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    // Function to check high scores and update if needed
    func checkHighScores() {
        
        // Sync high scores with permanent storage
        if NSUserDefaults.standardUserDefaults().objectForKey("highScoresInt") != nil {
            highScores = NSUserDefaults.standardUserDefaults().objectForKey("highScoresInt") as! [Int]
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("highScoresStr") != nil {
            highScoreNames = NSUserDefaults.standardUserDefaults().objectForKey("highScoresStr") as! [String]
        }
        
        // Check high score of winner
        if GlobalVariables.winner == 1 {
            currentHighScore = GlobalVariables.blueScore
            currentHighScoreName = GlobalVariables.playerOneName
            winnerLabel.text = "\(GlobalVariables.playerOneName) won!"

        }
        if GlobalVariables.winner == 2 {
            currentHighScore = GlobalVariables.redScore
            currentHighScoreName = GlobalVariables.playerTwoName
            winnerLabel.text = "\(GlobalVariables.playerTwoName) won!"
           
        }
        
        // High score at 3rd place
        if currentHighScore > highScores[0] && currentHighScore < highScores[1] && currentHighScore < highScores[2] {
            
            // Set 3rd position, erasing current 3rd
            highScores[0] = currentHighScore
            highScoreNames[0] = currentHighScoreName
        }
        
        // High score at 2nd place
        if currentHighScore > highScores[0] && currentHighScore > highScores[1] && currentHighScore < highScores[2] {
            
            // Move 2nd and 3rd position down
            highScores[0] = highScores[1]
            highScoreNames[0] = highScoreNames[1]
            
            // Set 2nd position
            highScores[1] = currentHighScore
            highScoreNames[1] = currentHighScoreName
        }
        
        // High score at 1st place
        if currentHighScore > highScores[0] && currentHighScore > highScores[1] && currentHighScore > highScores[2] {
            
            // Move 1st and 2nd position down
            highScores[0] = highScores[1]
            highScoreNames[0] = highScoreNames[1]
            highScores[1] = highScores[2]
            highScoreNames[1] = highScoreNames[2]
            
            // Set 1st position
            highScores[2] = currentHighScore
            highScoreNames[2] = currentHighScoreName
        }


    }
    
    // Function to show high scores
    func showHighScores() {
        
        // Setup UI label for scores
        var scoreLabel = [SKLabelNode(fontNamed:"Chalkduster")]
        
        // Loop through high scores and display
        for i in 0 ..< highScores.count {
            scoreLabel.append(SKLabelNode(fontNamed:"ChalkDuster"))
            
            scoreLabel[i].text = String(highScores[i])
            scoreLabel[i].fontSize = 35
            scoreLabel[i].position = CGPoint(x:CGRectGetMidX(self.frame)+120, y:CGRectGetMidY(self.frame ) + CGFloat(Double(i*38)))
            self.addChild(scoreLabel[i])
        }
        var nameLabel = [SKLabelNode(fontNamed:"Chalkduster")]
        
        // Loop through high scores and display
        for i in 0 ..< highScores.count {
            nameLabel.append(SKLabelNode(fontNamed:"ChalkDuster"))
            
            nameLabel[i].text = String(highScoreNames[i])
            nameLabel[i].fontSize = 35
            nameLabel[i].position = CGPoint(x:CGRectGetMidX(self.frame)-80, y:CGRectGetMidY(self.frame ) + CGFloat(Double(i*38)))
            self.addChild(nameLabel[i])
        }
    }
}
