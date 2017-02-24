import SpriteKit
import CoreMotion

class GameScene: SKScene {
    let cam = SKCameraNode()
    let ground = Ground()
    let player = Player()
    
    let motionManager = CMMotionManager()
    
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
        player.position = CGPoint(x: 150, y: 250)
        self.addChild(player)
        
        self.motionManager.startAccelerometerUpdates()
    }
    
    override func didSimulatePhysics() {
        // Keep the camera centered on the player
        self.camera!.position = player.position
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        player.update()
        
        // Unwrap the accelerometer data optional:
        if let accelData = self.motionManager.accelerometerData {
            var forceAmount:CGFloat
            var movement = CGVector()
            
            // Based on the device orientation, the tilt number
            // can indicate opposite user desires. The
            // UIApplication class exposes an enum that allows
            // us to pull the current orientation.
            // We will use this opportunity to explore Swift's
            // switch syntax and assign the correct force for the
            // current orientation:
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:
                // The 20,000 number is an amount that felt right
                // for our example, given Pierre's 30kg mass:
                forceAmount = 20000
            case .landscapeRight:
                forceAmount = -20000
            default:
                forceAmount = 0
            }
            
            // If the device is tilted more than 15% towards
            // vertical, then we want to move the Penguin:
            if accelData.acceleration.y > 0.15 {
                movement.dx = forceAmount
            }
                // Core Motion values are relative to portrait view.
                // Since we are in landscape, use y-values for x-axis.
            else if accelData.acceleration.y < -0.15 {
                movement.dx = -forceAmount
            }
            
            // Apply the force we created to the player:
            player.physicsBody?.applyForce(movement)
        }

    }
}
