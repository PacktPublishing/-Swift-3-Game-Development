import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import GameKit

class GameViewController: UIViewController {
    var musicPlayer = AVAudioPlayer()
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Build the menu scene:
        let menuScene = MenuScene()
        let skView = self.view as! SKView
        // Ignore drawing order of child nodes
        // (This increases performance)
        skView.ignoresSiblingOrder = true
        // Size our scene to fit the view exactly:
        menuScene.size = view.bounds.size
        // Show the menu:
        skView.presentScene(menuScene)
        
        // Start the background music:
        let musicPath = Bundle.main.path(forResource:
            "Sound/BackgroundMusic.m4a", ofType: nil)!
        let url = URL(fileURLWithPath: musicPath)
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer.numberOfLoops = -1
            musicPlayer.prepareToPlay()
            musicPlayer.play()
        }
        catch { /* Couldn't load music file */ }
        
        authenticateLocalPlayer(menuScene: menuScene)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // (We pass in the menuScene instance so we can create a
    // leaderboard button in the menu when the player is
    // authenticated with Game Center)
    func authenticateLocalPlayer(menuScene:MenuScene) {
        // Create a new Game Center localPlayer instance:
        let localPlayer = GKLocalPlayer.localPlayer();
        // Create a function to check if they authenticated
        // or show them the log in screen:
        localPlayer.authenticateHandler =
            {(viewController, error) -> Void in
            if viewController != nil {
                // They are not logged in, show the log in:
                self.present(viewController!, animated: true,
                    completion: nil)
            }
            else if localPlayer.isAuthenticated {
                // They authenticated successfully!
                menuScene.createLeaderboardButton()
            }
            else {
                // Not able to authenticate, skip Game Center 
            }
        }
    }
}
