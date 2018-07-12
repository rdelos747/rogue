//
//  room.swift
//  rogue
//
//  Created by rafael de los santos on 6/19/18.
//  Copyright © 2018 rafael de los santos. All rights reserved.
//

import Foundation

let SQUARE_MIN_SIZE = 4
let SQUARE_MAX_SIZE = 10

let BLOB_MIN_SIZE = 5
let BLOB_MAX_SIZE = 15
let LARGE_BLOB_MIN_SIZE = 15
let LARGE_BLOB_MAX_SIZE = 28

let CELL_CHANCE = 30
let NUM_CELL_AUTOS = 3
let MIN_BEST_LEN = 25

let BIRTH = 3
let DEATH = 1

let CORRIDOR_CHANCE = 30
let CORRIDOR_MIN = 4
let CORRIDOR_MAX = 10

class Room {
    var tiles:[[Int]] = [[Int]]()
    var found:[(Int, Int)] = [(Int, Int)]()
    var current:[(Int, Int)] = [(Int, Int)]()
    var best:[(Int, Int)] = [(Int, Int)]()
    var doors:[(Int, Int)] = [(Int, Int)]()
    var w:Int = 0
    var h:Int = 0
    var originX = 0
    var originY = 0
    
    init(_ roomType:String) {
        if roomType == "square" {
            self.generateSquare()
        } else if roomType == "blob" {
            self.generateBlob()
        } else if roomType == "large blob" {
            self.generateLargeBlob()
        }
        
        if chance() > CORRIDOR_CHANCE && roomType != "large blob" {
            self.addCorridor()
        }
        
        self.addWalls()
        self.addDoors()
    }
    
    func printTiles() {
        for j in self.tiles {
            print(j)
        }
    }
    
    func generateSquare() {
        self.w = rand(SQUARE_MIN_SIZE, SQUARE_MAX_SIZE)
        self.h = rand(SQUARE_MIN_SIZE, SQUARE_MAX_SIZE)
        
        for j in 0..<self.h {
            var row = [Int]()
            for i in 0..<self.w {
                if j == 0 || j == self.h - 1 || i == 0 || i == self.w - 1 {
                    row.append(0)
                } else {
                    row.append(1)
                }
            }
            self.tiles.append(row)
        }
    }
    
    func generateBlob() {
        var createBetterBlob = true
        while createBetterBlob {
            self.w = rand(BLOB_MIN_SIZE, BLOB_MAX_SIZE)
            self.h = rand(BLOB_MIN_SIZE, BLOB_MAX_SIZE)
            self.tiles = cellAuto(CELL_CHANCE, self.h, self.w, DEATH, BIRTH, NUM_CELL_AUTOS)
            createBetterBlob = (self.findLargestBlob() < MIN_BEST_LEN)
        }
    }
    
    func generateLargeBlob() {
        var createBetterBlob = true
        while createBetterBlob {
            self.w = rand(LARGE_BLOB_MIN_SIZE, LARGE_BLOB_MAX_SIZE)
            self.h = rand(LARGE_BLOB_MIN_SIZE, LARGE_BLOB_MAX_SIZE)
            self.tiles = cellAuto(CELL_CHANCE, self.h, self.w, DEATH, BIRTH, NUM_CELL_AUTOS)
            createBetterBlob = (self.findLargestBlob() < MIN_BEST_LEN)
        }
    }
    
    func findLargestBlob() -> Int {
        for j in 0..<self.h {
            for i in 0..<self.w {
                if self.tiles[j][i] == 1 && !self.found.contains(where: {$0 == (j, i)}) {
                    self.getSurroundingRecusion(j, i)
                    if self.current.count > self.best.count {
                        self.best = self.current
                    }
                    self.current = [(Int, Int)]()
                }
            }
        }
        
        if self.best.count == 0 {
            return 0
        }
        
        var newMaxH = 0
        var newMaxW = 0
        var newMinH = self.h
        var newMinW = self.w
        for i in 0..<self.best.count {
            if self.best[i].0 > newMaxH {
                newMaxH = self.best[i].0
            }
            if self.best[i].1 > newMaxW {
                newMaxW = self.best[i].1
            }
            if self.best[i].0 < newMinH {
                newMinH = self.best[i].0
            }
            if self.best[i].1 < newMinW {
                newMinW = self.best[i].1
            }
        }
    
        self.h = (newMaxH - newMinH) + 3
        self.w = (newMaxW - newMinW) + 3
        var a = Array(repeating: Array(repeating: 0, count: self.w), count: self.h)
        for i in 0..<self.best.count {
            // god i hope this works
            a[self.best[i].0 - (newMinH - 1)][self.best[i].1 - (newMinW - 1)] = 1
        }
        
        self.tiles = a
        return self.best.count
    }
                
