//
//  Popover.swift
//  Spacetime
//
//  Created by Andrew Kind on 2015-12-30.
//  Copyright © 2015 Andrew Kind. All rights reserved.
//

import SpriteKit

class Popover: UIViewController {

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            
            dismissViewControllerAnimated(true, completion: {})
        }
    }
}