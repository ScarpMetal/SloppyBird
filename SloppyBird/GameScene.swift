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
    static let PointBar : UInt32 = 4
    static let BulletBill : UInt32 = 5
    static let Ground : UInt32 = 6
}

struct GameState {
    static let None : UInt32 = 0
    static let TapToStart : UInt32 = 1
    static let SpawningPipes : UInt32 = 2
    static let SpawningBulletBills : UInt32 = 3
    static let GameOver : UInt32 = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var gameState = GameState.TapToStart
    
    let background1 = SKSpriteNode(imageNamed: "background")
    let background2 = SKSpriteNode(imageNamed: "background")
    
    let ground1 = SKSpriteNode(imageNamed: "ground")
    let ground2 = SKSpriteNode(imageNamed: "ground")
    
    var bird : SKSpriteNode = SKSpriteNode(imageNamed: "flappybird")
    var scoreLabel : SKLabelNode = SKLabelNode(fontNamed: "04b_19")
    
    var pipeOne = SKSpriteNode(imageNamed: "pipeRight")
    var pipeTwo = SKSpriteNode(imageNamed: "pipeRight")
    var pipeThree = SKSpriteNode(imageNamed: "pipeRight")
    var pipeFour = SKSpriteNode(imageNamed: "pipeRight")
    var pipeSix = SKSpriteNode(imageNamed: "pipeRight")
    var pipeSeven = SKSpriteNode(imageNamed: "pipeRight")
    
    let GAP_SIZE : CGFloat = 190 // <-- Make this 160
    let vPipeWidth : CGFloat = 80
    let vPipeHeight : CGFloat = 400
    let hPipeWidth : CGFloat = 400
    let hPipeHeight : CGFloat = 80
    
    var score : Int = 0
    
    override func didMove(to view: SKView) {
        
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: 0, y: size.height/2 - 100)
        
        addChild(scoreLabel)
        
        background1.size = CGSize(width: size.width, height: size.height)
        background1.position = CGPoint(x: 0, y: 0)
        background1.zPosition = -5
        
        addChild(background1)
        
        background2.size = CGSize(width: size.width, height: size.height)
        background2.position = CGPoint(x: size.width, y: 0)
        background2.zPosition = -5
        
        addChild(background2)
        
        ground1.size = CGSize(width: size.width + 10, height: 112)
        ground1.position = CGPoint(x: 0, y: -size.height/2 + 30)
        ground1.zPosition = -1
        
        ground1.physicsBody = SKPhysicsBody(rectangleOf: ground1.size, center: CGPoint(x: 0, y:0))
        ground1.physicsBody?.categoryBitMask = BodyType.Ground
        ground1.physicsBody?.contactTestBitMask = BodyType.Bird
        ground1.physicsBody?.collisionBitMask = 0
        ground1.physicsBody?.affectedByGravity = false
        
        addChild(ground1)
        
        ground2.size = CGSize(width: size.width + 10, height: 112)
        ground2.position = CGPoint(x: size.width, y: -size.height/2 + 30)
        ground2.zPosition = -1
        
        ground2.physicsBody = SKPhysicsBody(rectangleOf: ground2.size, center: CGPoint(x: 0, y:0))
        ground2.physicsBody?.categoryBitMask = BodyType.Ground
        ground2.physicsBody?.contactTestBitMask = BodyType.Bird
        ground2.physicsBody?.collisionBitMask = 0
        ground2.physicsBody?.affectedByGravity = false
        
        addChild(ground2)
        