    func getSurroundingRecusion(_ j:Int, _ i:Int) {
        let jMin = (j > 0) ? -1 : 0
        let jMax = (j < self.h - 1) ? 1 : 0
        let iMin = (i > 0) ? -1 : 0
        let iMax = (i < self.w - 1) ? 1 : 0
        
        self.found.append((j, i))
        self.current.append((j, i))
        
        for jj in jMin...jMax {
            for ii in iMin...iMax {
                if !(jj == -1 && ii == -1) && !(jj == 1 && ii == -1) && !(jj == -1 && ii == 1) && !(jj == 1 && ii == 1) {
                    if self.tiles[jj + j][ii + i] == 1 && !self.found.contains(where: {$0 == (jj + j, ii + i)}) {
                        self.getSurroundingRecusion(jj + j, ii + i)
                    }
                }
            }
        }
    }
    
    func addCorridor() {
        let randSize = rand(CORRIDOR_MIN, CORRIDOR_MAX)
        let cDir = rand(0, 3)
        
        var a:[[Int]] = [[Int]]()
        if cDir == 0 { //up
            a = Array(repeating: Array(repeating: 0, count: self.w), count: self.h + randSize)
            for j in 0..<self.h {
                for i in 0..<self.w {
                    a[j + randSize][i] = self.tiles[j][i]
                }
            }
            self.h = self.h + randSize
            var searching = true
            var randX = 0
            while searching {
                randX = rand(1, self.w - 2)
                if a[randSize + 2][randX] == 1 {
                    searching = false
                }
            }
            a[randSize][randX] = 3
            for j in 1..<randSize {
                a[j][randX] = 1
            }
        }
        else if cDir == 1 { //down
            a = Array(repeating: Array(repeating: 0, count: self.w), count: self.h + randSize)
            for j in 0..<self.h {
                for i in 0..<self.w {
                    a[j][i] = self.tiles[j][i]
                }
            }
            var searching = true
            var randX = 0
            while searching {
                randX = rand(1, self.w - 2)
                if a[self.h - 2][randX] == 1 {
                    searching = false
                }
            }
            a[self.h - 1][randX] = 3
            for j in self.h..<(self.h + randSize) - 1 {
                a[j][randX] = 1
            }
            self.h = self.h + randSize
        }
        else if cDir == 2 { //left
            a = Array(repeating: Array(repeating: 0, count: self.w + randSize), count: self.h)
            for j in 0..<self.h {
                for i in 0..<self.w {
                    a[j][i + randSize] = self.tiles[j][i]
                }
            }
            self.w = self.w + randSize
            var searching = true
            var randY = 0
            while searching {
                randY = rand(1, self.h - 2)
                if a[randY][randSize + 2] == 1 {
                    searching = false
                }
            }
            a[randY][randSize] = 3
            for i in 1..<randSize {
                a[randY][i] = 1
            }
        }
        else if cDir == 3 { //right
            a = Array(repeating: Array(repeating: 0, count: self.w + randSize), count: self.h)
            for j in 0..<self.h {
                for i in 0..<self.w {
                    a[j][i] = self.tiles[j][i]
                }
            }
            var searching = true
            var randY = 0
            while searching {
                randY = rand(1, self.h - 2)
                if a[randY][self.w - 2] == 1 {
                    searching = false
                }
            }
            a[randY][self.w - 1] = 3
            for i in self.w..<(self.w + randSize) - 1 {
                a[randY][i] = 1
            }
            self.w = self.w + randSize
        }
        
        self.tiles = a
    }
    
    func addWalls() {
        for j in 0..<self.h {
            for i in 0..<self.w {
                if self.tiles[j][i] == 0 && getSurrounding(j, i, self.h, self.w, self.tiles) > 0 {
                    self.tiles[j][i] = 2
                }
            }
        }
    }
    
    func addDoors() {
        var topDoor = 20
        while topDoor > 0 {
            topDoor -= 1
            let randX = rand(0, self.w - 1)
            let randY = 0
            if self.tiles[randY][randX] == 2 && self.tiles[randY + 1][randX] == 1 {
                self.doors.append((randY, randX))
                topDoor = 0
            }
        }
        
        var botDoor = 20
        while botDoor > 0 {
            botDoor -= 1
            let randX = rand(0, self.w - 1)
            let randY = self.h - 1
            if self.tiles[randY][randX] == 2 && self.tiles[randY - 1][randX] == 1 {
                self.doors.append((randY, randX))
                botDoor = 0
            }
        }
        
        var rightDoor = 20
        while rightDoor > 0 {
            rightDoor -= 1
            let randX = self.w - 1
            let randY = rand(0, self.h - 1)
            if self.tiles[randY][randX] == 2 && self.tiles[randY][randX - 1] == 1 {
                self.doors.append((randY, randX))
                rightDoor = 0
            }
        }
        
        var leftDoor = 20
        while leftDoor > 0 {
            leftDoor -= 1
            let randX = 0
            let randY = rand(0, self.h - 1)
            if self.tiles[randY][randX] == 2 && self.tiles[randY][randX + 1] == 1 {
                self.doors.append((randY, randX))
                leftDoor = 0
            }
        }
    }
}
