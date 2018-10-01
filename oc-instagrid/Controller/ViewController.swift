//
//  ViewController.swift
//  oc-instagrid
//
//  Created by Jerome Krakus on 14/09/2018.
//  Copyright © 2018 Jerome Krakus. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var buttonCenter: UIButton!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var topLeftImageView: UIImageView!
    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var bottomLeftImageView: UIImageView!
    @IBOutlet weak var bottomRightImageView: UIImageView!
    
    
    @IBAction func didTapeButton(_ sender: UIButton) {
        
        /// Reset button style
        buttonRight.isSelected = false
        buttonCenter.isSelected = false
        buttonLeft.isSelected = false
        
        // Add selected style to the sender
        sender.isSelected = true
        
        // Then change style of the pictureView
        changeStyle(sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func changeStyle(_ button: UIButton) {
        
        // Change and anime style
        UIView.animate(withDuration: 0.2) {
            if button == self.buttonLeft {
                self.topRightImageView.isHidden = true
                self.bottomRightImageView.isHidden = false
            } else if button == self.buttonCenter {
                self.topRightImageView.isHidden = false
                self.bottomRightImageView.isHidden = true
            } else if button == self.buttonRight {
                self.topRightImageView.isHidden = false
                self.bottomRightImageView.isHidden = false
            }
        }
    }
    
}

extension ViewController {
    
}
