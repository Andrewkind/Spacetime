//
//  GameScene.swift
//  Spacetime
//
//  Created by Andrew Kind on 2015-12-21.
//  Copyright (c) 2015 Andrew Kind. All rights reserved.
//

import SpriteKit

//MARK: - Enums


enum rotationDirection{
    case clockwise
    case counterClockwise
    case none
}

enum BodyType:UInt32 {
    case ship = 1
    case enemy = 2
    case planet = 4
}

//MARK: - Delegate Protocols

@objc protocol LocationDelegate {
    func LocationDelegateFunc(Location : CGPoint)
}

@objc protocol SetTargetDelegate{
    func SetTarget(Target : String)
    func SetCoordinates(Coordinates : CGPoint)
    
}



class GameScene: SKScene, SKPhysicsContactDelegate, SetTargetDelegate {
    
    //MARK: - Data
    let locationLabel = SKLabelNode(fontNamed: "Ariel")
    let targetLabel = SKLabelNode(fontNamed: "Ariel")
    let selectLabel = SKLabelNode(fontNamed: "Ariel")
    let travelLabel = SKLabelNode(fontNamed: "Ariel")
    
    var target : SKNode?
    var targetName = "enemy"
    
    var locationDelegate : LocationDelegate?
    var setTargetDelegate : SetTargetDelegate?
    
    var ship : Ship?
    var shipAngle : CGFloat = -90
    var shipInAction = false
    
    var targetingBox : SKShapeNode?
    var targetingLine : SKShapeNode?
    var coordinatesNode : SKNode?
    var coordinatesPoint : SKNode?
    
    var enemy : SKSpriteNode = SKSpriteNode()
    
    var worldNode : SKNode = SKNode()
    
    var planet : SKSpriteNode?
    
    var stars : [SKShapeNode] = [SKShapeNode]()
    
    
    let thrust : CGFloat = 120.2;
    let shipDirection : CGFloat = 90
    var thrustVector : CGVector?
    var firstLoad = true
    
    var popoverView : SKView?
    
    //MARK: - Functions
    
    override func didMoveToView(view: SKView) {
        
        if (firstLoad == true) {
            
            firstLoad = false
            doFirstLoad()
        }
    }
    
