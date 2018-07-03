//
//  level.swift
//  rogue
//
//  Created by rafael de los santos on 7/2/18.
//  Copyright © 2018 rafael de los santos. All rights reserved.
//

import Foundation
import SpriteKit

class Level {
    var scene:GameScene
    var tiles:[[Tile]]
    
    init(_ scene:GameScene) {
        self.scene = scene
        self.tiles = [[Tile]]()
        for j in 0..<Y_MAX {
            var row = [Tile]()
            for i in 0..<X_MAX {
                let t = Tile(j, i, "none")
                scene.addChild(t)
                row.append(t)
            }
            self.tiles.append(row)
        }
    }
    
    func initTiles() {
        for j in 0..<Y_MAX {
            for i in 0..<X_MAX {
                if chance() < 10 {
                    self.tiles[j][i].updateType("wall")
                }
            }
        }
    }
}
