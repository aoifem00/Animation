//
//  GameScene.swift
//  Animation
//
//  Created by Aoife McManus on 10/8/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let ground=100
    
    weak var enemy:SKNode!
    weak var player:SKSpriteNode!
    weak var gameView:SKView!
    
    weak var didMoveTimer:Timer!
    weak var animalTimer:Timer!
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        gameView=view
        let playerSpriteTexture=SKTexture(imageNamed:"Image-4");
        let playerSprite=SKSpriteNode(texture:playerSpriteTexture)
        playerSprite.position=CGPoint(x: -50, y: 100);
        player=playerSprite
        self.addChild(player)
        
        let bearTexture=SKTexture(imageNamed:"Image")
        let bear = SKSpriteNode(texture:bearTexture)
        
        let coyoteTexture=SKTexture(imageNamed:"Image-1")
        let coyote = SKSpriteNode(texture:coyoteTexture)
        
        let deerTexture=SKTexture(imageNamed:"Image-2")
        let deer = SKSpriteNode(texture:deerTexture)
        
        let beaverTexture=SKTexture(imageNamed:"Image-3")
        let beaver = SKSpriteNode(texture:beaverTexture)
        
        let arr=[bear, coyote, deer, beaver]
        //getRandAnimal(arr: arr)
        var count=0
        didMoveTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { didMoveTimer in
            self.getRandAnimal(arr: arr)
            count+=1
        }
        if(count==1){
            didMoveTimer.invalidate()
        }
    }
    
    func gameOverScreen(){
        self.removeAllChildren()
        print("Game over!")
        let timer=Timer.scheduledTimer(withTimeInterval:1, repeats: false){ timer in
            self.didMove(to: self.gameView)
        }
    }
    
    func getRandAnimal(arr:[SKSpriteNode]){
        let animal=arr.randomElement()!
        let startX=self.frame.maxX;
        let endX=self.frame.minX;
        animal.position=CGPoint(x:startX, y:100)
        let action=SKAction.moveTo(x:endX, duration:1.5)
        //self.addChild(animal)
        if(animal.parent==nil){
            self.addChild(animal)
        }
        animal.run(action)
        enemy=animal
        var count=0
        animalTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true){ animalTimer in
            count+=1
            if(self.player.intersects(self.enemy)){
                animalTimer.invalidate()
                self.didMoveTimer.invalidate()
                self.gameOverScreen()
            }
            if(count==100){
                animalTimer.invalidate()
                animal.removeAllActions()
                animal.removeFromParent()
            }
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            //print("hello")
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    func buttonIsClicked(){
        var yPoint=self.player.position.y+300
        //let yPoint2=self.player.position.y
        var action=SKAction.moveTo(y:yPoint, duration:0.5)
        //let action2=SKAction.moveTo(y:yPoint2, duration:0.2)
        self.player.run(action)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false){ timer in
            action=SKAction.moveTo(y:CGFloat(self.ground), duration:0.5)
            self.player.run(action)
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var count1=0
        //var count2=99
        var pos=self.player.position
        for touch in touches {
            if((count1==touch.tapCount)==false){
               buttonIsClicked()
            }
            count1=touch.tapCount
        }
    }
    /*override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }*/
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
