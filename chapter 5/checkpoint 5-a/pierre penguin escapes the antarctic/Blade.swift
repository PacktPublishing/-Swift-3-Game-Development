import SpriteKit

class Blade: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width:185, height: 92)
    var textureAtlas:SKTextureAtlas =
        SKTextureAtlas(named: "Enemies")
    var spinAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear,
                   size: initialSize)
        let startTexture = textureAtlas.textureNamed("blade")
        self.physicsBody = SKPhysicsBody(texture: startTexture,
                                         size: initialSize)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        createAnimations()
        self.run(spinAnimation)
    }
    
    func createAnimations() {
        let spinFrames:[SKTexture] = [
            textureAtlas.textureNamed("blade"),
            textureAtlas.textureNamed("blade-2")
        ]
        let spinAction = SKAction.animate(with: spinFrames,
                                          timePerFrame: 0.07)
        spinAnimation = SKAction.repeatForever(spinAction)
    }
    
    func onTap() {}
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
