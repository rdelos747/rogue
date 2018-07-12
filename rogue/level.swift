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
    
    init(_ scene:GameScene, _ newTiles:[[Int]]) {
        self.scene = scene
        self.tiles = [[Tile]]()
        for j in 0..<Y_MAX {
            var row = [Tile]()
            for i in 0..<X_MAX {
                let t = Tile(j, i, "none")
                if newTiles[j][i] == 0 {
                    t.updateType("none")
                } else if newTiles[j][i] == 1 {
                    t.updateType("floor")
                } else if newTiles[j][i] == 2 {
                    t.updateType("wall")
                } else if newTiles[j][i] == 3 {
                    t.updateType("door")
                }
                row.append(t)
                
                if t.type != "none" {
                    scene.addChild(t)
                }
            }
            self.tiles.append(row)
        }
    }
    
//    func initTiles(_ newTiles:[[Int]]) {
//        for j in 0..<Y_MAX {
//            for i in 0..<X_MAX {
//                if newTiles[j][i] == 0 {
//                    self.tiles[j][i].updateType("none")
//                } else if newTiles[j][i] == 1 {
//                    self.tiles[j][i].updateType("floor")
//                } else if newTiles[j][i] == 2 {
//                    self.tiles[j][i].updateType("wall")
//                } else if newTiles[j][i] == 3 {
//                    self.tiles[j][i].updateType("door")
//                }
//            }
//        }
//    }
}
