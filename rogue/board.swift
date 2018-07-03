//
//  board.swift
//  rogue
//
//  Created by rafael de los santos on 6/19/18.
//  Copyright © 2018 rafael de los santos. All rights reserved.
//

import Foundation

class Board {
    var tiles:[[Int]] = [[Int]]()
    var rooms:[Room] = [Room]()
    
    init() {
        self.tiles = Array(repeating: Array(repeating: 0, count: X_MAX), count: Y_MAX)
        
        self.addRoom()
    }
    
    func addRoom() {
        var numTries = 20
        while numTries > 0 {
            numTries -= 1
            let roomType = "square"
            var r = Room(roomType)
            
            if self.rooms.count == 0 {
                numTries = 0
                let randX = rand(0, X_MAX - r.w)
                let randY = rand(0, Y_MAX - r.h)
                for j in 0..<r.h {
                    for i in 0..<r.w {
                        self.tiles[randY + j][randX + i] = r.tiles[j][i]
                    }
                }
                self.rooms.append(r)
            }
        }
    }
}
