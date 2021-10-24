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
    var inGame=true
    
    weak var enemy:SKNode!
    weak var player:SKSpriteNode!
    weak var gameView:SKView!
    
    weak var didMoveTimer:Timer!
    weak var animalTimer:Timer!
    weak var buttonIsClickedTimer:Timer!
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        self.inGame=true
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
        inGame=false
        self.removeAllChildren()
        print("Game over!")
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "Game over!"

        self.gameView.addSubview(label)
        let button=UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        button.center=CGPoint(x: 320, y: 285)
        button.setTitle("Play again", for: .normal)
        self.gameView.addSubview(button)
        
        
        let timer=Timer.scheduledTimer(withTimeInterval:5, repeats: false){ timer in
            self.didMove(to: self.gameView)
            label.removeFromSuperview()
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
        let yPoint=self.player.position.y+300
        //let yPoint2=self.player.position.y
        var action=SKAction.moveTo(y:yPoint, duration:0.5)
        //let action2=SKAction.moveTo(y:yPoint2, duration:0.2)
        self.player.run(action)
        
        self.buttonIsClickedTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false){ buttonIsClickedTimer in
            if(self.inGame==false){
                buttonIsClickedTimer.invalidate()
            }
            else{
                action=SKAction.moveTo(y:CGFloat(self.ground), duration:0.5)
                self.player.run(action)
            }
            
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(inGame==true){
            var count1=0
            //var count2=99
            for touch in touches {
                if((count1==touch.tapCount)==false){
                   buttonIsClicked()
                }
                count1=touch.tapCount
            }
        }
        
    }
    
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
