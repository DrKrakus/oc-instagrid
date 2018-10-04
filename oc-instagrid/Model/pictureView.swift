//
//  pictureView.swift
//  oc-instagrid
//
//  Created by Jerome Krakus on 01/10/2018.
//  Copyright © 2018 Jerome Krakus. All rights reserved.
//

import UIKit

class pictureView: UIView {

    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var bottomRightImageView: UIImageView!
    
    var style: LayoutStyle = .layout3 {
        didSet {
            changeStyle(style)
        }
    }
    
    enum LayoutStyle {
        case layout1, layout2, layout3
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
extension pictureView {
    
    func asImage() -> UIImage {
        
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image(actions: { rendererContext in
            layer.render(in: rendererContext.cgContext)
        })
    }
}
