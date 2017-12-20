//
//  GameScene.swift
//  Orbit
//
//  Created by Henry Macht on 12/8/17.
//  Copyright © 2017 10-12. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox
struct physicsCatagory {
    static let sun: UInt32 = 0x1 << 1
    static let usersShip: UInt32 = 0x1 << 2
    static let planet: UInt32 = 0x1 << 3
    static let magneticFeild: UInt32 = 0x1 << 4
    static let repelFeild: UInt32 = 0x1 << 5
    static let sunCopy2: UInt32 = 0x1 << 6
    static let theGem: UInt32 = 0x1 << 9
    static let asteroid: UInt32 = 0x1 << 10
    
    
    
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var usersShip = SKSpriteNode()
    var planet = SKSpriteNode()
    var sun = SKSpriteNode()
    var planetPath = SKSpriteNode()
    var dots = SKSpriteNode()
    var rocketSmoke = SKEmitterNode()
    var storage = SKSpriteNode()
    var explotion = SKEmitterNode()
    var explotion1 = SKEmitterNode()
    
    var gem1 = SKSpriteNode()
    var gem2 = SKSpriteNode()
    var gem3 = SKSpriteNode()
    
    
    var magneticFeild = SKSpriteNode()
    var repelFeild = SKSpriteNode()
    var pinkBar = SKSpriteNode()
    var whiteBar = SKSpriteNode()
    var sunCopy2 = SKSpriteNode()
    
    var circle = UIBezierPath()
    var circularMove = SKAction()
    var allTheFlares = [SKSpriteNode()]
    var removeMissed = [SKSpriteNode()]
    var removeFired = [SKSpriteNode()]
    var restartBtn = SKSpriteNode()
    var homeBtn = SKSpriteNode()
    
    var timer1 = Timer()
    
    var numberofYears = SKLabelNode()
    
    var whichDirection1 = -1
    var whichDirection2 = -1
    var sunflareimpulse1 = arc4random_uniform(100) + 20
    var sunflareimpulse2 = arc4random_uniform(100) + 20
    
    var whattoRemove = 1
    
    var destination = Int()
    
    var isClockwise = true
    var gameOver = false
    
    
    
    var pinkWidth = 500
    
    var pinkXVal = 0
    
    var addedOne = false
    
    var score = 0
    
    var storageVal = 0
    
    var aroundTheCircle = 0
    
    var candie = true
    
    var touchingScreen = false
    
    var rotationDirection = CGFloat(M_PI/8)
    
    var right = true
    
    var launch = false
    
    var itsRun = false
    
    var explotionIsRemoved = false
    
    var allTheGems = [SKSpriteNode]()
    var allTheGemsBU = [SKSpriteNode]()
    
    var ranGem = arc4random_uniform(3)
    
    
    var theGem = SKSpriteNode()
    var gemScore = SKLabelNode()
    var TopoBtm = Int(arc4random_uniform(2))
    var endOnce = 1
    var hitAlready = 1
    
    var endOGameDelayIsDone = false
    // For spawing asteroids
    let timeInBetweenSpawns: CGFloat = 4.5
    var timeSinceLastSpawn: CGFloat = 0
    let alertAsteroid = SKSpriteNode(imageNamed: "alert")
    
    // For Fuel
    let fuelBar = SKShapeNode(rectOf: CGSize(width: 200, height: 20))
    var fuel: CGFloat = 100
    var fuelReductionRate: CGFloat = 3
    let initialFuel: CGFloat = 100
    let fuelMask = SKSpriteNode(texture: nil, color: UIColor(red: 255/255, green: 194/255, blue: 0, alpha: 1), size: CGSize(width: 195, height: 15))

