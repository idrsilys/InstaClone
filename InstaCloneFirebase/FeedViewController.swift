//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Edris ILYAS on 4.09.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var userImageArray = [String]()
    var likeArray = [Int]()
    var documentIDArray = [String]()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
        
        
        getDataFromFirebase()
    }
    
    
    func getDataFromFirebase(){
        
        let fireStoreDatabase = Firestore.firestore()
        // date ile ilgili hata gelirse ekleme yapılcak
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot,error) in
            if error != nil {
                print(error?.localizedDescription)
                   }else {
                           
                       if snapshot?.isEmpty != true {
                           
                           self.userEmailArray.removeAll(keepingCapacity: false)
                           self.userImageArray.removeAll(keepingCapacity: false)
                           self.userCommentArray.removeAll(keepingCapacity: false)
                           self.likeArray.removeAll(keepingCapacity: false)
                           self.documentIDArray.removeAll(keepingCapacity: false)
                           
                           
                           
                           for document in snapshot!.documents{
                               let documentID = document.documentID
                               self.documentIDArray.append(documentID)
                               
                               if let postedBy = document.get("postedBy") as? String {
                                   self.userEmailArray.append(postedBy)
                               }
                               
                               if let postComment = document.get("postComment") as? String {
                                   self.userCommentArray.append(postComment)
                               }
                               
                               if let imageUrl = document.get("imageUrl") as? String {
                                   self.userImageArray.append(imageUrl)
                               }
                               
                               if let likes = document.get("likes") as? Int {
                                   self.likeArray.append(likes)
                               }
                               
                           }
                           
                           self.tableView.reloadData()
                           
                           
                       }
                    
                    
                    
                    
                    
                }
        }
        
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmail.text = userEmailArray[indexPath.row]
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIDArray[indexPath.row]
        return cell
        
        
    }
    
}
   
    
    