    func doFirstLoad() {
     
        scene?.backgroundColor = UIColor.blackColor()
        self.addChild(worldNode)
        
        /* Setup your scene here */
        
        // Create BG
        let background = SKSpriteNode(imageNamed: "spaceBG")
        background.position = CGPointMake(0, 0)
        background.xScale = 1
        background.yScale = 1
        background.zPosition = 0
        worldNode.addChild(background)
        
        physicsWorld.contactDelegate = self
        
        // Select Label
        selectLabel.text = "Select"
        selectLabel.fontColor = SKColor.greenColor()
        selectLabel.position = CGPointMake(self.frame.width, self.frame.height - 100)
        selectLabel.fontSize = 20
        selectLabel.name = "StartGameLabel"
        selectLabel.horizontalAlignmentMode = .Right
        selectLabel.zPosition = 1
        selectLabel.name = "SelectLabel"
        self.addChild(selectLabel)
        
        
        // Travel Label
        travelLabel.text = "Travel"
        travelLabel.fontColor = SKColor.whiteColor()
        travelLabel.position = CGPointMake(self.frame.width, 100)
        travelLabel.fontSize = 20
        travelLabel.name = "TravelLabel"
        travelLabel.horizontalAlignmentMode = .Right
        travelLabel.zPosition = 1
        travelLabel.name = "TravelLabel"
        self.addChild(travelLabel)
        
        // Location Label
        locationLabel.text = "Location: ";
        locationLabel.fontSize = 20
        locationLabel.fontColor = UIColor.whiteColor()
        locationLabel.horizontalAlignmentMode = .Left
        //myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        locationLabel.position = CGPointMake(50, 0)
        locationLabel.zPosition = 1
        self.addChild(locationLabel)
        
        // Target Label
        targetLabel.text = "Target: ";
        targetLabel.fontSize = 20
        targetLabel.fontColor = UIColor.whiteColor()
        targetLabel.horizontalAlignmentMode = .Left
        //myLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        targetLabel.position = CGPointMake(50, 15)
        targetLabel.zPosition = 1
        self.addChild(targetLabel)
        
        // Gravity
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        
        self.scaleMode = SKSceneScaleMode.AspectFit
        
        // Ship Construct
        ship = Ship(imageNamed: "Spaceship")
        ship!.physicsBody = SKPhysicsBody(texture: ship!.texture!, size: ship!.texture!.size())
        ship?.xScale = 0.1
        ship?.yScale = 0.1
        ship?.position = (CGPointMake(self.frame.midX, self.frame.midY))
        ship?.physicsBody?.dynamic = false
        ship?.physicsBody?.affectedByGravity = false
        ship?.physicsBody?.categoryBitMask = BodyType.ship.rawValue
        ship?.physicsBody?.collisionBitMask = BodyType.enemy.rawValue | BodyType.planet.rawValue
        ship?.physicsBody?.contactTestBitMask = BodyType.enemy.rawValue | BodyType.planet.rawValue
        ship?.physicsBody?.dynamic = true
        ship?.name = "ship"
        ship?.zPosition = 1
        
        // Planet
        planet = SKSpriteNode(imageNamed: "Planet")
        planet?.physicsBody = SKPhysicsBody(texture: planet!.texture!, size: planet!.texture!.size())
        planet?.xScale = 0.1
        planet?.yScale = 0.1
        planet?.position = (CGPointMake(self.frame.midX - 350, self.frame.midY + 100))
        planet?.physicsBody?.categoryBitMask = BodyType.planet.rawValue
        planet?.physicsBody?.contactTestBitMask = BodyType.ship.rawValue
        planet?.physicsBody?.collisionBitMask = BodyType.ship.rawValue
        planet?.physicsBody?.dynamic = false
        planet?.physicsBody?.affectedByGravity = false
        planet?.name = "planet"
        planet?.zPosition = 1
        
        // Enemy
        enemy = SKSpriteNode(imageNamed: "Spaceship")
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.texture!.size())
        enemy.xScale = 0.1
        enemy.yScale = 0.1
        enemy.position = (CGPointMake(self.frame.midX + 100, self.frame.midY + 100))
        enemy.physicsBody?.categoryBitMask = BodyType.enemy.rawValue
        enemy.physicsBody?.contactTestBitMask = BodyType.ship.rawValue
        enemy.physicsBody?.collisionBitMask = BodyType.ship.rawValue
        enemy.physicsBody?.dynamic = true
        enemy.physicsBody?.affectedByGravity = false
        enemy.name = "enemy"
        enemy.zPosition = 1
        
        worldNode.addChild(planet!)
        worldNode.addChild(enemy)
        worldNode.addChild(ship!)
        
        coordinatesNode = SKNode()
        coordinatesNode?.position = CGPointMake(5000 , 5000)
        worldNode.addChild(coordinatesNode!)
        target = coordinatesNode
        
