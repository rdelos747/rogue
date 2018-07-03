//
//  board.swift
//  rogue
//
//  Created by rafael de los santos on 6/19/18.
//  Copyright © 2018 rafael de los santos. All rights reserved.
//

import Foundation

class Board {
    var tiles:[[Int]]
    
    init() {
        self.tiles = Array(repeating: Array(repeating: 0, count: X_MAX), count: Y_MAX)
        
        
    }
}
