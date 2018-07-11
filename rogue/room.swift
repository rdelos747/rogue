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

let CELL_CHANCE = 30
let NUM_CELL_AUTOS = 3
let MIN_BEST_LEN = 25

let BIRTH = 3
let DEATH = 1

class Room {
    var tiles:[[Int]] = [[Int]]()
    var found:[(Int, Int)] = [(Int, Int)]()
    var current:[(Int, Int)] = [(Int, Int)]()
    var best:[(Int, Int)] = [(Int, Int)]()
    var w:Int = 0
    var h:Int = 0
    
    init(_ roomType:String) {
        if roomType == "square" {
            self.generateSquare()
        } else if roomType == "blob" {
            self.generateBlob()
        } else if roomType == "large blob" {
            self.generateLargeBlob()
        }
        
        self.addWalls()
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
            self.printTiles()
            createBetterBlob = (self.findLargestBlob() < MIN_BEST_LEN)
            self.printTiles()
        }
    }
    
    func generateLargeBlob() {
        
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
    
    func addWalls() {
        // surround the room with 0s first
        let newWidth = self.w + 2
        let newHeight = self.h + 2
        var a = Array(repeating: Array(repeating: 0, count: newWidth), count: newHeight)
        for j in 0..<self.h {
            for i in 0..<self.w {
                a[j + 1][i + 1] = self.tiles[j][i]
            }
        }
        
        var a2 = a
        for j in 0..<newHeight {
            for i in 0..<newWidth {
                if a[j][i] == 0 && getSurrounding(j, i, newHeight, newWidth, a) > 0 {
                    a2[j][i] = 2
                }
            }
        }
        self.w = newWidth
        self.h = newHeight
        self.tiles = a2
    }
}
