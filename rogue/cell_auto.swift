//
//  cell_auto.swift
//  rogue
//
//  Created by rafael de los santos on 7/10/18.
//  Copyright © 2018 rafael de los santos. All rights reserved.
//

import Foundation

func cellAuto(_ c:Int, _ h:Int, _ w:Int, _ d:Int, _ b:Int, _ cy:Int) -> [[Int]] {
    // GENERATE RANDOM ARRAY
    var a = [[Int]]()
    for _ in 0..<h {
        var row = [Int]()
        for _ in 0..<w {
            row.append((chance() < c) ? 1 : 0)
        }
        a.append(row)
    }
    
    // RUN CELL AUTO A BUNCH
    var cc = cy
    while cc > 0 {
        cc -= 1
        var aa = a
        for j in 0..<h {
            for i in 0..<w {
                let n = getSurrounding(j, i, h, w, a)
                if a[j][i] == 1 && n <= d {
                    aa[j][i] = 0
                } else if a[j][i] == 0 && n >= b {
                    aa[j][i] = 1
                }
            }
        }
        a = aa
    }
    
    return a
}

func getSurrounding(_ j:Int, _ i:Int, _ h:Int, _ w:Int, _ a:[[Int]]) -> Int {
    let jMin = (j > 0) ? -1 : 0
    let jMax = (j < h - 1) ? 1 : 0
    let iMin = (i > 0) ? -1 : 0
    let iMax = (i < w - 1) ? 1 : 0
    
    var n = 0
    for jj in jMin...jMax {
        for ii in iMin...iMax {
            if a[jj + j][ii + i] == 1 && !(jj == 0 && ii == 0) {
                n += 1
            }
        }
    }
    return n
}
