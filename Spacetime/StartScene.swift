//
//  StartScene.swift
//  Spacetime
//
//  Created by Andrew Kind on 2015-12-23.
//  Copyright © 2015 Andrew Kind. All rights reserved.
//

import UIKit
import SpriteKit

class StartScene: SKScene {
    
    override func didMoveToView(view: SKView) {
        //
        let startGameLabel = SKLabelNode(text: "Start!")
        startGameLabel.position = CGPointMake(self.frame.midX, self.frame.midY)
        startGameLabel.fontSize = 120
        startGameLabel.fontColor = UIColor.blackColor()
        startGameLabel.name = "StartGameLabel"
        self.addChild(startGameLabel)
        //self.backgroundColor = UIColor.blueColor()
    }
    
    override func update(currentTime: NSTimeInterval) {
        //
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            let positionInScene = touch.locationInNode(self)
            let touchedNode = self.nodeAtPoint(positionInScene)
            
            if let name = touchedNode.name
            {
                if name == "StartGameLabel"
                {
                    beginGame()
                }
            }
            
        }
        
        
    }
    func beginGame() {
        
        if let scene = GameScene(fileNamed:"GameScene") {
            
            let transition = SKTransition.fadeWithDuration(1)
            // Configure the view.
            let skView = self.view! as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            // Space Graphics
            //scene.backgroundColor = UIColor.blackColor()
            
            skView.presentScene(scene, transition: transition)
            
        }
    }
}
