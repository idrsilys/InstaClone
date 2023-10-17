//
//  ViewController.swift
//  InstaCloneFirebase
//
//  Created by Edris ILYAS on 3.09.2023.
//

import UIKit
import Firebase




class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passswprdText: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != ""  && passswprdText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passswprdText.text!){ (authdata,error) in
                if error != nil {
                    self.makeAlert(titleInput: "Error !!!", messageInput: error?.localizedDescription ?? "Yanlış Ulan !!")
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
            
            
        }else {
            makeAlert(titleInput: "Error !!", messageInput: "Username/Password ?????")
        }
 
        
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passswprdText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passswprdText.text!) { (authdata, error) in
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error !!!", messageInput: error?.localizedDescription ?? "Yanlış Ulan !!")
                    
                    
                }else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
            
        }else {
           
              makeAlert(titleInput: "Error !!", messageInput: "Username/Password ???")
            
        }
        
        
    }
    
    func makeAlert(titleInput:String, messageInput:String ){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    
    
}

