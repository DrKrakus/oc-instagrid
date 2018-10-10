//
//  pictureView.swift
//  oc-instagrid
//
//  Created by Jerome Krakus on 01/10/2018.
//  Copyright © 2018 Jerome Krakus. All rights reserved.
//

import UIKit

class PictureView: UIView {

    // Connecting views
    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var bottomRightImageView: UIImageView!
    
    // Enum for the layout style
    enum LayoutStyle {
        case layout1, layout2, layout3
    }
    
    var style: LayoutStyle = .layout3 {
        didSet {
            changeStyle(style)
        }
    }
    
    private func changeStyle(_ style: LayoutStyle) {
        
        switch style {
        case .layout1:
            topRightImageView.isHidden = true
            bottomRightImageView.isHidden = false
        case .layout2:
            topRightImageView.isHidden = false
            bottomRightImageView.isHidden = true
        case .layout3:
            topRightImageView.isHidden = false
            bottomRightImageView.isHidden = false
        }
    }
}

// Converting as image
extension PictureView {
    
    func asImage() -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image(actions: { rendererContext in
            layer.render(in: rendererContext.cgContext)
        })
    }
}

// Add shadow settings to the interface builder
extension PictureView {
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
