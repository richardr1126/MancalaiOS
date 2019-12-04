//
//  GameScene.swift
//  MancalaGame
//
//  Created by Richard Roberson on 11/12/19.
//  Copyright © 2019 Richard Roberson. All rights reserved.
//

import SpriteKit
import GameplayKit




class GameScene: SKScene {
    
    var touchLocation = CGPoint()
    var touchPlace = CGPoint()
    var gameBoard = SKNode()
    var pits: Array<Pit> = Array(repeating: Pit(), count: 14)
    var pitsAcross: Array<Pit> = Array(repeating: Pit(), count: 14)
    var score1 = 0
    var score2 = 0
    let label1 = SKLabelNode()
    let label2 = SKLabelNode()
    var playerOutline = SKShapeNode()
    var bonusLabel = SKLabelNode()
    var winner = 0
    var currentPlayer = 1
    var resetButton = SKNode()
    
    override func sceneDidLoad() {
        setUpGameBoard()
       
    }
    
    func adjustScore1(by points: Int) {
        score1 += points
        label1.removeFromParent()
        label1.position = CGPoint(x: -735, y: -299)
        label1.zPosition = 0
        label1.fontSize = 70
        label1.text = "\(score1)"
        label1.fontName = "HelveticaNeue-Bold"
        label1.fontColor = .red
        self.addChild(label1)
        
    }
    
    func adjustScore2(by points: Int) {
        score2 += points
        label2.removeFromParent()
        label2.position = CGPoint(x: 725, y: 250)
        label2.zPosition = 0
        label2.fontSize = 70
        label2.text = "\(score2)"
        label2.fontName = "HelveticaNeue-Bold"
        label2.fontColor = .red
        self.addChild(label2)
        
    }

    func bonusLabelSequence(text: String) -> SKAction {
        
        let changeText = SKAction.run {
            
            self.bonusLabel.text = text
        }
        return SKAction.sequence([changeText, SKAction.fadeIn(withDuration: 0.5), SKAction.wait(forDuration: 1.5), SKAction.fadeOut(withDuration: 0.5)])
        
    }
    
    func bonusLabelWinSequence(text: String) -> SKAction {
        
        let changeText = SKAction.run {
            
            self.bonusLabel.text = text
        }
        return SKAction.sequence([changeText, SKAction.fadeIn(withDuration: 0.5), SKAction.wait(forDuration: 10)])
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: gameBoard)
            touchPlace = touch.location(in: self)

            if let currentPit = ((gameBoard.atPoint(touchLocation).parent) ?? pits[0]) as? Pit {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.checkWinner()
                }
                
