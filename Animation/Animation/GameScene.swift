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
    weak var gameOverLabel:UILabel!
    weak var startButton:UIButton!
    
    weak var enemy:SKNode!
    weak var player:SKSpriteNode!
    weak var gameView:SKView!
    
    weak var didMoveTimer:Timer!
    weak var animalTimer:Timer!
    weak var buttonIsClickedTimer:Timer!
    
    override func didMove(to view: SKView) {
        //let image=UIImage(named:"Image-5")
        let background=SKSpriteNode(imageNamed:"Image-5")
        background.size=self.frame.size
        background.position=CGPoint(x:self.frame.midX, y:self.frame.midY)
        self.addChild(background)
        self.inGame=true
        gameView=view
        
        var img=UIImage(named:"Image-4")
        let weight=UIImage.SymbolWeight.black
        let conf=UIImage.SymbolConfiguration.init(weight: weight)
        img=img?.applyingSymbolConfiguration(conf)
        
        let playerSpriteTexture=SKTexture.init(image:img!)
        //let playerSpriteTexture=SKTexture(imageNamed:"Image-4");
        let playerSprite=SKSpriteNode(texture:playerSpriteTexture)
        playerSprite.position=CGPoint(x: -50, y: 100)
        player=playerSprite
        player.size.width=200
        player.size.height=200
        print(self.player.size.width)
        print(self.player.size.height)
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
        /*didMoveTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { didMoveTimer in
            self.getRandAnimal(arr: arr)
            count+=1
        }
        if(count==1){
            didMoveTimer.invalidate()
        }*/
    }
    
    func gameOverScreen(){
        self.inGame=false
        self.removeAllChildren()
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center
        label.text = "Game over!"
        gameOverLabel=label

        self.gameView.addSubview(gameOverLabel)
        let button=UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        button.center=CGPoint(x: 160, y: 335)
        button.setTitle("Play again", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action:#selector(restartGame), for: .touchUpInside)
        button.backgroundColor=UIColor.black
        startButton=button
        self.gameView.addSubview(self.startButton)
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
    
    @IBAction func restartGame(){
        self.gameOverLabel.removeFromSuperview()
        self.startButton.removeFromSuperview()
        didMove(to: self.gameView)
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
        var count=0
        //var count2=99
        for touch in touches {
            if((count==touch.tapCount)==false && (inGame==true)){
               buttonIsClicked()
            }
            count=touch.tapCount
        }
    }
}
