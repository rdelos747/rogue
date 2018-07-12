//
//  board.swift
//  rogue
//
//  Created by rafael de los santos on 6/19/18.
//  Copyright © 2018 rafael de los santos. All rights reserved.
//

import Foundation

let DOOR_CHANCE = 30
let SQUARE_CHANCE = 30
let LARGE_BLOB_CHANCE = -1
let NUM_CYCLES = 20

class Board {
    var tiles:[[Int]] = [[Int]]()
    var rooms:[Room] = [Room]()
    
    init() {
        self.tiles = Array(repeating: Array(repeating: 0, count: X_MAX), count: Y_MAX)
        
        var rounds = NUM_CYCLES
        while rounds > 0 {
            print("ROUND", rounds)
            if rounds == NUM_CYCLES {
                let c = chance()
                if c <= LARGE_BLOB_CHANCE {
                    self.addRoom("large blob")
                } else if c <= SQUARE_CHANCE {
                    self.addRoom("square")
                } else {
                    self.addRoom("blob")
                }
            } else {
                let c = chance()
                if c <= SQUARE_CHANCE {
                    self.addRoom("square")
                } else {
                    self.addRoom("blob")
                }
            }
            rounds -= 1
        }
    }
    
    func addRoom(_ roomType:String) {
        print(roomType)
        var numTries = 20
        while numTries > 0 {
            numTries -= 1
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
            } else if self.checkAvailable(r) {
                numTries = 0
                for j in 0..<r.h {
                    for i in 0..<r.w {
                        if self.tiles[r.originY + j][r.originX + i] != 2 || r.tiles[j][i] == 3 {
                            self.tiles[r.originY + j][r.originX + i] = r.tiles[j][i]
                        }
                    }
                }
                self.rooms.append(r)
            }
        }
    }
    
    func checkAvailable(_ r:Room) -> Bool {
        var numTries = 100
        var foundSpace = false
        outerLoop: while numTries > 0 {
            numTries -= 1
            r.originX = rand(0, X_MAX - r.w)
            r.originY = rand(0, Y_MAX - r.h)
            
            var goodSpace = true
            for j in 0..<r.h {
                for i in 0..<r.w {
                    if self.tiles[j + r.originY][i + r.originX] == 1 {
                        goodSpace = false
                        continue outerLoop
                    }
                }
            }
            
            var goodDoor = false
            for k in r.doors {
                let dy = r.originY + k.0
                let dx = r.originX + k.1
                if self.tiles[dy][dx] > 1 && getSurroundingStrict(dy, dx, Y_MAX, X_MAX, self.tiles) == 1 {
                    goodDoor = true
                }
            }
            
            if goodDoor == false {
                continue outerLoop
            }
            
            if goodSpace && goodDoor {
                print("======= here", 100 - numTries)
                numTries = 0
                foundSpace = true
                for k in r.doors {
                    r.tiles[k.0][k.1] = 3
                }
            }
        }
        return foundSpace
        
        /*
         Sometimes this will complete, but other time is wont, so start printing functions in ROOM
    */
    }
}
