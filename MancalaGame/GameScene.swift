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
    var gameBoard = SKNode()
    var pits: Array<Pit> = Array(repeating: Pit(), count: 14)
    var score1 = 0
    var score2 = 0
    let label1 = SKLabelNode()
    let label2 = SKLabelNode()
    var playerOutline = SKShapeNode()
    var currentPlayer = 1

    override func sceneDidLoad() {
        setUpGameBoard()
        
    }
    
    func adjustScore1() {
        score1 += 1
        label1.removeFromParent()
        label1.position = CGPoint(x: -735, y: -299)
        label1.zPosition = 0
        label1.fontSize = 70
        label1.text = "\(score1)"
        label1.fontName = "HelveticaNeue-Bold"
        label1.fontColor = .red
        self.addChild(label1)
    }
    
    func adjustScore2() {
        score2 += 1
        label2.removeFromParent()
        label2.position = CGPoint(x: 725, y: 250)
        label2.zPosition = 0
        label2.fontSize = 70
        label2.text = "\(score2)"
        label2.fontName = "HelveticaNeue-Bold"
        label2.fontColor = .red
        self.addChild(label2)
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: gameBoard)
            
            if let currentPit = ((gameBoard.atPoint(touchLocation).parent) ?? pits[0]) as? Pit {
                
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
                                            adjustScore1()
                                        } else if pitAfterClick == pits[6] {
                                            if currentPit.chips.count < 12 {
                                                pitAfterClick = pits[7]
                                                y += 1
                                            } else if currentPit.chips.count > 12 {
                                                pitAfterClick = pits[8]
                                                y += 2
                                            }
                                            
                                        }
                                        
                                        let currentChip = pits[i].chips[z]
                                        
                                        let ogChipPosition = currentPit.position
                                        let ogChipScale = currentPit.xScale
                                        
                                        var targetPoint = CGPoint()
                                        
                                        
                                        if (pitAfterClick == pits[7] || pitAfterClick == pits[8] || pitAfterClick == pits[9] || pitAfterClick == pits[10] || pitAfterClick == pits[11] || pitAfterClick == pits[12]) && ((z == (currentPit.chips.count - 1)) && (pitAfterClick.chips.count == 0)) {
                                            
                                            targetPoint = pits[6].position
                                            let currentChips = pits[i].chips
                                            
                                            
                                            var addChildActions = [SKAction()]
                                            var addChipToPitActions = [SKAction()]
                                            var changeChipPositionActions = [SKAction()]
                                            var sequences = [SKAction()]
                                            
                                            for x in 0..<currentChips.count {

                                                addChildActions.append(SKAction.run {
                                                    currentPit.removeAllChildren()
                                                    currentPit.chips.removeAll()
                                                    
                                                    self.gameBoard.addChild(currentChips[x])
                                                    currentChips[x].position = ogChipPosition
                                                    currentChips[x].setScale(ogChipScale)
                                                })
                                                
                                                addChipToPitActions.append(SKAction.run {
                                                    currentChips[x].removeFromParent()
                                                    
                                                    pitAfterClick.addChild(currentChip)
                                                    
                                                    pitAfterClick.chips.append(currentChip)
                                                    currentChips[x].setScale(1)
                                                    currentChips[x].position = CGPoint.zero
                                                })
                                                
                                                changeChipPositionActions.append(SKAction.run {
                                                    let randomX = (CGFloat.random(in: -30...30))
                                                    let randomY = (CGFloat.random(in: -30...30))
                                                    
                                                    currentChips[x].run(SKAction.moveBy(x: randomX, y: randomY, duration: 0.2))
                                                    
                                                })
                                                let moveAction = SKAction.move(to: targetPoint, duration: 0.5)
                                                sequences.append(SKAction.sequence([addChildActions[x], moveAction, addChipToPitActions[x], changeChipPositionActions[x], SKAction.scale(to: 0.81, duration: 1)]))
                                                
                                                currentChip.run(sequences[x])
                                            }

                                        } else {
                                            targetPoint = pitAfterClick.position
                                            let addChildAction = SKAction.run {
                                                currentPit.removeAllChildren()
                                                currentPit.chips.removeAll()
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
                                                let randomX = (CGFloat.random(in: -30...30))
                                                let randomY = (CGFloat.random(in: -30...30))
                                                
                                                currentChip.run(SKAction.moveBy(x: randomX, y: randomY, duration: 0.2))
                                                
                                            }
                                            let moveAction = SKAction.move(to: targetPoint, duration: 0.5)
                                            let sequence = SKAction.sequence([addChildAction, moveAction, addChipToPit, changeChipPosition, SKAction.scale(to: 0.81, duration: 1)])
                                            
                                            currentChip.run(sequence)
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
                                        
                                        if pitAfterClick == pits[13] {
                                            if currentPit.chips.count < 12 {
                                                pitAfterClick = pits[0]
                                                y += 1
                                            } else if currentPit.chips.count > 12 {
                                                pitAfterClick = pits[1]
                                                y += 2
                                            }
                                        } else if pitAfterClick == pits[6] {
                                            adjustScore2()
                                        }
                                            
                                        let currentChip = pits[i].chips[z]
                                        let ogChipPosition = currentPit.position
                                        let ogChipScale = currentPit.xScale
                                        
                                        
                                        
                                        let targetPoint = pitAfterClick.position
                                        
                                        let addChildAction = SKAction.run {
                                            currentPit.removeAllChildren()
                                            currentPit.chips.removeAll()
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
                                            let randomX = (CGFloat.random(in: -30...30))
                                            let randomY = (CGFloat.random(in: -30...30))
                                            
                                            currentChip.run(SKAction.moveBy(x: randomX, y: randomY, duration: 0.2))
                                            
                                        }
                                        let moveAction = SKAction.move(to: targetPoint, duration: 0.5)
                                        
                                        let sequence = SKAction.sequence([addChildAction, moveAction, addChipToPit, changeChipPosition, SKAction.scale(to: 0.81, duration: 1)])
                                        currentChip.run(sequence)
                                        
                                        if (pitAfterClick == pits[0] || pitAfterClick == pits[1] || pitAfterClick == pits[2] || pitAfterClick == pits[3] || pitAfterClick == pits[4] || pitAfterClick == pits[5]) && ((z == (currentPit.chips.count - 1)) && (pitAfterClick.chips.count == 0)) {
                                            let pitAcross = pits[i+6]
                                            let 
                                        }
                                        
                                        
                                        
                                    

                                    
                                    
                                    }
                                    
                                    
                                    
                                }
                            }
                            
                            switchPlayer()
                            
                        }
                    }
                }
            }
        }
    }
    
    func setUpGameBoard() {
        gameBoard = childNode(withName: "gameBoard")!
        
        for i in 0..<14 {
            pits[i] = (childNode(withName: "gameBoard")?.childNode(withName: "pit\(i)"))! as! Pit
            
            pits[i].chips = pits[i].children as! [Chip]
            
        }
        
        playerOutline = childNode(withName: "playerOutline") as! SKShapeNode
    }
    
}
