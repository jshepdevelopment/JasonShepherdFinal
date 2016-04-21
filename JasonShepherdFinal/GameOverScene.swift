//
//  GameOverScene.swift
//  JasonShepherdFinal
//
//  Created by Jason Shepherd on 4/20/16.
//  Copyright © 2016 Salt Lake Community College. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    var gameOverLabel = SKLabelNode(fontNamed:"Chalkduster")
    var highScoreLabel = SKLabelNode(fontNamed:"Chalkduster")

    
    // Store high scores as array of strings
    var highScores = [1,10,20]
    var highScoreNames = ["Billy", "Bobby", "Timmy"]
    var currentHighScore = 0
    var currentHighScoreName = "CPU"
    
    override func didMoveToView(view: SKView) {

        
        gameOverLabel.text = "Game Over!"
        gameOverLabel.fontSize = 35
        gameOverLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMaxY(self.frame ) - 50)
        self.addChild(gameOverLabel)
        
        highScoreLabel.text = "High Scores"
        highScoreLabel.fontSize = 35
        highScoreLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame ) + 250)
        self.addChild(highScoreLabel)
        
        //saveHighScores()
        checkHighScores()
        showHighScores()
        saveHighScores()
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
    
    func saveHighScores() {
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

        }
        if GlobalVariables.winner == 2 {
            currentHighScore = GlobalVariables.redScore
            currentHighScoreName = GlobalVariables.playerTwoName
        }
        
        if currentHighScore > highScores[0] && currentHighScore < highScores[1] && currentHighScore < highScores[2] {
            highScores[0] = currentHighScore
            highScoreNames[0] = currentHighScoreName
            
        }
        if currentHighScore > highScores[0] && currentHighScore > highScores[1] && currentHighScore < highScores[2] {
            highScores[1] = currentHighScore
            highScoreNames[1] = currentHighScoreName
        }
        if currentHighScore > highScores[0] && currentHighScore > highScores[1] && currentHighScore > highScores[2] {            highScores[2] = currentHighScore
            highScoreNames[2] = currentHighScoreName
        }


    }
    
    // Function to show high scores
    func showHighScores() {
        
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
