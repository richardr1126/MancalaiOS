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
    var pitsAcross: Array<Pit> = Array(repeating: Pit(), count: 14)
    var score1 = 0
    var score2 = 0
    let label1 = SKLabelNode()
    let label2 = SKLabelNode()
    var playerOutline = SKShapeNode()
    var currentPlayer = 1
    var pitAcross0 = Pit()
    var pitAcross1 = Pit()
    var pitAcross2 = Pit()
    var pitAcross3 = Pit()
    var pitAcross4 = Pit()
    var pitAcross5 = Pit()
    var pitAcross7 = Pit()
    var pitAcross8 = Pit()
    var pitAcross9 = Pit()
    var pitAcross10 = Pit()
    var pitAcross11 = Pit()
    var pitAcross12 = Pit()
    
    
    

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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: gameBoard)
            
            if let currentPit = ((gameBoard.atPoint(touchLocation).parent) ?? pits[0]) as? Pit {
                
                playerActions(currentPit)
                
                
            }
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
            let randomX = (CGFloat.random(in: -30...30))
            let randomY = (CGFloat.random(in: -30...30))
            
            currentChip.run(SKAction.moveBy(x: randomX, y: randomY, duration: 0.2))
            
        }
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
                                    if currentPit.chips.count < 12 {
                                        pitAfterClick = pits[7]
                                        y += 1
                                    } else if currentPit.chips.count > 12 {
                                        pitAfterClick = pits[8]
                                        y += 2
                                    }
                                    
                                }
                                
                                let currentChip = pits[i].chips[z]
                                let chipParent = currentChip.parent as! Pit
                                let targetPoint = pitAfterClick.position
                                
                                moveChip(currentChip: currentChip, chipParent: chipParent, pitAfterClick: pitAfterClick, targetPoint: targetPoint)
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
                                    adjustScore2(by: 1  )
                                }
                                    
                                let currentChip = pits[i].chips[z]
                                let chipParent = currentChip.parent as! Pit
                                let targetPoint = pitAfterClick.position
                                
                                moveChip(currentChip: currentChip, chipParent: chipParent, pitAfterClick: pitAfterClick, targetPoint: targetPoint)
                                
                                if (pitAfterClick == pits[0] || pitAfterClick == pits[1] || pitAfterClick == pits[2] || pitAfterClick == pits[3] || pitAfterClick == pits[4] || pitAfterClick == pits[5]) && ((z == (currentPit.chips.count - 1)) && (pitAfterClick.chips.count == 0)) {
                                    

                                    var pitAcrossLastChipPit = Pit()
                                    
                                    if (i+(z+y)) > 26 {
                                        pitAcrossLastChipPit = pitsAcross[(i+(z+y)) - 27]
                                    } else if (i+(z+y)) > 13 {
                                        pitAcrossLastChipPit = pitsAcross[(i+(z+y)) - 14]
                                    } else {
                                        pitAcrossLastChipPit = pitsAcross[i+(z+y)]
                                    }
                                    
                                    for x in 0..<pitAcrossLastChipPit.chips.count {
                                        let currentChip2 = pitAcrossLastChipPit.chips[x]
                                        let ogChipPosition2 = pitAcrossLastChipPit.position
                                        let chipParent = pitAcrossLastChipPit
                                        adjustScore2(by: 1)
                                        
                                        let addChildAction2 = SKAction.run {
                                            pitAcrossLastChipPit.removeAllChildren()
                                            pitAcrossLastChipPit.chips.removeAll()
                                            self.gameBoard.addChild(currentChip2)
                                            currentChip2.position = ogChipPosition2
                                            currentChip2.setScale(0.238)
                                        }
                                        let addChipToEndzone = SKAction.run {
                                            currentChip2.removeFromParent()
                                            self.pits[6].addChild(currentChip2)
                                            self.pits[6].chips.append(currentChip2)
                                            currentChip2.setScale(1)
                                            currentChip2.position = CGPoint.zero
                                        }
                                        let changeChipPosition2 = SKAction.run {
                                            let randomX = (CGFloat.random(in: -30...30))
                                            let randomY = (CGFloat.random(in: -30...30))
                                            
                                            currentChip2.run(SKAction.moveBy(x: randomX, y: randomY, duration: 0.2))
                                            
                                        }
                                        let moveAction2 = SKAction.move(to: pits[6].position, duration: 0.5)
                                        
                                        let sequence2 = SKAction.sequence([addChildAction2, moveAction2, addChipToEndzone, changeChipPosition2, SKAction.scale(to: 0.81, duration: 1)])
                                        currentChip2.run(sequence2)
                                    }
                                    
                                    
                                    
                                    
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
        
        playerOutline = childNode(withName: "playerOutline") as! SKShapeNode
        
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
