//
// CloudEmitterView.swift
// Created by D.Pich based on view created with Particle Playground on 8/23/16
//

import UIKit

class CloudEmitterView: UIView {
    override class var layerClass: AnyClass {
        get {
            return CAEmitterLayer.self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = false
        
        let emitterLayer = layer as! CAEmitterLayer

        //setup layer
        emitterLayer.name = "emitterLayer"
        emitterLayer.emitterSize = CGSize(width: 1.00, height: 5000)
        emitterLayer.emitterDepth = 100.00
        emitterLayer.emitterShape = kCAEmitterLayerRectangle
        emitterLayer.emitterMode = kCAEmitterLayerOutline
        emitterLayer.seed = 2491098502
        
        // Create the emitter Cell
//        let emitterCell1 = createEmitterForClouds1()
        let emitterCell2  = createEmitterForClouds2()
        
        //assign the emitter to the layer
//        emitterLayer.emitterCells = [emitterCell1, emitterCell2]
        emitterLayer.emitterCells = [emitterCell2]
    }
    
    func createEmitterForClouds1() -> CAEmitterCell {
        // Create the emitter Cell
        let emitterCell = CAEmitterCell()
        emitterCell.name = "Clouds1"
        emitterCell.isEnabled = true
        
        let img = UIImage(named: "Clouds1")
        emitterCell.contents = img?.cgImage
        
        emitterCell.contentsRect = CGRect(x:0.00, y:0.00, width:3.00, height:1.00)
        
        emitterCell.magnificationFilter = kCAFilterLinear
        emitterCell.minificationFilter = kCAFilterLinear
        emitterCell.minificationFilterBias = 0.00
        
        emitterCell.scale = 0.3
        emitterCell.scaleRange = 0.2
        emitterCell.scaleSpeed = 0.1
        
        let color = UIColor(red:1, green:1, blue:1, alpha:1)
        emitterCell.color = color.cgColor
        emitterCell.redRange = 0.00
        emitterCell.greenRange = 0.00
        emitterCell.blueRange = 0.00
        emitterCell.alphaRange = 1.00
        
        emitterCell.redSpeed = 0.00
        emitterCell.greenSpeed = 0.00
        emitterCell.blueSpeed = 0.00
        emitterCell.alphaSpeed = 0.00
        
        emitterCell.lifetime = 500.00
        emitterCell.lifetimeRange = 0.00
        emitterCell.birthRate = 1
        emitterCell.velocity = 5.00
        emitterCell.velocityRange = 5.00
        emitterCell.xAcceleration = 1.00
        emitterCell.yAcceleration = 0.00
        emitterCell.zAcceleration = 0.00
        
        // these values are in radians, in the UI they are in degrees
        emitterCell.spin = 0.000
        emitterCell.spinRange = 0.000
        emitterCell.emissionLatitude = 0.017
        emitterCell.emissionLongitude = 0.017
        emitterCell.emissionRange = 1.745
        
        return emitterCell
    }

    func createEmitterForClouds2() -> CAEmitterCell {
        // Create the emitter Cell
        let emitterCell = CAEmitterCell()
        emitterCell.name = "Clouds2"
        emitterCell.isEnabled = true
        
        let img = UIImage(named: "Clouds2.png")
        emitterCell.contents = img?.cgImage
        emitterCell.contentsRect = CGRect(x:0.00, y:0.00, width:3.00, height:1.00)
        
        emitterCell.magnificationFilter = kCAFilterLinear
        emitterCell.minificationFilter = kCAFilterLinear
        emitterCell.minificationFilterBias = 0.00
        
        emitterCell.scale = 0.30
        emitterCell.scaleRange = 0.20
        emitterCell.scaleSpeed = 0.00
        
        let color = UIColor(red:1, green:1, blue:1, alpha:1)
        emitterCell.color = color.cgColor
        emitterCell.redRange = 0.00
        emitterCell.greenRange = 0.00
        emitterCell.blueRange = 0.00
        emitterCell.alphaRange = 1.00
        
        emitterCell.redSpeed = 0.00
        emitterCell.greenSpeed = 0.00
        emitterCell.blueSpeed = 0.00
        emitterCell.alphaSpeed = 0.00
        
        emitterCell.lifetime = 500.00
        emitterCell.lifetimeRange = 0.00
        emitterCell.birthRate = 1
        emitterCell.velocity = 5.00
        emitterCell.velocityRange = 5.00
        emitterCell.xAcceleration = 1.00
        emitterCell.yAcceleration = 0.00
        emitterCell.zAcceleration = 0.00
        
        // these values are in radians, in the UI they are in degrees
        emitterCell.spin = 0.000
        emitterCell.spinRange = 0.000
        emitterCell.emissionLatitude = 0.017
        emitterCell.emissionLongitude = 0.017
        emitterCell.emissionRange = 1.745
        
        return emitterCell
    }
}
