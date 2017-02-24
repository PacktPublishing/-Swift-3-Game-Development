import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

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
}
