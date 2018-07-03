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
    var type:String
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ j:Int, _ i:Int, _ newType:String) {
        self.type = newType
        self.label = SKLabelNode(fontNamed: "Menlo")
        super.init(texture:nil, color:UIColor.clear, size:CGSize(width: TILE_WIDTH, height: TILE_HEIGHT))
        self.anchorPoint = CGPoint(x:0, y:0)
        self.position = CGPoint(x:i * TILE_WIDTH, y:j * TILE_HEIGHT)
        self.isHidden = true
        
        self.label.text = " "
        self.label.fontSize = CGFloat(TILE_LABEL_SIZE)
        self.label.fontColor = hex("#000000")
        self.label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.label.position = CGPoint(x: TILE_WIDTH / 2, y: TILE_HEIGHT / 2)
        self.label.isHidden = true
        self.addChild(self.label)
    }
    
    func updateType(_ newType:String) {
        self.type = newType
        if newType == "none" {
            self.isHidden = true
            self.label.isHidden = true
        } else {
            self.isHidden = false
            self.label.isHidden = false
        }
        self.label.text = TYPES[newType]?["icon"] as? String
        let colors = TYPES[newType]?["color"] as? [String]
        self.label.fontColor = hex(colors![rand(0, (colors?.count)!)])
        let bkColors = TYPES[newType]?["background"] as? [String]
        self.color = hex(bkColors![rand(0, (bkColors?.count)!)])
    }
}