                playerActions(currentPit)

            }
            if (self.atPoint(touchPlace) == resetButton) {
                masterView.isOver = true
                print("pressed")
            }
            
            
            
        }
    }
    
    func checkScore() {
        if score2 > score1 {
            bonusLabel.run(bonusLabelWinSequence(text: "Player 2 Wins!!"))
        } else if score1 > score2 {
            bonusLabel.run(bonusLabelWinSequence(text: "Player 1 Wins!!"))
        }
    }
    
    func checkWinner() {
        if ((pits[0].chips.count == 0) && (pits[1].chips.count == 0) && (pits[2].chips.count == 0) && (pits[3].chips.count == 0) && (pits[4].chips.count == 0) && (pits[5].chips.count == 0)) {

            for v in 7..<13 {
                for z in 0..<pits[v].chips.count {
                    let chip = pits[v].chips[z]
                    let parent = chip.parent as! Pit
                    moveChip(currentChip: chip, chipParent: parent, pitAfterClick: pits[13], targetPoint: pits[13].position)
                    adjustScore1(by: 1)
                }
            }
            
            checkScore()
            
            
        } else if ((pits[7].chips.count == 0) && (pits[8].chips.count == 0) && (pits[9].chips.count == 0) && (pits[10].chips.count == 0) && (pits[11].chips.count == 0) && (pits[12].chips.count == 0)) {
            for v in 0..<6 {
                for z in 0..<pits[v].chips.count {
                    let chip = pits[v].chips[z]
                    let parent = chip.parent as! Pit
                    moveChip(currentChip: chip, chipParent: parent, pitAfterClick: pits[6], targetPoint: pits[6].position)
                    adjustScore2(by: 1)
                }
                    
            }
            
            checkScore()
            
        }
    }
    
    func moveChip(currentChip: Chip, chipParent: Pit, pitAfterClick: Pit, targetPoint: CGPoint) {
        
        let ogChipPosition = chipParent.position
        let ogChipScale = chipParent.xScale

        let addChildAction = SKAction.run {
            chipParent.removeAllChildren()
            chipParent.chips.removeAll()
            self.gameBoard.addChild(currentChip)
            currentChip.position = ogChipPosition
            currentChip.setScale(ogChipScale)
        }
        
        let addChipToPit = SKAction.run {
            currentChip.removeFromParent()
            
            pitAfterClick.addChild(currentChip)
            
            pitAfterClick.chips.append(currentChip)
            currentChip.setScale(1)
            currentChip.position = CGPoint.zero
        }
        
        let changeChipPosition = SKAction.run {
            let randomX = (CGFloat.random(in: -35...35))
            let randomY = (CGFloat.random(in: -35...35))
            
            currentChip.run(SKAction.moveBy(x: randomX, y: randomY, duration: 0.2))
            
        }
        
        
        
//        let checkForStrays = SKAction.run {
//            if pitAcrossLastChipPit.chips.count != 0  {
//                let moveAction2 = SKAction.move(to: targetPoint, duration: 0.5)
//
//                let sequence2 = SKAction.sequence([addChildAction, moveAction2, addChipToPit, changeChipPosition, SKAction.scale(to: 0.81, duration: 1)])
//                currentChip.run(sequence2)
//            }
//        }
        
        let moveAction = SKAction.move(to: targetPoint, duration: 0.5)
        
        let sequence = SKAction.sequence([addChildAction, moveAction, addChipToPit, changeChipPosition, SKAction.scale(to: 0.81, duration: 1)])
        currentChip.run(sequence)
        
    }
    
    func playerActions(_ currentPit: Pit) {
        if currentPlayer == 1 {
            if currentPit == pits[0] {
            } else if currentPit == pits[1] {
            } else if currentPit == pits[2] {
            } else if currentPit == pits[3] {
            } else if currentPit == pits[4] {
            } else if currentPit == pits[5] {
            } else {
                if currentPit == pits[6] {
                } else if currentPit == pits[13] {
                } else {
                    for i in 0..<14 {
                        if currentPit == pits[i] {
                            
                            var y = 1
                            
                            for z in 0..<currentPit.chips.count {
                                
                                
                                var pitAfterClick = Pit()
                                
                                if (i+(z+y)) > 26 {
                                    pitAfterClick = pits[(i+(z+y)) - 27]
                                } else if (i+(z+y)) > 13 {
                                    pitAfterClick = pits[(i+(z+y)) - 14]
                                } else {
                                    pitAfterClick = pits[i+(z+y)]
                                }
                                
                                if pitAfterClick == pits[13] {
                                    adjustScore1(by: 1)
                                } else if pitAfterClick == pits[6] {
                                    pitAfterClick = pits[7]
                                    y += 1
                                }
                                
                                let currentChip = pits[i].chips[z]
                                let chipParent = currentChip.parent as! Pit
                                let targetPoint = pitAfterClick.position
                                
                                var pitAcrossLastChipPit = Pit()
                               
                                if (i+(z+y)) > 26 {
                                   pitAcrossLastChipPit = pitsAcross[(i+(z+y)) - 27]
                                } else if (i+(z+y)) > 13 {
                                   pitAcrossLastChipPit = pitsAcross[(i+(z+y)) - 14]
                                } else {
                                   pitAcrossLastChipPit = pitsAcross[i+(z+y)]
                                }
                                
                                if (pitAfterClick == pits[7] || pitAfterClick == pits[8] || pitAfterClick == pits[9] || pitAfterClick == pits[10] || pitAfterClick == pits[11] || pitAfterClick == pits[12]) && ((z == (currentPit.chips.count - 1)) && (pitAfterClick.chips.count == 0) && (pitAcrossLastChipPit.chips.count >= 1)) {

                                    
                                    adjustScore1(by: 1)
                                    moveChip(currentChip: currentChip, chipParent: chipParent, pitAfterClick: pits[13], targetPoint: pits[13].position)
                                    bonusLabel.run(bonusLabelSequence(text: "Player 1 Stole Chips"))
                                    
                                    for x in 0..<pitAcrossLastChipPit.chips.count {
                                        let currentChip2 = pitAcrossLastChipPit.chips[x]
                                        
                                        let chipParent2 = currentChip2.parent as! Pit
                                        adjustScore1(by: 1)
                                        
                                        moveChip(currentChip: currentChip2, chipParent: chipParent2, pitAfterClick: pits[13], targetPoint: pits[13].position)
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                } else {
                                    moveChip(currentChip: currentChip, chipParent: chipParent, pitAfterClick: pitAfterClick, targetPoint: targetPoint)
                                }
                                
                                if (pitAfterClick == pits[13]) && z == (currentPit.chips.count - 1) {
                                    switchPlayer()
                                    bonusLabel.run(bonusLabelSequence(text: "Player 1 Goes Again"))
                                }
                                
                                
                                
                            }

                        }
                    }
                
                    switchPlayer()
                }
            }
        }
        if currentPlayer == 2 {
            if currentPit == pits[7] {
            } else if currentPit == pits[8] {
            } else if currentPit == pits[9] {
            } else if currentPit == pits[10] {
            } else if currentPit == pits[11] {
            } else if currentPit == pits[12] {
            } else {
                if currentPit == pits[6] {
                } else if currentPit == pits[13] {
                } else {
                    
                    for i in 0..<14 {
                        if currentPit == pits[i] {
                            
                            var y = 1
 
                            for z in 0..<currentPit.chips.count {
                                
                                
                                var pitAfterClick = Pit()
                                
                                
                                
                                if (i+(z+y)) > 26 {
                                    pitAfterClick = pits[(i+(z+y)) - 27]
                                } else if (i+(z+y)) > 13 {
                                    pitAfterClick = pits[(i+(z+y)) - 14]
                                } else {
                                    pitAfterClick = pits[i+(z+y)]
                                }
                                
                                if pitAfterClick == pits[6] {
                                    adjustScore2(by: 1)
                                } else if pitAfterClick == pits[13] {
                                    pitAfterClick = pits[0]
                                    y += 1
                                }
                                    
                                let currentChip = pits[i].chips[z]
                                let chipParent = currentChip.parent as! Pit
                                let targetPoint = pitAfterClick.position
                                
                                var pitAcrossLastChipPit = Pit()
                                
                                if (i+(z+y)) > 26 {
                                    pitAcrossLastChipPit = pitsAcross[(i+(z+y)) - 27]
                                } else if (i+(z+y)) > 13 {
                                    pitAcrossLastChipPit = pitsAcross[(i+(z+y)) - 14]
                                } else {
                                    pitAcrossLastChipPit = pitsAcross[i+(z+y)]
                                }
                                
                                if (pitAfterClick == pits[0] || pitAfterClick == pits[1] || pitAfterClick == pits[2] || pitAfterClick == pits[3] || pitAfterClick == pits[4] || pitAfterClick == pits[5]) && ((z == (currentPit.chips.count - 1)) && (pitAfterClick.chips.count == 0) && (pitAcrossLastChipPit.chips.count >= 1)) {
                                    
                                    adjustScore2(by: 1)
                                    moveChip(currentChip: currentChip, chipParent: chipParent, pitAfterClick: pits[6], targetPoint: pits[6].position)
                                    bonusLabel.run(bonusLabelSequence(text: "Player 2 Stole Chips"))
                                    
                                    
                                    for x in 0..<pitAcrossLastChipPit.chips.count {
                                        let currentChip2 = pitAcrossLastChipPit.chips[x]
                                        
                                        let chipParent2 = pitAcrossLastChipPit
                                        adjustScore2(by: 1)
                                        
                                        moveChip(currentChip: currentChip2, chipParent: chipParent2, pitAfterClick: pits[6], targetPoint: pits[6].position)
                                        
                                    }
                                    
                                }  else {
                                    moveChip(currentChip: currentChip, chipParent: chipParent, pitAfterClick: pitAfterClick, targetPoint: targetPoint)
                                }
                                
                                
                                
                                if (pitAfterClick == pits[6]) && z == (currentPit.chips.count - 1) {
                                    switchPlayer()
                                    bonusLabel.run(bonusLabelSequence(text: "Player 2 Goes Again"))
                                    
                                }
                            

                            
                            
                            }
                            
                            
                            
                        }
                    }
                    
                    switchPlayer()
                    
                }
            }
        }
        
    }
    
    func switchPlayer() {
        if currentPlayer == 1 {
            currentPlayer = 2
            playerOutline.run(SKAction.move(to: CGPoint(x: 574.52, y: -291), duration: 0.3))
        } else if currentPlayer == 2 {
            currentPlayer = 1
            playerOutline.run(SKAction.move(to: CGPoint(x: -688.166, y: 274.518), duration: 0.3))
        }
        
    }
    
    func setUpGameBoard() {
        gameBoard = childNode(withName: "gameBoard")!
        
        for i in 0..<14 {
            
            pits[i] = (childNode(withName: "gameBoard")?.childNode(withName: "pit\(i)"))! as! Pit
            
            pits[i].chips = pits[i].children as! [Chip]

        }
        bonusLabel = childNode(withName: "bonus") as! SKLabelNode
        bonusLabel.run(SKAction.fadeOut(withDuration: 0))
        playerOutline = childNode(withName: "playerOutline") as! SKShapeNode
        resetButton = childNode(withName: "reset") as! SKSpriteNode
        
        pitsAcross[0] = pits[12]
        pitsAcross[1] = pits[11]
        pitsAcross[2] = pits[10]
        pitsAcross[3] = pits[9]
        pitsAcross[4] = pits[8]
        pitsAcross[5] = pits[7]
        pitsAcross[6] = pits[13]
        pitsAcross[7] = pits[5]
        pitsAcross[8] = pits[4]
        pitsAcross[9] = pits[3]
        pitsAcross[10] = pits[2]
        pitsAcross[11] = pits[1]
        pitsAcross[12] = pits[0]
        pitsAcross[13] = pits[6]
        
    }
    
}
