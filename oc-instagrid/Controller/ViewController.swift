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
    
    // Add tapped view
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
        super.viewDidAppear(true)
        
        checkOrientation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap gesture recognizer for the 4 UIImageView
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
    
    //
    @objc private func didSwipeView(_ gesture: UISwipeGestureRecognizer) {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let translationTransform: CGAffineTransform
        
        if gesture.direction == .up {
            translationTransform = CGAffineTransform(translationX: 0, y: -screenHeight)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.pictureView.transform = translationTransform
            self.swipeLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.iconSwipe.transform = CGAffineTransform(scaleX: 0, y: 0)
        }) { (succes) in
            if succes {
                self.convertAndShareView()
            }
        }
    }
    
    private func convertAndShareView() {
        
        // image to share
        let image = pictureView.asImage()
        
        // set up activity view controller
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        // exclude some activity types from the list
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.openInIBooks ]
        
        // Did share or cancel
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            self.showPictureView()
        }
        
        // Present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        
        
    }
    
    private func showPictureView(){
        pictureView.transform = .identity
        pictureView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.pictureView.transform = .identity
            self.swipeLabel.transform = .identity
            self.iconSwipe.transform = .identity
            if UIDevice.current.orientation.isLandscape {
                self.iconSwipe.transform = CGAffineTransform(rotationAngle: (-CGFloat.pi/2))
            }
        }, completion: nil)
    }
}





// MARK: - Landscape orentation
extension ViewController {
    
    // Detect the device change orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Check orientation
        checkOrientation()
    }
    
    // Check the current view orientation
    private func checkOrientation() {
        // Add swipe gesture
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeView(_:)))
        
        if UIDevice.current.orientation.isLandscape {
            swipeLabel.text = "Swipe left to share"
            iconSwipe.transform = CGAffineTransform(rotationAngle: (-CGFloat.pi/2))
            swipe.direction = .left
        } else {
            swipeLabel.text = "Swipe up to share"
            iconSwipe.transform = CGAffineTransform(rotationAngle: 0.0)
            swipe.direction = .up
        }
        
        pictureView.addGestureRecognizer(swipe)
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
