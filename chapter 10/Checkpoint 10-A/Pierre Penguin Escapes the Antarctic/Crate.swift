import SpriteKit

class Crate: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 40, height: 40)
    var textureAtlas:SKTextureAtlas =
        SKTextureAtlas(named: "Environment")
    var givesHeart = false
    var exploded = false
    
    init() {
        super.init(texture: nil, color: UIColor.clear,
                   size: initialSize)
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
        
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue | PhysicsCategory.crate.rawValue
        self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
        
        self.texture = textureAtlas.textureNamed("crate")
        
    }
    
    func turnToHeartCrate() {
        self.physicsBody?.affectedByGravity = false
        self.texture = textureAtlas.textureNamed("crate-power-up")
        givesHeart = true
    }
    
    func explode() {
        // Do not do anything if this crate already exploded:
        if exploded { return }
        exploded = true
        
        // Prevent additional contact:
        self.physicsBody?.categoryBitMask = 0
    }
    
    func reset() {
        self.alpha = 1
        self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
        exploded = false
    }
    
    func onTap() {}
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
