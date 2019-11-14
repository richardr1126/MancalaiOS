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

    override func sceneDidLoad() {
        setUpGameBoard()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: gameBoard)
            
            let currentPit: Pit = ((gameBoard.atPoint(touchLocation).parent?.parent) ?? pits[0]) as! Pit
            print(currentPit)
            
            for i in 0..<14 {
                if currentPit == pits[i] {
                   
                    let move1 = SKAction.move(to: pits[i+1].position, duration: 0.5)
                    let move2 = SKAction.move(to: pits[i+2].position, duration: 0.5)
                    let move3 = SKAction.move(to: pits[i+3].position, duration: 0.5)
                    let move4 = SKAction.move(to: pits[i+4].position, duration: 0.5)
                    
                    let waitAction = SKAction.wait(forDuration: 0.1)
                    
                    let moveSequence = SKAction.sequence([move1, waitAction, move2, waitAction, move3, waitAction, move4])
                    
                    currentPit.chipsNode.run(moveSequence)
                }
            }
            
        }
    }
    
    func setUpGameBoard() {
        gameBoard = childNode(withName: "gameBoard")!
        
        for i in 0..<14 {
            pits[i] = (childNode(withName: "gameBoard")?.childNode(withName: "pit\(i)"))! as! Pit
            pits[i].chipsNode = pits[i].childNode(withName: "chips")!
            pits[i].chips = pits[i].childNode(withName: "chips")?.children as! [Chip]
            
        }
        print(pits)
    }
    
}
