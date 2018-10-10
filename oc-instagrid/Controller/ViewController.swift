//
//  ViewController.swift
//  oc-instagrid
//
//  Created by Jerome Krakus on 14/09/2018.
//  Copyright © 2018 Jerome Krakus. All rights reserved.
//

import UIKit
import Photos


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Set the light status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Connecting the storyboard items
    @IBOutlet var themeView: Theme!
    @IBOutlet weak var iconSwipe: UIImageView!
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var buttonCenter: UIButton!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var pictureView: PictureView!
    @IBOutlet weak var topLeftImageView: UIImageView!
    @IBOutlet weak var topRightImageView: UIImageView!
    @IBOutlet weak var bottomLeftImageView: UIImageView!
    @IBOutlet weak var bottomRightImageView: UIImageView!
    
    // Add tapped view
    var viewTapped: UIImageView?
    var customThemeActive = false
    
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
        
        // Check the device current orientation
        checkOrientation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and add tap gesture recognizer for the 4 UIImageView
        let tapTopLeft = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        let tapTopRight = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        let tapBottomRight = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        let tapBottomLeft = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        topLeftImageView.addGestureRecognizer(tapTopLeft)
        topRightImageView.addGestureRecognizer(tapTopRight)
        bottomRightImageView.addGestureRecognizer(tapBottomRight)
        bottomLeftImageView.addGestureRecognizer(tapBottomLeft)
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        guard motion == .motionShake else { return }
        
        if customThemeActive {
            themeView.theme = .classic
            customThemeActive = false
        } else {
            themeView.theme = .custom
            customThemeActive = true
        }
    }
    
    // Change layout style
    private func changeStyle(_ button: UIButton) {
        
        UIView.animate(withDuration: 0.1) {
            if button == self.buttonLeft {
                self.pictureView.style = .layout1
            } else if button == self.buttonCenter {
                self.pictureView.style = .layout2
            } else if button == self.buttonRight {
                self.pictureView.style = .layout3
            }
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
        })
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
        // Create the swipe gestures
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeView(_:)))
        
        // Orientation changes
        if UIDevice.current.orientation.isLandscape {
            swipeLabel.text = "Swipe left to share"
            iconSwipe.transform = CGAffineTransform(rotationAngle: (-CGFloat.pi/2))
            swipe.direction = .left
        } else {
            swipeLabel.text = "Swipe up to share"
            iconSwipe.transform = CGAffineTransform(rotationAngle: 0.0)
            swipe.direction = .up
        }
        
        // Clean
        pictureView.gestureRecognizers?.forEach {
            pictureView.removeGestureRecognizer($0)
        }
        
        // Add
        pictureView.addGestureRecognizer(swipe)
    }
}

// MARK: - Acces to photo library
extension ViewController {
    
    @objc private func didTapView(_ gesture: UITapGestureRecognizer){
        
        // Check the acces authorization to the photo library
        PHPhotoLibrary.requestAuthorization { status in
            
            switch status{
            case .authorized where UIImagePickerController.isSourceTypeAvailable(.photoLibrary):
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true)
            default:
                // Alert pop-up
                let alert = UIAlertController(title: "", message: "You've refused the acces to your photo library, grant the acces in your phone settings", preferredStyle: .alert)
                
                // Settings button
                let settings = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    
                    guard let settingsUrl = URL(string:UIApplication.openSettingsURLString) else { return }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                
                // Cancel button
                let cancel = UIAlertAction(title: "Cancel", style: .destructive)
                
                // Add the actions
                alert.addAction(settings)
                alert.addAction(cancel)
                
                // Show the alert
                self.present(alert, animated: true)
            }
        }
        
        guard let view = gesture.view as? UIImageView else { return }
        
        viewTapped = view
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            viewTapped!.contentMode = .scaleAspectFill
            viewTapped!.clipsToBounds = true
            viewTapped!.image = selectedImage
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true)
    }
}
