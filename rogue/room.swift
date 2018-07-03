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

class Room {
    var tiles:[[Int]] = [[Int]]()
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
        
    }
    
    func generateLargeBlob() {
        
    }
}
