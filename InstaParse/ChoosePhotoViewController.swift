//
//  ChoosePhotoViewController.swift
//  InstaParse
//
//  Created by David Melvin on 6/21/16.
//  Copyright © 2016 David Melvin. All rights reserved.
//

import UIKit


class ChoosePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectedImageOutlet: UIImageView!
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var captionField: UITextField!
    @IBOutlet weak var captionLabel: UILabel!
    
    var originalImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.captionField.hidden = true
        self.captionLabel.hidden = true
        self.postButton.hidden = true
        
    }
    
 
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.captionField.hidden = false
        self.captionLabel.hidden = false
        self.postButton.hidden = false
        
        // Get the image captured by the UIImagePickerController
        self.originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        //let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        selectedImageOutlet.image = originalImage
        
        
        
        
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func openPhotoLibrary(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)

    }
    
    @IBAction func useCamera(sender: AnyObject) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func postPhoto(sender: AnyObject) {
        //how do i pass it a photo?
        Post.postUserImage(self.originalImage, withCaption: self.captionField.text, withCompletion: nil)
        print("Image posted with caption \(self.captionField.text)")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
