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
let LARGE_BLOB_CHANCE = 50

let HOLE_CHANCE = 10
let BRIDGE_CHANCE = 10

let NUM_CYCLES = 20

class Board {
    var tiles:[[Int]] = [[Int]]()
    var rooms:[Room] = [Room]()
    
    init() {
        self.tiles = Array(repeating: Array(repeating: 0, count: X_MAX), count: Y_MAX)
        
        var rounds = NUM_CYCLES
        while rounds > 0 {
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
        
        self.removeBadDoors()
        self.addHoles()
        self.addDoubleHoles()
        self.addBridges()
        
        //call these at the end
        self.fixBadDoors()
        self.fixBrokenWalls()
    }
    
    func addRoom(_ roomType:String) {
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
                numTries = 0
                foundSpace = true
                for k in r.doors {
                    r.tiles[k.0][k.1] = 3
                }
            }
        }
        return foundSpace
    }
    
    func getSurroundingDoors(_ j:Int, _ i:Int) -> Int {
        let jMin = (j > 0) ? -1 : 0
        let jMax = (j < Y_MAX - 1) ? 1 : 0
        let iMin = (i > 0) ? -1 : 0
        let iMax = (i < X_MAX - 1) ? 1 : 0
        
        var n = 0
        for jj in jMin...jMax {
            for ii in iMin...iMax {
                if !(jj == -1 && ii == -1) && !(jj == 1 && ii == -1) && !(jj == -1 && ii == 1) && !(jj == 1 && ii == 1) {
                    if self.tiles[jj + j][ii + i] == 3 && !(jj == 0 && ii == 0) {
                        n += 1
                    }
                }
            }
        }
        return n
    }
    
    func removeBadDoors() {
        for j in 0..<Y_MAX {
            for i in 0..<X_MAX {
                if self.tiles[j][i] == 3 && getSurroundingStrict(j, i, Y_MAX, X_MAX, self.tiles) != 2 {
                    self.tiles[j][i] = 2
                }
            }
        }
    }
    
    func fixBadDoors() {
        for j in 0..<Y_MAX {
            for i in 0..<X_MAX {
                if self.tiles[j][i] == 3 && getSurroundingStrict(j, i, Y_MAX, X_MAX, self.tiles) != 2 {
                    self.tiles[j][i] = 1
                }
            }
        }
    }
    
    func addHoles() {
        for j in 1..<(Y_MAX - 1) {
            for i in 1..<(X_MAX - 1) {
                if self.tiles[j][i] == 2 && self.getSurroundingDoors(j, i) == 0 {
                    // vertical
                    if self.tiles[j - 1][i] == 1 && self.tiles[j + 1][i] == 1 && chance() < HOLE_CHANCE {
                        self.tiles[j][i] = 1
                    }
                    // horizontal
                    if self.tiles[j][i - 1] == 1 && self.tiles[j][i + 1] == 1 && chance() < HOLE_CHANCE {
                        self.tiles[j][i] = 1
                    }
                }
            }
        }
    }
    
    func addDoubleHoles() {
        for j in 1..<(Y_MAX - 4) {
            for i in 1..<(X_MAX - 4) {
                if self.tiles[j][i] == 1 {
                    // vertical
                    if self.tiles[j + 1][i] == 2 && self.tiles[j + 2][i] == 2 && self.tiles[j + 3][i] == 1 && chance() < HOLE_CHANCE {
                        self.tiles[j + 1][i] = 1
                        self.tiles[j + 2][i] = 1
                    }
                    // horizontal
                    if self.tiles[j][i + 1] == 2 && self.tiles[j][i + 2] == 2 && self.tiles[j][i + 3] == 1 && chance() < HOLE_CHANCE {
                        self.tiles[j][i + 1] = 1
                        self.tiles[j][i + 2] = 1
                    }
                }
            }
        }
    }
    
    func addBridges() {
        //HORIZONTAL BRIDGES
        for j in 0..<Y_MAX {
            var currentBridge:[(Int, Int)] = [(Int, Int)]()
            for i in 0..<(X_MAX - 2) {
                if self.tiles[j][i] == 1 && self.tiles[j][i + 1] == 2 && self.tiles[j][i + 2] == 0 {
                    var ii = i + 1
                    var makeBridge = true
                    var foundBridge = false
                    while ii < X_MAX - 2 && makeBridge {
                        currentBridge.append((j, ii))
                        if self.tiles[j][ii] == 2 && self.tiles[j][ii + 1] == 1 {
                            makeBridge = false
                            foundBridge = true
                        }
                        ii += 1
                    }
                    if foundBridge && chance() < BRIDGE_CHANCE {
                        for k in currentBridge {
                            if self.tiles[k.0 - 1][k.1] != 3 {
                                self.tiles[k.0 - 1][k.1] = 2
                            }
                            self.tiles[k.0][k.1] = 1
                            if self.tiles[k.0 + 1][k.1] != 3 {
                                self.tiles[k.0 + 1][k.1] = 2
                            }
                        }
                        currentBridge = [(Int, Int)]()
                    }
                }
            }
        }
        //VERTICAL BRIDGES
        for i in 0..<X_MAX {
            var currentBridge:[(Int, Int)] = [(Int, Int)]()
            for j in 0..<(Y_MAX - 2) {
                if self.tiles[j][i] == 1 && self.tiles[j + 1][i] == 2 && self.tiles[j + 2][i] == 0 {
                    var jj = j + 1
                    var makeBridge = true
                    var foundBridge = false
                    while jj < Y_MAX - 2 && makeBridge {
                        currentBridge.append((jj, i))
                        if self.tiles[jj][i] == 2 && self.tiles[jj + 1][i] == 1 {
                            makeBridge = false
                            foundBridge = true
                        }
                        jj += 1
                    }
                    if foundBridge && chance() < BRIDGE_CHANCE {
                        for k in currentBridge {
                            if self.tiles[k.0][k.1 - 1] != 3 {
                                self.tiles[k.0][k.1 - 1] = 2
                            }
                            self.tiles[k.0][k.1] = 1
                            if self.tiles[k.0][k.1 + 1] != 3 {
                                self.tiles[k.0][k.1 + 1] = 2
                            }
                        }
                        currentBridge = [(Int, Int)]()
                    }
                }
            }
        }
    }
    
    func fixBrokenWalls() {
        for j in 1..<(X_MAX - 1) {
            for i in 1..<(Y_MAX - 1) {
                if self.tiles[j][i] == 0 && getSurroundingStrict(j, i, Y_MAX, X_MAX, self.tiles) != 0 {
                    self.tiles[j][i] = 2
                }
            }
        }
    }
}
