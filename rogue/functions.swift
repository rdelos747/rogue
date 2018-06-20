//
//  functions.swift
//  rogue
//
//  Created by rafael de los santos on 6/19/18.
//  Copyright © 2018 rafael de los santos. All rights reserved.
//

import Foundation
import SpriteKit

// ///////////////////////////////
// V A R S
// /////////////////////////////////////////////////////////////
// SIZES
let TILE_WIDTH = 20
let TILE_HEIGHT = 35
let TILE_LABEL_SIZE = 20

// COLORS

// ///////////////////////////////
// G L O B A L S
// /////////////////////////////////////////////////////////////
func hex(_ hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func chance(_ n:Int) -> Int {
    return Int(arc4random_uniform(100))
}

func rand(_ min:Int, _ max:Int) -> Int {
    return Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
}
