//
//  camera.swift
//  rogue
//
//  Created by rafael de los santos on 6/19/18.
//  Copyright © 2018 rafael de los santos. All rights reserved.
//

import Foundation
import SpriteKit

class Camera {
    var cam:SKCameraNode
    var scene:GameScene
    var panGesture = UIPanGestureRecognizer()
    var pinchGesture = UIPinchGestureRecognizer()
    
    init(scene:GameScene) {
        self.scene = scene
        self.cam = SKCameraNode()
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.pan(sender:)))
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(sender:)))
        self.scene.view?.addGestureRecognizer(self.panGesture)
        self.scene.view?.addGestureRecognizer(self.pinchGesture)
    }
    
    @objc func pan(sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in: self.scene.view)
        self.cam.position = CGPoint(x:self.cam.position.x - translation.x, y:self.cam.position.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.scene.view)
        self.checkBounds()
    }
    
    @objc func pinch(sender:UIPinchGestureRecognizer) {
        self.cam.xScale += (1 - sender.scale) * 0.5
        self.cam.yScale += (1 - sender.scale) * 0.5
        print(self.cam.xScale)
        sender.scale = 1.0
        self.checkBounds()
    }
    
    func checkBounds() {
        if self.cam.xScale < 0.5 {
            self.cam.xScale = 0.5
            self.cam.yScale = 0.5
        } else if self.cam.xScale > 2 {
            self.cam.xScale = 2
            self.cam.yScale = 2
        }
    }
}
