import SpriteKit

class GameScene: SKScene {
    let cam = SKCameraNode()
    let ground = Ground()
    let player = Player()
    let encounterManager = EncounterManager()
    let powerUpStar = Star()
    
    var screenCenterY = CGFloat()
    
    let initialPlayerPosition = CGPoint(x: 150, y: 250)
    var playerProgress = CGFloat()

    var nextEncounterSpawnPosition = CGFloat(150)
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue:
            0.95, alpha: 1.0)
        
        // Assign the camera to the scene
        self.camera = cam
        
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
        
        encounterManager.addEncountersToScene(gameScene: self)
        
        // Place the star out of the way for now
        self.addChild(powerUpStar)
        powerUpStar.position = CGPoint(x: -2000, y: -2000)
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
        
        // Check to see if we should set a new encounter:
        if player.position.x > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(
                currentXPos: nextEncounterSpawnPosition)
            nextEncounterSpawnPosition += 1200
            
            // Each encounter has a 10% chance to spawn a star:
            let starRoll = Int(arc4random_uniform(10))
            if starRoll == 0 {
                // Only move the star if it is off the screen.
                if abs(player.position.x - powerUpStar.position.x)
                    > 1200 {
                    // Y Position 50-450:
                    let randomYPos = 50 +
                        CGFloat(arc4random_uniform(400))
                    powerUpStar.position = CGPoint(x:
                        nextEncounterSpawnPosition, y: randomYPos)
                    // Remove any previous velocity and spin:
                    powerUpStar.physicsBody?.angularVelocity = 0
                    powerUpStar.physicsBody?.velocity =
                        CGVector(dx: 0, dy: 0)
                }
            }
        }
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
