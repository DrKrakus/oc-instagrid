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
    
    // Notifies the view controller that its view was added to a view hierarchy.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // Check the device current orientation
        checkOrientation()
    }
    
    // Called after the controller's view is loaded into memory.
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
    
    // Tells the receiver that a motion event has ended.
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        // Check the type of motion event
        guard motion == .motionShake else { return }
        
        // Switch the theme
        themeView.theme = themeView.theme.toggleTheme
    }
    
    /// One UIButton has been tapped
    ///
    /// - parameter sender: the UIButton tapped
    @IBAction func didTapeButton(_ sender: UIButton) {
        
        // Reset all the buttons isselected style
        buttonRight.isSelected = false
        buttonCenter.isSelected = false
        buttonLeft.isSelected = false
        
        // Add isselected style to the sender
        sender.isSelected = true
        
        // Then change the style of the pictureView
        changeStyle(sender)
    }
    
    /// Change the pictureView layout style
    ///
    /// - parameter button: UIButton tapped
    private func changeStyle(_ button: UIButton) {
        
        // Animate the layout change
        UIView.animate(withDuration: 0.1) {
            
            // Change the layout according to the button tapped
            if button == self.buttonLeft {
                self.pictureView.style = .layout1
            } else if button == self.buttonCenter {
                self.pictureView.style = .layout2
            } else if button == self.buttonRight {
                self.pictureView.style = .layout3
            }
        }
    }
    
    /// The pictureView has been swiped
    ///
    /// - parameter gesture: UISwipeGesturerecognizer
    @objc private func didSwipeView(_ gesture: UISwipeGestureRecognizer) {
        
        // Create constants for the heigh and width of the screen
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        // Declare a CGAffineTranform
        let translationTransform: CGAffineTransform
        
        // Set the translationTransform according to the swipe gesture direction
        if gesture.direction == .up {
            translationTransform = CGAffineTransform(translationX: 0, y: -screenHeight)
        } else {
            translationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        }
        
        // Animate the pictureView transform
        UIView.animate(withDuration: 0.2, animations: {
            self.pictureView.transform = translationTransform
            self.swipeLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.iconSwipe.transform = CGAffineTransform(scaleX: 0, y: 0)
        }) { (succes) in
            // If the animation is succes, play convertAndShareView func
            if succes {
                self.convertAndShareView()
            }
        }
    }
    
    /// Convert the PictureView to an image and share it
    private func convertAndShareView() {
        
        // Image to share
        let image = pictureView.asImage()
        let imageToShare = [image]
        
        // Set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        
        // Exclude some activity types from the list
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.openInIBooks ]
        
        // Did share or cancel
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            // Play showPictureView func
            self.showPictureView()
        }
        
        // Present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    /// PictureView reappears
    private func showPictureView(){
        
        // Move the pictureView to her initial place
        pictureView.transform = .identity
        
        // Then scale her to 0
        pictureView.transform = CGAffineTransform(scaleX: 0, y: 0)
        
        // Animate the pictureView and the icon/label reappearance with a bounce effecte
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.pictureView.transform = .identity
            self.swipeLabel.transform = .identity
            self.iconSwipe.transform = .identity
            
            // Check the device current position for the orientation of the iconSwipe
            if UIDevice.current.orientation.isLandscape {
                self.iconSwipe.transform = CGAffineTransform(rotationAngle: (-CGFloat.pi/2))
            }
        })
    }
}

// MARK: - Landscape orentation
extension ViewController {
    
    // Notifies the container that the size of its view is about to change
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Check orientation
        checkOrientation()
    }
    
    /// Check the device current orientation
    private func checkOrientation() {
        
        // Create the swipe gestures
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeView(_:)))
        
        // Changes according to the orientation
        if UIDevice.current.orientation.isLandscape {
            swipeLabel.text = "Swipe left to share"
            iconSwipe.transform = CGAffineTransform(rotationAngle: (-CGFloat.pi/2))
            swipe.direction = .left
        } else {
            swipeLabel.text = "Swipe up to share"
            iconSwipe.transform = CGAffineTransform(rotationAngle: 0.0)
            swipe.direction = .up
        }
        
        // Clean the previous gestures
        pictureView.gestureRecognizers?.forEach {
            pictureView.removeGestureRecognizer($0)
        }
        
        // Add the new gesture
        pictureView.addGestureRecognizer(swipe)
    }
}

// MARK: - Access to photo library
extension ViewController {
    
    /// One UIImageView has been tapped
    ///
    /// - parameter gesture: Tap gesture
    @objc private func didTapView(_ gesture: UITapGestureRecognizer){
        
        // Check the authorization for the photo library access
        checkAuthorization()
        
        // Check if the view tapped is an UIImageView
        guard let view = gesture.view as? UIImageView else { return }
        
        // Assign new value to viewTapped
        viewTapped = view
    }
    
    /// Tells the delegate that the user picked a still image.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Check if the image the user selected is an UIImage
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            // Change the image and content mode in viewTapped
            viewTapped!.contentMode = .scaleAspectFill
            viewTapped!.clipsToBounds = true
            viewTapped!.image = selectedImage
        }
        
        // Close the picker
        dismiss(animated: true)
    }
    
    /// Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Close the picker
        dismiss(animated: true)
    }
    
    /// Check the acces authorization to the photo library
    private func checkAuthorization() {
        
        PHPhotoLibrary.requestAuthorization { status in
            
            // Check the status of the authorization
            switch status{
            // if its authorized AND the photoLibrary is available
            case .authorized where UIImagePickerController.isSourceTypeAvailable(.photoLibrary):
                
                // Create an image picker
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                // Present the image picker
                DispatchQueue.main.async {
                    self.present(imagePicker, animated: true)
                }
                
            default:
                
                // Alert pop-up
                let alert = UIAlertController(title: "", message: "You've refused the access to your photo library, grant the access in your phone settings", preferredStyle: .alert)
                
                // Settings button
                let settings = UIAlertAction(title: "Settings", style: .default) { _ in
                    
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
                
                // Cancel button
                let cancel = UIAlertAction(title: "Cancel", style: .destructive)
                
                // Add the actions
                alert.addAction(cancel)
                alert.addAction(settings)
                
                // Show the alert
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
