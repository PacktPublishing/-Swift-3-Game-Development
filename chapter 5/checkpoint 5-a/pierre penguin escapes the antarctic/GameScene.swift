import SpriteKit

class GameScene: SKScene {
    let cam = SKCameraNode()
    let ground = Ground()
    let player = Player()
    
    var screenCenterY = CGFloat()
    
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()

    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue:
            0.95, alpha: 1.0)
        
        // Assign the camera to the scene
        self.camera = cam
        
        // Spawn our test bees:
        let bee2 = Bee()
        bee2.position = CGPoint(x: 325, y: 325)
        self.addChild(bee2)
        let bee3 = Bee()
        bee3.position = CGPoint(x: 200, y: 325)
        self.addChild(bee3)
        
        // Add the ground to the scene:
        ground.position = CGPoint(x: -self.size.width * 2, y: 30)
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        ground.createChildren()
        self.addChild(ground)
        
        // Add the player to the scene:
        player.position = initialPlayerPosition
        self.addChild(player)
        
        // Set gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        // Store the vertical center of the screen:
        screenCenterY = self.size.height / 2
        
        // Spawn a bat:
        let bat = Bat()
        bat.position = CGPoint(x: 400, y: 200)
        self.addChild(bat)
        
        // A blade:
        let blade = Blade()
        blade.position = CGPoint(x: 300, y: 76)
        self.addChild(blade)
        
        // A mad fly:
        let madFly = MadFly()
        madFly.position = CGPoint(x: 50, y: 50)
        self.addChild(madFly)
        
        // A bronze coin:
        let bronzeCoin = Coin()
        bronzeCoin.position = CGPoint(x: -50, y: 250)
        self.addChild(bronzeCoin)
        
        // A gold coin:
        let goldCoin = Coin()
        goldCoin.position = CGPoint(x: 25, y: 250)
        goldCoin.turnToGold()
        self.addChild(goldCoin)
        
        // The powerup star:
        let star = Star()
        star.position = CGPoint(x: 250, y: 250)
        self.addChild(star)
    }
    
    override func didSimulatePhysics() {
        // Keep track of how far the player has flown
        playerProgress = player.position.x -
            initialPlayerPosition.x
        
        // Keep the camera locked at mid screen by default:
        var cameraYPos = screenCenterY
        cam.yScale = 1
        cam.xScale = 1
        
        // Follow the player up if they're higher than half the screen:
        if (player.position.y > screenCenterY) {
            cameraYPos = player.position.y
            // Scale out the camera as they go higher:
            let percentOfMaxHeight = (player.position.y -
                screenCenterY) / (player.maxHeight -
                    screenCenterY)
            let newScale = 1 + percentOfMaxHeight
            cam.yScale = newScale
            cam.xScale = newScale
        }
        
        // Move the camera for our adjustment:
        self.camera!.position = CGPoint(x: player.position.x, y: cameraYPos)
        
        // Check to see if the ground should jump forward:
        ground.checkForReposition(playerProgress: playerProgress)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            // Find the location of the touch:
            let location = touch.location(in: self)
            // Locate the node at this location:
            let nodeTouched = atPoint(location)
            // Attempt to downcast the node to the GameSprite protocol
            if let gameSprite = nodeTouched as? GameSprite {
                // If this node adheres to GameSprite, call onTap:
                gameSprite.onTap()
            }
        }
        
        player.startFlapping()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }

    
    override func update(_ currentTime: TimeInterval) {
        player.update()
    }
}
