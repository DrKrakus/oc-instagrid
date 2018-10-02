//
//  ViewController.swift
//  oc-instagrid
//
//  Created by Jerome Krakus on 14/09/2018.
//  Copyright © 2018 Jerome Krakus. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iconSwipe: UIImageView!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var buttonCenter: UIButton!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var pictureView: pictureView!
    
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        checkOrientation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func changeStyle(_ button: UIButton) {
        
        // Change and anime style
        UIView.animate(withDuration: 0.2) {
            if button == self.buttonLeft {
                self.pictureView.style = .layout1
            } else if button == self.buttonCenter {
                self.pictureView.style = .layout2
            } else if button == self.buttonRight {
                self.pictureView.style = .layout3
            }
        }
    }
}

extension ViewController {
 
    // Landscape orientation change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        checkOrientation()
    }
    
    private func checkOrientation() {
        
        if UIDevice.current.orientation.isLandscape {
            swipeLabel.text = "Swipe left to share"
            iconSwipe.transform = CGAffineTransform(rotationAngle: -1.57079633)
        } else {
            swipeLabel.text = "Swipe up to share"
            iconSwipe.transform = CGAffineTransform(rotationAngle: 0.0)
        }
    }
}