        targetName = "Coordinates"
    }
    
    
    // UpdateStars() - Disabled
    func updateStars() {
        
        /*
        var maxStars = 100
        var minStars = 90
        var startY = 0
        var starVelocity = 5
        */
        
        let random = Int(arc4random_uniform(100))
        if (random > 99) {
            
            // Create a Star
            let starX = Int(arc4random_uniform(UInt32(self.frame.width)))
            let star = SKShapeNode(rect: CGRectMake(0, 0, 6, 6))
            star.position = CGPointMake(CGFloat(starX), self.frame.height)
            star.strokeColor = UIColor.whiteColor()
            star.fillColor = UIColor.whiteColor()
            star.lineWidth = 2
            stars.append(star)
            self.addChild(star)
            // print("Star 0 X is: \(stars[0].position.x) Star 0 Y is: \(stars[0].position.y)")
            
            for star in stars {
                star.position.y -= 1
                if (star.position.y < 0) {
                    //star.removeFromParent()
                }
            }
            
        }
    }
    
    override func didSimulatePhysics() {
        
        worldNode.position = CGPointMake(-(ship!.position.x-(self.size.width/2)), -(ship!.position.y-(self.size.height/2)))
        if (ship != nil) {
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            
            if (ship?.hasActions() == false) {
                
                // Get the position that was touched (a.k.a. ending point).
                let touchPosition = touch.locationInNode(self)
                let positionInScene = touch.locationInNode(self)
                let touchedNode = self.nodeAtPoint(positionInScene)
                
                //let worldTouchPosition = touch.locationInNode(worldNode)
                let worldPositionInScene = touch.locationInNode(worldNode)
                let worldTouchedNode = self.nodeAtPoint(worldPositionInScene)
                
                if let name = touchedNode.name
                {
                    if name == "SelectLabel"
                    {
                        playSound("beep2")
                        selectTapped()
                        return
                    }
                    else if name == "TravelLabel" {
                        playSound("beep2")
                        travelTapped()
                        return
                    }
                    else if name == "enemy" {
                        playSound("beep")
                        targetingLine?.removeFromParent()
                        targetingBox?.removeFromParent()
                        print("touched enemy")
                        
                        target = worldTouchedNode as? SKSpriteNode
                        target?.name = "enemy"
                        targetName = "enemy"
                        
                        let targetingRect = CGRectMake(-(target!.frame.width / target!.xScale) / 2, -(target!.frame.height / target!.yScale) / 2, target!.frame.width / target!.xScale, target!.frame.height / target!.yScale)
                        targetingBox = SKShapeNode(rect: targetingRect)
                        targetingBox!.lineWidth = 5
                        targetingBox!.strokeColor = UIColor.greenColor()
                        targetingBox?.zPosition = 1
                        target?.addChild(targetingBox!)
                        
                        let pathToDraw:CGMutablePathRef = CGPathCreateMutable()
                        targetingLine = SKShapeNode(path:pathToDraw)
                        
                        CGPathMoveToPoint(pathToDraw, nil, ship!.position.x, ship!.position.y)
                        CGPathAddLineToPoint(pathToDraw, nil, target!.position.x, target!.position.y)
                        
                        targetingLine!.path = pathToDraw
                        targetingLine!.strokeColor = SKColor.redColor()
                        targetingLine?.zPosition = 1
                        worldNode.addChild(targetingLine!)
                        
                        rotateTo(target!)
                        return
                    }
                    else if name == "planet" {
                        playSound("beep")
                        
                        targetingLine?.removeFromParent()
                        targetingBox?.removeFromParent()
                        
                        target = worldTouchedNode as? SKSpriteNode
                        target?.name = "planet"
                        targetName = "planet"
                        
                        let targetingRect = CGRectMake(-(target!.frame.width / target!.xScale) / 2, -(target!.frame.height / target!.yScale) / 2, target!.frame.width / target!.xScale, target!.frame.height / target!.yScale)
                        targetingBox = SKShapeNode(rect: targetingRect)
                        targetingBox!.lineWidth = 5
                        targetingBox!.strokeColor = UIColor.greenColor()
                        targetingBox?.zPosition = 1
                        target?.addChild(targetingBox!)
                        
                        let pathToDraw:CGMutablePathRef = CGPathCreateMutable()
                        targetingLine = SKShapeNode(path:pathToDraw)
                        
                        CGPathMoveToPoint(pathToDraw, nil, ship!.position.x, ship!.position.y)
                        CGPathAddLineToPoint(pathToDraw, nil, target!.position.x, target!.position.y)
                        
                        targetingLine!.path = pathToDraw
                        targetingLine!.strokeColor = SKColor.redColor()
                        targetingLine?.zPosition = 1
                        worldNode.addChild(targetingLine!)
                        
                        rotateTo(target!)
                        return
                        
                    }
                }
                
                // * No Specific Target touched
                else {
                    // Calculate the angle using the relative positions of the sprite and touch.
                    let angle = atan2(ship!.position.y - touchPosition.y, ship!.position.x - touchPosition.x)
                    
                    // Define actions for the ship to take.
                    let angleDegrees = angle * 180 / CGFloat(M_PI)
                    
                    shipAngle = angleDegrees
                    //let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.5,)
                    let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.5, shortestUnitArc: true)
                    let moveAction = SKAction.moveTo(touchPosition, duration: 0.5)
                    
                    // Tell the ship to execute actions.
                    //ship!.runAction(SKAction.sequence([rotateAction, moveAction]))
                    ship!.runAction(SKAction.sequence([rotateAction, moveAction]))
                    ship?.runAction(SKAction.sequence([rotateAction, moveAction]), withKey: "rotateMove")
                
                }
            }
        }
    }
    
    func travelTapped() {
        
        /*
        print("in Travel Tapped function")
        print(target?.name)
        if let myTarget = target {
            
            rotateTo(myTarget)
            let distance = distanceBetweenPoints(ship!.position, second: myTarget.position)
            moveToNode(myTarget, distance: Float(distance))
        }
        else if let myCoords = coordinatesNode {
            rotateTo(myCoords)
            let distance = distanceBetweenPoints(ship!.position, second: myCoords.position)
            moveToNode(myCoords as! SKSpriteNode, distance: Float(distance))
        }

        
        skViewPopUp=nil;
        scenePopUpReward=nil;
        NSLog(@"test4 successfully fired");
        CGFloat fltHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat fltWidth = [UIScreen mainScreen].bounds.size.width;
        CGRect rectPopUpReward = CGRectMake(0, 0, fltWidth/2, fltHeight/2);
        skViewPopUp = [[SKView alloc] initWithFrame:rectPopUpReward];
        [self.view addSubview:skViewPopUp];
        skViewPopUp.allowsTransparency = YES;
        scenePopUpReward = [[LTSceneStoreMain alloc] initWithSize:CGSizeMake(fltWidth/2, fltHeight/2)];
        scenePopUpReward.backgroundColor = [UIColor clearColor];
        [skViewPopUp presentScene:scenePopUpReward];
*/
        
        popoverView = nil
        let heightFloat = UIScreen.mainScreen().bounds.size.height
        let widthFloat = UIScreen.mainScreen().bounds.size.width
        let rect = CGRectMake(0, 0, widthFloat/2, heightFloat/2)
        popoverView = SKView(frame: rect)
        popoverView?.backgroundColor = UIColor.redColor()
        self.view?.addSubview(popoverView!)
        popoverView?.allowsTransparency = true

        
        
        
    }
    
    func playSound(soundName : String) {
        
        
        let sound : SKAction = SKAction.playSoundFileNamed("\(soundName).mp3", waitForCompletion: false)
        self.runAction(sound)
        
    }
    
    func applyThrust() {
        //physicsBody!.applyTorque(40)
        
        var dx = Float(ship!.zRotation)
        dx = cosf(dx)
        var dy  = Float(ship!.zRotation)
        dy = sinf(dy)
        
        
        
        //let thrustVector : CGVector = CGVectorMake((thrust * cosf(0)), (thrust * sinf(0)))
        thrustVector = CGVectorMake(CGFloat(dx) * thrust, CGFloat(dy) * thrust)
        
        ship?.physicsBody?.velocity = thrustVector!
        print("applying thrust!")
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //star1?.position.y -= 1
        // updateStars()
        //loca(ship!.position.x) , \(ship!.position.y)")
        
        locationLabel.text = "Location: x:\(roundMe(ship!.position.x)), y:\(roundMe(ship!.position.y))"
        targetLabel.text = target?.name
        
        //planet!.physicsBody!.velocity = CGVectorMake(0, 0);
        
        let pathToDraw:CGMutablePathRef = CGPathCreateMutable()
        
        if (targetingLine != nil) {
            targetingLine?.removeFromParent()
            CGPathMoveToPoint(pathToDraw, nil, ship!.position.x, ship!.position.y)
            CGPathAddLineToPoint(pathToDraw, nil, target!.position.x, target!.position.y)
            
            targetingLine!.path = pathToDraw
            targetingLine!.strokeColor = SKColor.redColor()
            targetingLine?.zPosition = 1
            worldNode.addChild(targetingLine!)
        }
        // Check if target exists
        checkForTarget()
        
    }
    
    func roundMe(value : CGFloat) -> CGFloat {
        
        return CGFloat(round(10 * value)/10)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        print("contact made")
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch(contactMask) {
        case BodyType.ship.rawValue | BodyType.enemy.rawValue:
            print("contact made")
            
        default: return
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        
    }
    
    func rotateTo(target : SKNode) {
        
        // Calculate the angle using the relative positions of the sprite and touch.
        let angle = atan2(ship!.position.y - target.position.y, ship!.position.x - target.position.x)
        
        // Define actions for the ship to take.
        let angleDegrees = angle * 180 / CGFloat(M_PI)
        
        shipAngle = angleDegrees
        //let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.5,)
        let rotateAction = SKAction.rotateToAngle(angle + CGFloat(M_PI*0.5), duration: 0.5, shortestUnitArc: true)
        //let moveAction = SKAction.moveTo(target.position, duration: 0.5)
        
        // Tell the ship to execute actions.
        //ship!.runAction(SKAction.sequence([rotateAction, moveAction]))
        ship!.runAction(SKAction.sequence([rotateAction]))
    }
    
    
    func moveToNode(target : SKNode, distance : Float) {
        
        let speedMultiplier : Float = 50
        
        let moveAction = SKAction.moveTo(target.position, duration: Double(distance * speedMultiplier))
        
        ship!.runAction(SKAction.sequence([moveAction]))
        
    }
    
    
    
    
    func selectTapped() {
        
        //UIViewController *vc = self.view.window.rootViewController;
        //[vc performSegueWithIdentifier:@"id" sender:nil];
        self.view?.window?.rootViewController?.performSegueWithIdentifier("TableViewSegue", sender: nil)
        
    }
    
    func distanceBetweenPoints(first : CGPoint, second : CGPoint) -> CGFloat {
        
        let distanceFloat = hypotf(Float(second.x) - Float(first.x), Float(second.y) - Float(first.y))
        
        let distanceCGFloat : CGFloat = CGFloat(distanceFloat)
        return distanceCGFloat
    }
    
    override func didFinishUpdate() {
        
        if (worldNode.childNodeWithName(targetName) != nil) {
        target = worldNode.childNodeWithName(targetName) as! SKSpriteNode
        
        
            targetLabel.text = "Target: \(targetName) [\(roundMe(target!.position.x)),\(roundMe(target!.position.y))] Distance: \(roundMe(distanceBetweenPoints(ship!.position, second: target!.position)))"
    
        }
            
        else {
            
            targetLabel.text = "Target: None"
        }
    
    }
    
    func SetTarget(Target: String) {
        
        targetName = Target
        
        
    }
    
    func targetNode(Target : SKNode) {
        
        targetingBox?.removeFromParent()
        targetingLine?.removeFromParent()
        
        target = Target.copy() as? SKNode
        target?.name = Target.name
        
        
        let targetingRect = CGRectMake(-(target!.frame.width / target!.xScale) / 2, -(target!.frame.height / target!.yScale) / 2, target!.frame.width / target!.xScale, target!.frame.height / target!.yScale)
        targetingBox = SKShapeNode(rect: targetingRect)
        targetingBox!.lineWidth = 5
        targetingBox!.strokeColor = UIColor.greenColor()
        targetingBox?.zPosition = 1
        target?.addChild(targetingBox!)
        
        let pathToDraw:CGMutablePathRef = CGPathCreateMutable()
        targetingLine = SKShapeNode(path:pathToDraw)
        
        if let myShip = ship {
            CGPathMoveToPoint(pathToDraw, nil, myShip.position.x, myShip.position.y)
            CGPathAddLineToPoint(pathToDraw, nil, target!.position.x, target!.position.y)
            
            targetingLine!.path = pathToDraw
            targetingLine!.strokeColor = SKColor.redColor()
            targetingLine?.zPosition = 1
            worldNode.addChild(targetingLine!)
        }
    }
    
    func SetCoordinates(Coordinates: CGPoint) {
        
        coordinatesNode?.removeFromParent()
        coordinatesNode = SKNode()
        coordinatesNode?.position = Coordinates
        worldNode.addChild(coordinatesNode!)
        targetNode(coordinatesNode!)
        //target = nil
        //targetName = ""
        //print("Set coordinates to \(coordinatesNode!.position)")
    }
    
    func checkForTarget() {
        
    }
    
}
