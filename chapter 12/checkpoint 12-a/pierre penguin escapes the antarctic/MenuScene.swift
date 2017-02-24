import SpriteKit
import GameKit

class MenuScene: SKScene, GKGameCenterControllerDelegate {
    // Grab the HUD texture atlas:
    let textureAtlas:SKTextureAtlas =
        SKTextureAtlas(named:"HUD")
    // Instantiate a sprite node for the start button
    // (we'll use this in a moment):
    let startButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        // Position nodes from the center of the scene:
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Add the background image:
        let backgroundImage = SKSpriteNode(imageNamed:
            "background-menu")
        backgroundImage.size = CGSize(width: 1024, height: 768)
        backgroundImage.zPosition = -1
        self.addChild(backgroundImage)
        
        // Draw the name of the game:
        let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoText.text = "Pierre Penguin"
        logoText.position = CGPoint(x: 0, y: 100)
        logoText.fontSize = 60
        self.addChild(logoText)
        // Add another line below:
        let logoTextBottom = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoTextBottom.text = "Escapes the Antarctic"
        logoTextBottom.position = CGPoint(x: 0, y: 50)
        logoTextBottom.fontSize = 40
        self.addChild(logoTextBottom)

        // Build the start game button:
        startButton.texture = textureAtlas.textureNamed("button")
        startButton.size = CGSize(width: 295, height: 76)
        // Name the start node for touch detection:
        startButton.name = "StartBtn"
        startButton.position = CGPoint(x: 0, y: -20)
        self.addChild(startButton)
        
        // Add text to the start button:
        let startText = SKLabelNode(fontNamed:
            "AvenirNext-HeavyItalic")
        startText.text = "START GAME"
        startText.verticalAlignmentMode = .center
        startText.position = CGPoint(x: 0, y: 2)
        startText.fontSize = 40
        startText.zPosition = 5
        // Name the text node for touch detection:
        startText.name = "StartBtn"
        startButton.addChild(startText)

        // Pulse the start button in and out gently:
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.9),
            SKAction.fadeAlpha(to: 1, duration: 0.9),
            ])
        startText.run(SKAction.repeatForever(pulseAction))
        
        // If they're logged in, create the leaderboard button
        // (This will only apply to players returning to the menu)
        if GKLocalPlayer.localPlayer().isAuthenticated {
            createLeaderboardButton()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            // Find the location of the touch:
            let location = touch.location(in: self)
            // Locate the node at this location:
            let nodeTouched = atPoint(location)
            if nodeTouched.name == "StartBtn" {
                // Player touched the start text or button node
                // Switch to an instance of the GameScene:
                self.view?.presentScene(GameScene(size: self.size))
            }
            else if nodeTouched.name == "LeaderboardBtn" {
                showLeaderboard()
            }
        }
    }
    
    func createLeaderboardButton() {
        // Add some text to open the leaderboard
        let leaderboardText = SKLabelNode(fontNamed:
            "AvenirNext")
        leaderboardText.text = "Leaderboard"
        leaderboardText.name = "LeaderboardBtn"
        leaderboardText.position = CGPoint(x: 0, y: -100)
        leaderboardText.fontSize = 20
        self.addChild(leaderboardText)
    }

    func showLeaderboard() {
        // A new instance of a game center view controller:
        let gameCenter = GKGameCenterViewController()
        // Set this scene as the delegate (helps enable the
        // done button in the game center)
        gameCenter.gameCenterDelegate = self
        // Show the leaderboards when the game center opens:
        gameCenter.viewState =
            GKGameCenterViewControllerState.leaderboards
        // Find the current view controller:
        if let gameViewController =
            self.view?.window?.rootViewController {
            // Display the new Game Center view controller:
            gameViewController.show(gameCenter, sender: self)
            gameViewController.navigationController?
                .pushViewController(gameCenter, animated: true)
        }
    }
    
    // This hides the game center when the user taps 'done'
    func gameCenterViewControllerDidFinish
        (_ gameCenterViewController:
        GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
