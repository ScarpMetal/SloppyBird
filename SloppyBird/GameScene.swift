//
//  GameScene.swift
//  SloppyBird
//
//  Created by iD Staff on 7/10/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var bird : SKSpriteNode = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 40, height: 40))
    let GAP_SIZE : CGFloat = 200
    let pipeWidth : CGFloat = 80
    let pipeHeight : CGFloat = 400
    
    override func didMove(to view: SKView) {
        bird.position = CGPoint(x: -size.width/4, y: 200)
        
        bird.physicsBody = SKPhysicsBody(rectangleOf: bird.size)
        bird.physicsBody?.mass = 1
        
        addChild(bird)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -12.81)
        
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.run(spawnPipes),
            SKAction.wait(forDuration: 2.0)
            ]))
        )
        
    }
    
    func spawnPipes(){
        
        let gapYPosition : CGFloat = CGFloat(arc4random_uniform(UInt32(size.height/4))) - size.height/8
        let topPipe = SKSpriteNode(color: UIColor.green, size: CGSize(width: pipeWidth, height: pipeHeight))
        let bottomPipe = SKSpriteNode(color: UIColor.green, size: CGSize(width: pipeWidth, height: pipeHeight))
        
        topPipe.position.y = gapYPosition + GAP_SIZE/2 + (pipeHeight / 2)
        bottomPipe.position.y = gapYPosition - GAP_SIZE/2 - (pipeHeight / 2)
        
        topPipe.position.x = size.width/2 + pipeWidth/2
        bottomPipe.position.x = size.width/2 + pipeWidth/2
        
        addChild(topPipe)
        addChild(bottomPipe)
        
        let topPipeAction = SKAction.move(to: CGPoint(x: -size.width/2 - topPipe.size.width/2, y: topPipe.position.y), duration: 5.0)
        let bottomPipeAction = SKAction.move(to: CGPoint(x: -size.width/2 - bottomPipe.size.width/2, y: bottomPipe.position.y), duration: 5.0)
        
        topPipe.run(topPipeAction)
        bottomPipe.run(bottomPipeAction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        bird.run(SKAction.applyImpulse(CGVector(dx: 0, dy: 750), duration: 0.05))

    }

    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
