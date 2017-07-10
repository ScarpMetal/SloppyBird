//
//  GameScene.swift
//  SloppyBird
//
//  Created by iD Staff on 7/10/17.
//  Copyright © 2017 iD Tech. All rights reserved.
//

import SpriteKit
import GameplayKit

struct BodyType {
    static let None : UInt32 = 0
    static let Bird : UInt32 = 1
    static let TopPipe : UInt32 = 2
    static let BottomPipe : UInt32 = 3
}

struct GameState {
    static let None : UInt32 = 0
    static let TapToStart : UInt32 = 1
    static let Playing : UInt32 = 2
    static let GameOver : UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var gameState = GameState.TapToStart
    
    let background = SKSpriteNode(imageNamed: "background")
    
    var bird : SKSpriteNode = SKSpriteNode(imageNamed: "flappybird")
    let GAP_SIZE : CGFloat = 160
    let pipeWidth : CGFloat = 80
    let pipeHeight : CGFloat = 400
    
    override func didMove(to view: SKView) {
        
        background.size = CGSize(width: size.width, height: size.height)
        background.position = CGPoint(x: 0, y: 0)
        background.zPosition = -1
        
        addChild(background)
        
        bird.size = CGSize(width: 40, height: 32)
        bird.position = CGPoint(x: -size.width/5, y: 0)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: 18)
        bird.physicsBody?.categoryBitMask = BodyType.Bird
        bird.physicsBody?.contactTestBitMask = BodyType.TopPipe | BodyType.BottomPipe
        bird.physicsBody?.collisionBitMask = 0
        bird.physicsBody?.usesPreciseCollisionDetection = true
        bird.physicsBody?.mass = 1
        
        addChild(bird)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -13.81)
        physicsWorld.contactDelegate = self
        physicsWorld.speed = 0.0
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("didBegin")
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        switch bodyA.categoryBitMask {
        case BodyType.Bird:
            switch bodyB.categoryBitMask {
            case BodyType.TopPipe:
                if let birdNode = bodyA.node as? SKSpriteNode, let pipeNode = bodyB.node as? SKSpriteNode{
                    birdHitPipe(bird: birdNode, pipe: pipeNode)
                }
                break
            case BodyType.BottomPipe:
                break
            default:
                break
            }
            break
        case BodyType.TopPipe:
            switch bodyB.categoryBitMask {
            case BodyType.Bird:
                if let birdNode = bodyB.node as? SKSpriteNode, let pipeNode = bodyA.node as? SKSpriteNode{
                    birdHitPipe(bird: birdNode, pipe: pipeNode)
                }
                break
            case BodyType.BottomPipe:
                break
            default:
                break
            }
            break
        case BodyType.BottomPipe:
            switch bodyB.categoryBitMask {
            case BodyType.Bird:
                if let birdNode = bodyB.node as? SKSpriteNode, let pipeNode = bodyA.node as? SKSpriteNode{
                    birdHitPipe(bird: birdNode, pipe: pipeNode)
                }
                break
            case BodyType.TopPipe:
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    func birdHitPipe(bird: SKSpriteNode, pipe: SKSpriteNode){
        print("HIT")
        removeAllActions()
        for child in children{
            child.removeAllActions()
        }
        physicsWorld.speed = 0.0
    }
    
    func spawnPipes(){
        
        let gapYPosition : CGFloat = CGFloat(arc4random_uniform(UInt32(size.height/4))) - size.height/8
        
        let topPipe = SKSpriteNode(imageNamed: "pipeTop")
        topPipe.size = CGSize(width: pipeWidth, height: pipeHeight)
        topPipe.position.y = gapYPosition + GAP_SIZE/2 + (pipeHeight / 2)
        topPipe.position.x = size.width/2 + pipeWidth/2
        topPipe.physicsBody = SKPhysicsBody(rectangleOf: topPipe.size)
        topPipe.physicsBody?.categoryBitMask = BodyType.TopPipe
        topPipe.physicsBody?.contactTestBitMask = BodyType.Bird
        topPipe.physicsBody?.collisionBitMask = 0
        topPipe.physicsBody?.usesPreciseCollisionDetection = true
        topPipe.physicsBody?.affectedByGravity = false
        
        let bottomPipe = SKSpriteNode(imageNamed: "pipeBottom")
        bottomPipe.size = CGSize(width: pipeWidth, height: pipeHeight)
        bottomPipe.position.y = gapYPosition - GAP_SIZE/2 - (pipeHeight / 2)
        bottomPipe.position.x = size.width/2 + pipeWidth/2
        bottomPipe.physicsBody = SKPhysicsBody(rectangleOf: bottomPipe.size)
        bottomPipe.physicsBody?.categoryBitMask = BodyType.BottomPipe
        bottomPipe.physicsBody?.contactTestBitMask = BodyType.Bird
        bottomPipe.physicsBody?.collisionBitMask = 0
        bottomPipe.physicsBody?.usesPreciseCollisionDetection = true
        bottomPipe.physicsBody?.affectedByGravity = false
        
        addChild(topPipe)
        addChild(bottomPipe)
        
        let topPipeAction = SKAction.move(to: CGPoint(x: -size.width/2 - topPipe.size.width/2, y: topPipe.position.y), duration: 5.0)
        let bottomPipeAction = SKAction.move(to: CGPoint(x: -size.width/2 - bottomPipe.size.width/2, y: bottomPipe.position.y), duration: 5.0)
        
        topPipe.run(topPipeAction)
        bottomPipe.run(bottomPipeAction)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameState == GameState.TapToStart {
            physicsWorld.speed = 1.0
            gameState = GameState.Playing
            run(SKAction.repeatForever(SKAction.sequence([
                SKAction.run(spawnPipes),
                SKAction.wait(forDuration: 1.6)
                ]))
            )
        }
        if gameState == GameState.Playing {
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.run(SKAction.applyImpulse(CGVector(dx: 0, dy: 760), duration: 0.05))
        }

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
