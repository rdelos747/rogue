//
//  tile.swift
//  rogue
//
//  Created by rafael de los santos on 6/19/18.
//  Copyright © 2018 rafael de los santos. All rights reserved.
//

import Foundation
import SpriteKit

class Tile: SKSpriteNode {
    var label:SKLabelNode
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        self.label = SKLabelNode(fontNamed: "Menlo")
        super.init(texture:nil, color:hex("#ffffff"), size:CGSize(width: TILE_WIDTH, height: TILE_HEIGHT))
        self.anchorPoint = CGPoint(x:0, y:0)
        self.position = CGPoint(x:10, y:10)
        
        self.label.text = "x"
        self.label.fontSize = CGFloat(TILE_LABEL_SIZE)
        self.label.fontColor = hex("#ff0000")
        self.label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.label.position = CGPoint(x: TILE_WIDTH / 2, y: TILE_HEIGHT / 2)
        self.addChild(self.label)
    }
}
