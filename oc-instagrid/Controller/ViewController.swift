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
    @IBOutlet weak var topLeftImageView: UIImageView!
    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var bottomLeftImageView: UIImageView!
    @IBOutlet weak var bottomRightImageView: UIImageView!
    
    var uiViewTapped: UIImageView?
    
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
        super.viewDidAppear(false)
        
        checkOrientation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add gesture recognizer for the 4 UIImageView
        let tapTopLeft = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        topLeftImageView.addGestureRecognizer(tapTopLeft)
        let tapTopRight = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        topRightImageView.addGestureRecognizer(tapTopRight)
        let tapBottomRight = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        bottomRightImageView.addGestureRecognizer(tapBottomRight)
        let tapBottomLeft = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        bottomLeftImageView.addGestureRecognizer(tapBottomLeft)
        
    }
    
    // Change layout style
    private func changeStyle(_ button: UIButton) {
        
        if button == self.buttonLeft {
            self.pictureView.style = .layout1
        } else if button == self.buttonCenter {
            self.pictureView.style = .layout2
        } else if button == self.buttonRight {
            self.pictureView.style = .layout3
        }
    }
}

// MARK: - Landscape orentation
extension ViewController {
    
    // Detect the device change orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        checkOrientation()
    }
    
    // Check the current view orientation
    private func checkOrientation() {
        
        if UIDevice.current.orientation.isLandscape {
            swipeLabel.text = "Swipe left to share"
            iconSwipe.transform = CGAffineTransform(rotationAngle: (-CGFloat.pi/2))
        } else {
            swipeLabel.text = "Swipe up to share"
            iconSwipe.transform = CGAffineTransform(rotationAngle: 0.0)
        }
    }
}

//// MARK: - Acces to photo library
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc private func didTapView(_ gesture: UITapGestureRecognizer){
        
        guard let view = gesture.view as? UIImageView else { return }
        
        uiViewTapped = view
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uiViewTapped!.image = selectedImage
            uiViewTapped!.contentMode = .scaleAspectFill
            uiViewTapped!.clipsToBounds = true
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
