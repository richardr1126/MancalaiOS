//
//  GameViewController.swift
//  MancalaGame
//
//  Created by Richard Roberson on 11/12/19.
//  Copyright © 2019 Richard Roberson. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

var masterView = GameViewController()




class GameViewController: UIViewController {

    var isOver: Bool? {
        didSet {
            if isOver == true {
                
                
                
                
                if let scene = GKScene(fileNamed: "GameScene") {
                    
                    // Get the SKScene from the loaded GKScene
                    if let sceneNode = scene.rootNode as! GameScene? {
                        
                        isOver = false
                        sceneNode.scaleMode = .aspectFill
                        
                        if let view = self.view as! SKView? {
                            view.presentScene(sceneNode)
                            view.showsFPS = true
                            view.showsNodeCount = true
                            view.backgroundColor = .white
                        }
                        
                    }
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        masterView = self
        
    
        
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                isOver = false
                sceneNode.scaleMode = .aspectFill
                
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    view.showsFPS = true
                    view.showsNodeCount = true
                    view.backgroundColor = .white
                }
                
            }
        }
    }
    
    


    override var prefersStatusBarHidden: Bool {
        return true
    }
}