        bird.size = CGSize(width: 40, height: 32)
        bird.position = CGPoint(x: -size.width/5, y: 0)
        bird.zPosition = 5
        
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
                if let birdNode = bodyA.node as? SKSpriteNode, let pipeNode = bodyB.node as? SKSpriteNode{
                    birdHitPipe(bird: birdNode, pipe: pipeNode)
                }
                break
            case BodyType.PointBar:
                if let birdNode = bodyA.node as? SKSpriteNode, let pointBarNode = bodyB.node as? SKSpriteNode{
                    birdHitPointBar(bird: birdNode, pointBar: pointBarNode)
                }
                break
            case BodyType.BulletBill:
                if let birdNode = bodyA.node as? SKSpriteNode, let bulletNode = bodyB.node as? SKSpriteNode{
                    birdHitBulletBill(bird: birdNode, bullet: bulletNode)
                }
                break
            case BodyType.Ground:
                if let birdNode = bodyA.node as? SKSpriteNode, let groundNode = bodyB.node as? SKSpriteNode{
                    birdHitGround(bird: birdNode, ground: groundNode)
                }
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
            default:
                break
            }
            break
        case BodyType.PointBar:
            switch bodyB.categoryBitMask {
            case BodyType.Bird:
                if let birdNode = bodyB.node as? SKSpriteNode, let pointBarNode = bodyA.node as? SKSpriteNode{
                    birdHitPointBar(bird: birdNode, pointBar: pointBarNode)
                }
                break
            default:
                break
            }
            break
        case BodyType.BulletBill:
            switch bodyB.categoryBitMask{
            case BodyType.Bird:
                if let birdNode = bodyB.node as? SKSpriteNode, let bulletNode = bodyA.node as? SKSpriteNode{
                    birdHitBulletBill(bird: birdNode, bullet: bulletNode)
                }
                break
            default:
                break
            }
            break
        case BodyType.Ground:
            switch bodyB.categoryBitMask{
            case BodyType.Bird:
                if let birdNode = bodyB.node as? SKSpriteNode, let groundNode = bodyA.node as? SKSpriteNode{
                    birdHitGround(bird: birdNode, ground: groundNode)
                }
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    func birdHitPointBar(bird: SKSpriteNode, pointBar: SKSpriteNode){
        if score == 2{
            gameState = GameState.SpawningBulletBills
            removeAction(forKey: "SpawnPipes")
            startBulletBillSequence()
        }
        score += 1
        scoreLabel.text = "\(score)"
    }
    
    func birdHitPipe(bird: SKSpriteNode, pipe: SKSpriteNode){
        if gameState != GameState.GameOver{
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        removeAllActions()
        for child in children{
            child.removeAllActions()
        }
        gameState = GameState.GameOver
    }
    
    func birdHitBulletBill(bird: SKSpriteNode, bullet: SKSpriteNode){
        if gameState != GameState.GameOver{
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        removeAllActions()
        for child in children{
            child.removeAllActions()
        }
        gameState = GameState.GameOver
    }
    
    func birdHitGround(bird: SKSpriteNode, ground: SKSpriteNode){
        if gameState != GameState.GameOver{
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        removeAllActions()
        for child in children{
            child.removeAllActions()
        }
        gameState = GameState.GameOver
    }
    
    func spawnPipes(){
        
        let gapYPosition : CGFloat = CGFloat(arc4random_uniform(UInt32(size.height/4))) - size.height/8
        
        let topPipe = SKSpriteNode(imageNamed: "pipeTop")
        topPipe.size = CGSize(width: vPipeWidth, height: vPipeHeight)
        topPipe.position.y = gapYPosition + GAP_SIZE/2 + (vPipeHeight / 2)
        topPipe.position.x = size.width/2 + vPipeWidth/2
        topPipe.physicsBody = SKPhysicsBody(rectangleOf: topPipe.size)
        topPipe.physicsBody?.categoryBitMask = BodyType.TopPipe
        topPipe.physicsBody?.contactTestBitMask = BodyType.Bird
        topPipe.physicsBody?.collisionBitMask = 0
        topPipe.physicsBody?.usesPreciseCollisionDetection = true
        topPipe.physicsBody?.affectedByGravity = false
        
        let bottomPipe = SKSpriteNode(imageNamed: "pipeBottom")
        bottomPipe.size = CGSize(width: vPipeWidth, height: vPipeHeight)
        bottomPipe.position.y = gapYPosition - GAP_SIZE/2 - (vPipeHeight / 2)
        bottomPipe.position.x = size.width/2 + vPipeWidth/2
        bottomPipe.physicsBody = SKPhysicsBody(rectangleOf: bottomPipe.size)
        bottomPipe.physicsBody?.categoryBitMask = BodyType.BottomPipe
        bottomPipe.physicsBody?.contactTestBitMask = BodyType.Bird
        bottomPipe.physicsBody?.collisionBitMask = 0
        bottomPipe.physicsBody?.usesPreciseCollisionDetection = true
        bottomPipe.physicsBody?.affectedByGravity = false
    
        let pointBar = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 4, height: GAP_SIZE))
        pointBar.position = CGPoint(x: size.width/2 + vPipeWidth/2, y: gapYPosition)
        pointBar.alpha = 0.0
        pointBar.physicsBody = SKPhysicsBody(rectangleOf: pointBar.size)
        pointBar.physicsBody?.categoryBitMask = BodyType.PointBar
        pointBar.physicsBody?.contactTestBitMask = BodyType.Bird
        pointBar.physicsBody?.collisionBitMask = 0
        pointBar.physicsBody?.usesPreciseCollisionDetection = true
        pointBar.physicsBody?.affectedByGravity = false
        
        addChild(topPipe)
        addChild(bottomPipe)
        addChild(pointBar)
        
        let topPipeAction = SKAction.sequence([
            SKAction.move(to: CGPoint(x: -size.width/2 - vPipeWidth/2, y: topPipe.position.y), duration: 5.0),
            SKAction.removeFromParent()
        ])

        let bottomPipeAction = SKAction.sequence([
            SKAction.move(to: CGPoint(x: -size.width/2 - vPipeWidth/2, y: bottomPipe.position.y), duration: 5.0),
            SKAction.removeFromParent()
        ])

        let pointBarAction = SKAction.sequence([
            SKAction.move(to: CGPoint(x: -size.width/2 - vPipeWidth/2, y: gapYPosition), duration: 5.0),
            SKAction.removeFromParent()
        ])

        topPipe.run(topPipeAction)
        bottomPipe.run(bottomPipeAction)
        pointBar.run(pointBarAction)
    }
    
    func startBulletBillSequence(){
        
        pipeTwo.size = CGSize(width: 400, height: 80)
        pipeTwo.position = CGPoint(x: size.width + hPipeWidth/2, y: size.height/4)
        pipeTwo.zPosition = 5
        
        pipeFour.size = CGSize(width: 400, height: 80)
        pipeFour.position = CGPoint(x: size.width + hPipeWidth/2, y: 0)
        pipeFour.zPosition = 5
        
        pipeSix.size = CGSize(width: 400, height: 80)
        pipeSix.position = CGPoint(x: size.width + hPipeWidth/2, y: -size.height/4)
        pipeSix.zPosition = 5
        
        addChild(pipeTwo)
        addChild(pipeFour)
        addChild(pipeSix)
        
        let pipeTwoAction = SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.move(to: CGPoint(x: size.width/2 - 50, y: size.height/4 ) , duration: 1.0),
            SKAction.move(to: CGPoint(x: size.width/2 - 40, y: size.height/4 ) , duration: 0.2)
        ])
        
        let pipeFourAction = SKAction.sequence([
            SKAction.wait(forDuration: 3.2),
            SKAction.move(to: CGPoint(x: size.width/2 - 30, y: 0 ) , duration: 1.0),
            SKAction.move(to: CGPoint(x: size.width/2 - 20, y: 0 ) , duration: 0.2)
        ])
        
        let pipeSixAction = SKAction.sequence([
            SKAction.wait(forDuration: 3.4),
            SKAction.move(to: CGPoint(x: size.width/2 - 40, y: -size.height/4 ) , duration: 1.0),
            SKAction.move(to: CGPoint(x: size.width/2 - 30, y: -size.height/4 ) , duration: 0.2)
        ])
        
        pipeTwo.run(pipeTwoAction)
        pipeFour.run(pipeFourAction)
        pipeSix.run(pipeSixAction)
        
        run(SKAction.sequence([
                SKAction.wait(forDuration: 4.5),
                SKAction.repeatForever(SKAction.sequence([
                    SKAction.run(spawnBulletBill),
                    SKAction.wait(forDuration: 0.5)
                ]))
            ]) , withKey: "SpawnBulletBills")
    }
    
    func spawnBulletBill(){
        let randomNum = Int(arc4random_uniform(3))
        spawnBulletBill(cannonNum: randomNum)
    }
    
    func spawnBulletBill(cannonNum: Int){
        let bullet = SKSpriteNode(imageNamed: "bulletbill")
        bullet.size = CGSize(width: 60, height: 52)
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 28)
        bullet.physicsBody?.categoryBitMask = BodyType.BulletBill
        bullet.physicsBody?.contactTestBitMask = BodyType.Bird
        bullet.physicsBody?.collisionBitMask = 0
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.affectedByGravity = false
        
        let recoilAction = SKAction.sequence([
            SKAction.wait(forDuration: 0.4),
            SKAction.moveBy(x: 40, y: 0, duration: 0.2),
            SKAction.moveBy(x: -40, y: 0, duration: 0.4)
            ])
        
        let yPos : CGFloat
        switch cannonNum {
        case 0:
            pipeTwo.run(recoilAction)
            yPos = size.height / 4
        case 1:
            pipeFour.run(recoilAction)
            yPos = 0
        case 2:
            pipeSix.run(recoilAction)
            yPos = -size.height / 4
        default:
            yPos = 0
            break
        }
        bullet.position = CGPoint(x: size.width/2, y: yPos)
        
        addChild(bullet)
        
        let bulletAction = SKAction.sequence([
            SKAction.move(to: CGPoint(x: -size.width/2 - bullet.size.width/2, y: yPos), duration: 3.0),
            SKAction.removeFromParent()
            ])
        bullet.run(bulletAction)
    }
    
    
    /*
     * ======    =====
     *   ||      ||
     *   ||      |===
     *   ||      ||
     *   ||ouch  ||unctions
     */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameState == GameState.TapToStart {
            physicsWorld.speed = 1.0
            gameState = GameState.SpawningPipes
            
            run(SKAction.repeatForever(SKAction.sequence([
                    SKAction.run(spawnPipes),
                    SKAction.wait(forDuration: 1.6)
                ])
            ), withKey: "SpawnPipes")
        }
        if gameState == GameState.SpawningPipes || gameState == GameState.SpawningBulletBills {
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.run(SKAction.applyImpulse(CGVector(dx: 0, dy: 760), duration: 0.05))
        }
        if gameState == GameState.GameOver {
            if let scene = SKScene(fileNamed: "GameScene") {
                scene.size = self.size
                scene.scaleMode = .aspectFill
                view?.presentScene(scene)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameState == GameState.SpawningBulletBills || gameState == GameState.SpawningPipes {
            background1.position.x -= 1
            background2.position.x -= 1
            ground1.position.x -= 3.75
            ground2.position.x -= 3.75
        
            if background1.position.x <= -size.width {
                background1.position.x = size.width
            }
            if background2.position.x <= -size.width{
                background2.position.x = size.width
            }
        
            if ground1.position.x <= -size.width {
                ground1.position.x = size.width
            }
            if ground2.position.x <= -size.width{
                ground2.position.x = size.width
            }
        }
    }
}
