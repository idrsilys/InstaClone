//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Edris ILYAS on 4.09.2023.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var coomentText: UITextField!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        

    }
    
    
    @objc func chooseImage() {
        
         let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(titleInput:String, messageInput:String ){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    
    
    
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            
            let uuid = UUID().uuidString
            
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data,metadata: nil) { ( metadata, error ) in
                if error != nil {
                    self.makeAlert(titleInput: "Error !", messageInput: error?.localizedDescription ?? "Errorzz")
                } else {
                    imageReferance.downloadURL { (url, error) in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                             // DATABAS
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl": imageUrl!, "postedBy": Auth.auth().currentUser!.email!, "postComment" : self.coomentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error !!", messageInput: error?.localizedDescription ?? "Error")
                                }else {
                                    
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.coomentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                                
                               
                            })
                            
                        }
                    }
                }
            }
        }
        
        
         
    }
    
    

}