    func shakeCamera(layer:SKSpriteNode, duration:Float) {
        let amplitudeX:Float = 10;
        let amplitudeY:Float = 6;
        let numberOfShakes = duration / 0.04;
        var actionsArray:[SKAction] = [];
        for index in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.easeOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversed());
        }
        
        let actionSeq = SKAction.sequence(actionsArray);
        layer.run(actionSeq);
    }
    
    func createBox() {
        
        storage = SKSpriteNode(imageNamed: "box")
        storage.setScale(2)
        storage.position = CGPoint(x: -230, y: 620)
        self.addChild(storage)
        
        
    }
    
    func creategemScore(){
        gemScore = SKLabelNode(fontNamed: "Bebas Neue")
        gemScore.text = "\(score)"
        gemScore.fontSize = 80
        gemScore.fontColor = SKColor.black
        gemScore.alpha = 1
        gemScore.zPosition = 130
        gemScore.position = CGPoint(x: 220, y: 590)
        self.addChild(gemScore)
    }
        
    
    func createGem() {
        TopoBtm = Int(arc4random_uniform(2))
        let ranPosx = GKRandomDistribution(lowestValue: -280, highestValue: 280)
        let posx = CGFloat(ranPosx.nextInt())
        var ranPosy = GKRandomDistribution()
        var posy = CGFloat()
        if TopoBtm == 1{
            ranPosy = GKRandomDistribution(lowestValue: 100, highestValue: 580)
            posy = CGFloat(ranPosy.nextInt())
            
        }else{
            ranPosy = GKRandomDistribution(lowestValue: -500, highestValue: -180)
            posy = CGFloat(ranPosy.nextInt())
        }
        
        
        theGem = SKSpriteNode(imageNamed: "gem")
        theGem.setScale(2)
        theGem.position = CGPoint(x: posx, y: posy)
        theGem.zPosition = 85
        theGem.physicsBody = SKPhysicsBody(circleOfRadius: theGem.size.width / 2.0)
        theGem.physicsBody?.categoryBitMask = physicsCatagory.theGem
        theGem.physicsBody?.collisionBitMask = 0
        theGem.physicsBody?.contactTestBitMask = physicsCatagory.theGem | physicsCatagory.usersShip
        theGem.physicsBody?.affectedByGravity = false
        theGem.physicsBody?.isDynamic = false
        self.addChild(theGem)
    }
    
    func createAsteroid() {
        // Size of screne 750 x 1334
        let ranPosX = GKRandomDistribution(lowestValue: 0, highestValue: Int(self.scene!.size.width))
        let ranPosY = GKRandomDistribution(lowestValue: -Int(self.scene!.size.height / 2) - 10, highestValue: Int(self.scene!.size.height / 2) - 10)
        
        var posX = CGFloat(ranPosX.nextInt())
        let posY = CGFloat(ranPosY.nextInt())
        // Set start point to either left or right side
        // send end point to the opposite
        if posX > self.scene!.size.width / 2 {
            posX = self.scene!.size.width / 2 + 29
        } else {
            posX = -self.scene!.size.width / 2 - 29
        }
        
        // ADDED
        var endPosY = CGFloat(GKRandomDistribution(lowestValue: -Int(self.scene!.size.height / 2) - 10, highestValue: Int(self.scene!.size.height / 2) - 10).nextInt())
        var endPosX = -posX
        
        let asteroidRadius: CGFloat = 20
        let asteroid = SKSpriteNode(imageNamed: "asteroid")
        asteroid.xScale = 1.5
        asteroid.yScale = 1.5
        asteroid.position = CGPoint(x: posX, y: posY)
        asteroid.zPosition = 86
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroidRadius)
        asteroid.physicsBody?.categoryBitMask = physicsCatagory.asteroid
        asteroid.physicsBody?.collisionBitMask = physicsCatagory.asteroid | physicsCatagory.usersShip | physicsCatagory.sun
        asteroid.physicsBody?.contactTestBitMask = physicsCatagory.asteroid | physicsCatagory.usersShip | physicsCatagory.sun
        asteroid.physicsBody?.affectedByGravity = true
        asteroid.physicsBody?.isDynamic = true
        self.addChild(asteroid)
        asteroid.physicsBody?.applyTorque(0.1)
        
        
        if posX < 0 {
            self.alertAsteroid.position = CGPoint(x: posX + 50, y: posY)
        } else {
            self.alertAsteroid.position = CGPoint(x: posX - 50, y: posY)
        }
        
        let grow = SKAction.scale(to: 2, duration: 1.1)
        let shrink = SKAction.scale(to: 0, duration: 0.3)
        self.alertAsteroid.run(SKAction.sequence([grow, shrink]))
        //asteroid.physicsBody?.velocity = CGVector(dx: endPosX - posX, dy: endPosY - posY)
        //asteroid.physicsBody?.applyImpulse(CGVector(dx: endPosX - posX, dy: endPosY - posY))
        let speed: TimeInterval = 6
        let moveAction = SKAction.move(to: CGPoint(x: endPosX, y: endPosY), duration: speed)
        let wait = SKAction.wait(forDuration: 1.5)
        asteroid.run(SKAction.sequence([wait, moveAction])) {
            asteroid.removeFromParent()
        }
    }
    
    func createPlanetPath() {
        
        planetPath = SKSpriteNode(imageNamed: "Path 17")
        planetPath.setScale(1.7)
        planetPath.position = CGPoint(x: 0, y: 0)
        self.addChild(planetPath)
        planetPath.zPosition = 15
        
    }
    func createdots() {
        
        dots = SKSpriteNode(imageNamed: "Group 4")
        dots.size.height = self.size.height
        dots.size.width = self.size.width
        
        dots.position = CGPoint(x: 0, y: 0)
        dots.alpha = 0
        self.addChild(dots)
        planetPath.zPosition = 15
        
    }
    func createRestartbtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.setScale(2)
        restartBtn.position = CGPoint(x: 0, y: -500)
        restartBtn.alpha = 0
        restartBtn.name = "restartGame"
    }
    
    
    func createSun() {
        
        sun = SKSpriteNode(imageNamed: "Moon")
        sun.setScale(2)
        sun.position = CGPoint(x: 0, y: 0)
        sun.zPosition = 80
        sun.physicsBody = SKPhysicsBody(circleOfRadius: sun.size.width / 2.0)
        sun.physicsBody?.categoryBitMask = physicsCatagory.sun
        sun.physicsBody?.collisionBitMask = physicsCatagory.sun | physicsCatagory.usersShip | physicsCatagory.asteroid
        sun.physicsBody?.contactTestBitMask = physicsCatagory.sun | physicsCatagory.usersShip | physicsCatagory.asteroid
        sun.physicsBody?.affectedByGravity = false
        sun.physicsBody?.isDynamic = false
        
        self.addChild(sun)
        
    }
    func createShip() {
        usersShip = SKSpriteNode(imageNamed: "myShip")
        //usersShip.setScale(2)
        usersShip.size.width = 42
        usersShip.size.height = 38
        usersShip.position = CGPoint(x: 0, y: 100)
        usersShip.zPosition = 25
        usersShip.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed:"myShip"), size: usersShip.size)
        //usersShip.physicsBody = SKPhysicsBody(rectangleOf: usersShip.size)
        usersShip.physicsBody?.categoryBitMask = physicsCatagory.usersShip
        usersShip.physicsBody?.collisionBitMask = physicsCatagory.usersShip | physicsCatagory.planet | physicsCatagory.sun
        usersShip.physicsBody?.contactTestBitMask = physicsCatagory.usersShip | physicsCatagory.planet | physicsCatagory.sun | physicsCatagory.theGem | physicsCatagory.asteroid
        usersShip.physicsBody?.affectedByGravity = true
        usersShip.physicsBody?.isDynamic = true
        
        // ADDED
        /*
        let smoke = SKEmitterNode(fileNamed: "Smoke")!
        smoke.name = "Smoke"
        smoke.xScale = 0.2
        smoke.yScale = 0.2
        smoke.zPosition = 20
        smoke.isHidden = true
        usersShip.addChild(smoke)
        smoke.position = CGPoint(x: 0, y: -usersShip.size.height/2)*/
        
        self.addChild(usersShip)
    }
    func explode(){
        explotion = SKEmitterNode(fileNamed: "Explotion")!
        explotion.name = "explotion"
        //explotion.xScale = 0.2
        //explotion.yScale = 0.2
        explotion.zPosition = 20
        //explotion.isHidden = true
        //usersShip.addChild(explotion)
        explotion.position = CGPoint(x: 0, y: 400)
    }
    func explode1(){
        explotion1 = SKEmitterNode(fileNamed: "explotionWhite")!
        explotion1.name = "explotionWhite"
        //explotion1.xScale = 0.2
        //explotion1.yScale = 0.2
        explotion1.zPosition = 20
        //explotion1.isHidden = true
        //usersShip.addChild(explotion1)
        explotion1.position = CGPoint(x: 0, y: 400)
    }
    
    func createPlanet() {
        
        let planet = SKSpriteNode(imageNamed: "planet")
        planet.setScale(2)
        planet.position = CGPoint(x: 0, y: 0)
        planet.zPosition = 50
        planet.physicsBody = SKPhysicsBody(circleOfRadius: planet.size.width / 2.0)
        planet.physicsBody?.categoryBitMask = physicsCatagory.planet
        planet.physicsBody?.collisionBitMask = physicsCatagory.planet | physicsCatagory.usersShip
        planet.physicsBody?.contactTestBitMask = physicsCatagory.planet | physicsCatagory.usersShip
        planet.physicsBody?.affectedByGravity = false
        planet.physicsBody?.isDynamic = true
        
        
        self.addChild(planet)
        
        circle = UIBezierPath(roundedRect: CGRect(x: self.frame.midX - 260, y: self.frame.midY - 260, width: 525, height: 525), cornerRadius: 300)
        circularMove = SKAction.follow(circle.cgPath, asOffset: false, orientToPath: false, duration: 2)

        planet.run(SKAction.repeatForever(circularMove))
        //planet.run(SKAction.repeatForever(circularMove).reversed())
        
        
    }
    func createyears(){
        numberofYears = SKLabelNode(fontNamed: "Bebas Neue")
        numberofYears.text = "You gathered \(score) gems"
        numberofYears.fontSize = 40
        numberofYears.fontColor = SKColor.black
        numberofYears.zPosition = 150
        numberofYears.alpha = 0
        
    }
    
    
    
    func randomPointOnCircle(radius:Float, center:CGPoint) -> CGPoint {
        // Random angle in [0, 2*pi]
        let theta = Float(arc4random_uniform(UInt32.max))/Float(UInt32.max-1) * Float.pi * 2.0
        
        // Convert polar to cartesian
        let x = radius * cos(theta)
        let y = radius * sin(theta)
        return CGPoint(x: CGFloat(x)+center.x, y: CGFloat(y)+center.y)
    }
    func pointOnCircle(radius:Float, center:CGPoint) -> CGPoint {
        // Random angle in [0, 2*pi]
        aroundTheCircle = aroundTheCircle + 2000000000
        let theta = Float(aroundTheCircle)/Float(UInt32.max-1) * Float.pi * 2.0
        // Convert polar to cartesian
        let x = radius * cos(theta)
        let y = radius * sin(theta)
        return CGPoint(x: CGFloat(x)+center.x, y: CGFloat(y)+center.y)
    }
    
    func endofGameNoDelay(){
        if endOnce == 1 {
            print("Game Over")
            gameOver = true
            self.timer1.invalidate()
            self.sun.run(SKAction.scale(to: 0, duration: 1))
            
            self.numberofYears.text = "You gathered \(self.score) gems"
            restartBtn.alpha = 0.5
            self.addChild(restartBtn)
            
            theGem.removeFromParent()
            let delayInSeconds = 1.0
            gemScore.removeFromParent()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                self.numberofYears.alpha = 0
                self.addChild(self.numberofYears)
                self.storage.removeFromParent()
                self.numberofYears.run(SKAction.fadeAlpha(to: 1, duration: 1))
                
                
                
            }
            endOnce = 0
        }
    }
    func goToGameScene(){
        print("Game Started")
        gameOver = false
        timer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: "update1", userInfo: nil, repeats: true)
        self.sun.run(SKAction.scale(to: 2, duration: 1))
        score = 0
        storageVal = 0
        hitAlready = 1
        gemScore.text = "\(score)"
        usersShip.position = CGPoint(x: 0, y: 100)
        usersShip.zRotation = 0
        self.addChild(usersShip)
        endOnce = 1
        // ADDED
        self.fuel = self.initialFuel
        self.restartBtn.removeFromParent()
        self.addChild(storage)
        self.addChild(gemScore)
        self.theGem.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
        numberofYears.removeFromParent()
        explotion.particleBirthRate = 19
        createGem()
    }
    
    
    
    
    
    
    
    
    override func didMove(to view: SKView) {
        
        //view.showsPhysics = true
        self.physicsWorld.contactDelegate = self
        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        let field = SKFieldNode.radialGravityField()
        // center on X-axis
        field.position.x = 0
        // center on Y-axis
        field.position.y = 0
        // add to your world
        field.strength = 0.6
        
        
        self.addChild(field)
        
        print("Scene")
        
        createdots()
        createRestartbtn()
        createShip()
        createPlanetPath()
        createSun()
        createPlanet()
        createyears()
        createGem()
        creategemScore()
        createBox()
        explode1()
        explode()
        
        self.fuel = self.initialFuel
        self.alertAsteroid.scale(to: CGSize(width: 0, height: 0))
        self.addChild(self.alertAsteroid)
        
        fuelBar.strokeColor = UIColor.black
        fuelBar.lineWidth = 5
        fuelBar.zPosition = 100
        fuelBar.position = CGPoint(x: -self.size.width/2 + fuelBar.frame.size.width/2 + 10, y: -self.size.height/2 + 50)
        self.addChild(fuelBar)
        
        fuelMask.name = "mask"
        //fuelMask.fillColor = UIColor.blue
        fuelMask.position = CGPoint(x: 0, y: 0)
        fuelBar.addChild(fuelMask)
        
        
        /*
        
        let delayInSeconds = 0.9
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.createPlanet()
            
        }
 */
        

        
        
        
        timer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: "update1", userInfo: nil, repeats: true)
        
        
        
    }
    
    var r = CGFloat(0.4)
    var dx = CGFloat()
    var dy = CGFloat()
    var rotatD2 = 0
    var rotationInDegrees = CGFloat()
    var newRotationDegrees = CGFloat()
    var radianFactor = CGFloat(0.0174532925)
    var newRotationRadians = CGFloat()
    
    
    func updateFuelBar(amountLeft: CGFloat) {
        self.fuelMask.size = CGSize(width: (amountLeft / self.initialFuel) * 195, height: 15)
        // ADDED
        self.fuelMask.position = CGPoint(x: (-195/2) + self.fuelMask.size.width/2, y: self.fuelMask.position.y)
    }
    
    
    
    @objc func update1() {
        
        
        
        
        
        
        
        rotationInDegrees = usersShip.zRotation / radianFactor;
        newRotationDegrees = rotationInDegrees + 90;
        newRotationRadians = newRotationDegrees * radianFactor;
        
        
        
        dx = r * cos(newRotationRadians)
        dy = r * sin(newRotationRadians)
        if touchingScreen {
            if launch{
                usersShip.physicsBody?.applyImpulse(CGVector(dx: dx * 3, dy: dy * 3))
            }else{
                
                
                usersShip.run(SKAction.rotate(byAngle: rotationDirection, duration: 0.3))
                usersShip.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
                
            }
            
            
            
            
            
            
        }
    }
    
    func dieShipAnimation() {
        for i in 1...40{
            usersShip.removeFromParent()
            sunCopy2 = sun.copy() as! SKSpriteNode
            sunCopy2 = SKSpriteNode(imageNamed: "flame")
            sunCopy2.zPosition = 100
            sunCopy2.position = CGPoint(x: usersShip.position.x, y: usersShip.position.y)
            sunCopy2.setScale(0.3)
            sunCopy2.physicsBody = SKPhysicsBody(circleOfRadius: sunCopy2.size.width / 2.0)
            sunCopy2.physicsBody?.categoryBitMask = physicsCatagory.sunCopy2
            sunCopy2.physicsBody?.collisionBitMask = physicsCatagory.sunCopy2
            sunCopy2.physicsBody?.contactTestBitMask = physicsCatagory.sunCopy2
            sunCopy2.physicsBody?.affectedByGravity = false
            sunCopy2.physicsBody?.isDynamic = true
            removeFired.append(sunCopy2)
            self.addChild(sunCopy2)
            let delayInSeconds2 = 0.1
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds2) {
                for i in 1...self.removeFired.count{
                    self.removeFired[i - 1].run(SKAction.fadeAlpha(to: 0, duration: 0.3))
                    let delayInSeconds3 = 0.3
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds3) {
                        self.removeFired[i - 1].removeFromParent()
                    }
                }
            }
            
            sunCopy2.run(SKAction.move(to: pointOnCircle(radius: 250, center: CGPoint(x: planet.position.x + 20, y: planet.position.y + 20)), duration: 0.5))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstbody = contact.bodyA
        let secondbody = contact.bodyB
        
        if firstbody.categoryBitMask == physicsCatagory.usersShip && secondbody.categoryBitMask == physicsCatagory.planet || firstbody.categoryBitMask == physicsCatagory.planet && secondbody.categoryBitMask == physicsCatagory.usersShip{
            print("planet")
            usersShip.removeFromParent()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            shakeCamera(layer: theGem, duration: 0.5)
            shakeCamera(layer: planetPath, duration: 0.5)
            shakeCamera(layer: sun, duration: 0.5)
            
            //dieShipAnimation()
            endofGameNoDelay()
            explotion.position = CGPoint(x: usersShip.position.x, y: usersShip.position.y)
            explotion1.position = CGPoint(x: usersShip.position.x, y: usersShip.position.y)
            if hitAlready == 1{
                self.addChild(explotion1)
                self.addChild(explotion)
                hitAlready = 0
            }
            
            let delayInSeconds = 0.5
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                self.explotion.particleBirthRate = 1
                let delayInSeconds2 = 1.2
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds2) {
                    self.explotion1.particleBirthRate = 1
                    
                }
                
                let delayInSeconds3 = 3.0
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds3) {
                    self.explotion1.removeFromParent()
                    self.explotion.removeFromParent()
                    self.restartBtn.alpha = 1.0
                    self.endOGameDelayIsDone = true
                    
                    
                }
            }
            
                //CGPoint(x: Int(arc4random_uniform(500)), y: Int(arc4random_uniform(500)))
                //pointOnCircle(radius: 21, center: CGPoint(x: planet.position.x, y: planet.position.y))
        }
        
        if firstbody.categoryBitMask == physicsCatagory.usersShip && secondbody.categoryBitMask == physicsCatagory.theGem || firstbody.categoryBitMask == physicsCatagory.theGem && secondbody.categoryBitMask == physicsCatagory.usersShip{
            print("G1")
            //self.score = self.score + 1
            storageVal = storageVal + 1
            theGem.physicsBody = nil
            theGem.run(SKAction.scale(to: 3, duration: 0.5))
            theGem.run(SKAction.move(to: CGPoint(x: storage.position.x, y: storage.position.y) , duration: 1))
            let delayInSeconds = 0.5
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                self.theGem.run(SKAction.scale(to: 0, duration: 0.5))
            }
            let delayInSeconds2 = 1.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds2) {
                self.theGem.removeFromParent()
                self.createGem()
                
                //self.gemScore.text = "\(self.score)"
                let grow = SKAction.scale(to: 2.3, duration: 0.5)
                let shrink = SKAction.scale(to: 2, duration: 0.5)
                
                self.storage.run(SKAction.sequence([grow, shrink]))
            }
            itsRun = true
            
            
            
            
            
        }
        if firstbody.categoryBitMask == physicsCatagory.usersShip && secondbody.categoryBitMask == physicsCatagory.asteroid || secondbody.categoryBitMask == physicsCatagory.usersShip && firstbody.categoryBitMask == physicsCatagory.asteroid {
            
            //dieShipAnimation()
            endofGameNoDelay()
        }
        if firstbody.categoryBitMask == physicsCatagory.usersShip && secondbody.categoryBitMask == physicsCatagory.sun || secondbody.categoryBitMask == physicsCatagory.usersShip && firstbody.categoryBitMask == physicsCatagory.sun {
            
            if storageVal > 0{
                print(storageVal)
                for i in 1...storageVal{
                    score = score + 1
                    storageVal = storageVal - 1
                    gemScore.text = "\(score)"
                    let grow = SKAction.scale(to: 1.3, duration: 0.5)
                    let shrink = SKAction.scale(to: 1, duration: 0.5)
                    
                    self.gemScore.run(SKAction.sequence([grow, shrink]))
                }
            }
            
            self.fuel = self.initialFuel
            self.updateFuelBar(amountLeft: self.fuel)
            
            
        }
        if firstbody.categoryBitMask == physicsCatagory.asteroid && secondbody.categoryBitMask == physicsCatagory.sun || firstbody.categoryBitMask == physicsCatagory.sun && secondbody.categoryBitMask == physicsCatagory.asteroid {
            
            let explosion = SKEmitterNode(fileNamed: "MyParticle.sks")!
            if firstbody.categoryBitMask == physicsCatagory.asteroid {
                explosion.position = firstbody.node!.position
                firstbody.node?.removeFromParent()
            } else {
                explosion.position = secondbody.node!.position
                secondbody.node?.removeFromParent()
            }
            self.addChild(explosion)
            self.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run({
                explosion.removeFromParent()
            })]))
        }
    }
    
    var countTouch:[Int] = []
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        countTouch.append((event?.allTouches?.count)!)
        
        
        
        usersShip.childNode(withName: "Smoke")?.isHidden = false
        touchingScreen = true
        
        // ADDED
        if gameOver == false{
            let sound = SKAction.repeatForever(SKAction.playSoundFileNamed("RocketThrust.wav", waitForCompletion: true))
            //self.run(sound, withKey: "rocketSound")
        }
        
        
        usersShip.size.height = 43
        usersShip.texture = SKTexture(imageNamed:"myShip2")
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
    
        let touchedNode = self.atPoint(positionInScene)
        
        
        
        if positionInScene.x > 0{
            
            right = true
            rotationDirection = CGFloat(-M_PI/8)
            
            
        }else{
            right = false
            
            rotationDirection = CGFloat(M_PI/8)
        }
        
        if let name = touchedNode.name{
            
            if name == "restartGame"{
                
                if endOGameDelayIsDone{
                    goToGameScene()
                    endOGameDelayIsDone = false
                }
                
                
                
                
            }
        }
        
        
        
        
        
            
    }
        
        
 
        
        
        
        
        
        
        
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        countTouch.append((event?.allTouches?.count)!)
        //print(countTouch[countTouch.count - 1])
        if countTouch[countTouch.count - 1] == 2{
            launch = true
        }else{
            launch = false
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = false
        usersShip.texture = SKTexture(imageNamed:"myShip")
        // ADDED
        usersShip.childNode(withName: "Smoke")?.isHidden = true
        usersShip.size.height = 38
        // ADDED
        
        self.removeAction(forKey: "rocketSound")
        
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingScreen = false
        usersShip.texture = SKTexture(imageNamed:"myShip")
        // ADDED
        usersShip.childNode(withName: "Smoke")?.isHidden = true
        usersShip.size.height = 38
        // ADDED
        
        self.removeAction(forKey: "rocketSound")
        
    }
    
    var lastUpdateTime: TimeInterval = 0
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if usersShip.position.x > self.size.width/2 {
            usersShip.position.x = -self.size.width/2
        }
        if usersShip.position.x < -self.size.width/2 {
            usersShip.position.x = self.size.width/2
        }
        if usersShip.position.y > self.size.height/2 {
            usersShip.position.y = -self.size.height/2
        }
        if usersShip.position.y < -self.size.height/2 {
            usersShip.position.y = self.size.height/2
        }
        
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        /*
        if usersShip.position.y > 272 || usersShip.position.y < -272{
            if itsRun == false{
                dots.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
                let delayInSeconds = 0.8
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
                    self.dots.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
                }
                itsRun = true
            }
            
        }
        
        if usersShip.position.y < 272 && usersShip.position.y > -272{
            itsRun = false
        }
 */
        
        self.timeSinceLastSpawn += CGFloat(deltaTime)
        
        
        
        
        
        if timeSinceLastSpawn > self.timeInBetweenSpawns {
            self.createAsteroid()
            self.timeSinceLastSpawn = 0
        }
        
        
        
        
        
        // Update gravity of moon
        // ADDED
        let distancePlayerToMoon = distance(p1: usersShip.position, p2: sun.position)
        if distancePlayerToMoon > distance(p1: sun.position, p2: self.planet.position) {
            let dampningValue = CGFloat(0.01 * distancePlayerToMoon / (self.scene!.frame.height * 2))
            usersShip.physicsBody?.applyForce(CGVector(dx: (sun.position.x - usersShip.position.x) * dampningValue, dy: (sun.position.y - usersShip.position.y) * dampningValue))
        }
        // ADDED
        if touchingScreen {
            var fuelDecreaseRate = self.fuelReductionRate
            if countTouch[countTouch.count - 1] == 2 {
                fuelDecreaseRate *= 2
            }
            self.fuel -= fuelDecreaseRate * CGFloat(deltaTime)
            if fuel < 0 {
                fuel = 0
                // ADDED
                self.dieShipAnimation()
            }
            self.updateFuelBar(amountLeft: self.fuel)
        }
    }
    
    // ADDED
    func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let xDif = p1.x - p2.x
        let yDif = p1.y - p2.y
        
        return CGFloat(sqrt((xDif * xDif) + (yDif * yDif)))
    }
}
