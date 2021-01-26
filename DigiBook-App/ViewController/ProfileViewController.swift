//
//  ProfileViewController.swift
//  DigiBook-App
//
//  Created by 123 on 03/01/2021.
//  Copyright © 2021 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Photos

import Foundation
import LazyImage

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var picProfile: LazyImageView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var postTableview: UITableView!
    
    
    var arr_postName = [String]()
    var arr_postEmail = [String]()
    var arr_postText = [String]()
    var arr_postLikes = [Array<Any>]()
    var arr_postDate = [String]()
    var arr_postPicUrl = [String]()
    var arr_postComments = [Array<Any>]()
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return arr_postName.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
           let cell = tableView.dequeueReusableCell(withIdentifier: "mCell")
           let contentview = cell?.contentView
           let imageview = contentview?.viewWithTag(1)as! LazyImageView
           let labelName = contentview?.viewWithTag(2) as! UILabel
           let labelEmail = contentview?.viewWithTag(3) as! UILabel
           let labelText = contentview?.viewWithTag(4) as! UITextView
           let labelLikes = contentview?.viewWithTag(5) as! UILabel
           let labelComments = contentview?.viewWithTag(6) as! UIButton
           let labelDate = contentview?.viewWithTag(7) as! UILabel
           
        imageview.imageURL = "http://127.0.0.1:6000/"+arr_postPicUrl[indexPath.row]
           labelName.text = arr_postName[indexPath.row]
           labelEmail.text = arr_postEmail[indexPath.row]
           labelText.text = arr_postText[indexPath.row]
           labelLikes.text = "Likes:"+" "+String(arr_postLikes[indexPath.row].count)
           labelComments.setTitle("Comments:"+" "+String(arr_postComments[indexPath.row].count), for: .normal)
           labelDate.text = arr_postDate[indexPath.row]

           return cell!
       }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let myapiurl = "http://127.0.0.1:6000/api/user/profile/deletepost/"+arr_postDate[indexPath.row]
            //AF.request(myapiurl, method: .delete).responseJSON { (myresponse) in
            
            AF.request(myapiurl, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
                       switch response.result {
                       case .success:
                        
                    self.viewDidLoad()
                    self.postTableview.reloadData()
   
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
     

    @IBAction func Deconnecte(_ sender: Any) {
        //self.performSegue(withIdentifier: "goLogin", sender:nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        
        
        background.layer.cornerRadius = 10
        background.layer.borderWidth = 0.2
        background.layer.borderColor = UIColor.black.cgColor
        background.layer.masksToBounds = true
        
        picProfile.layer.cornerRadius = 100
        picProfile.layer.borderWidth = 4
        picProfile.layer.borderColor = UIColor.white.cgColor
        picProfile.layer.masksToBounds = true
        
        viewInfo.layer.cornerRadius = 10
        viewInfo.layer.borderWidth = 0.1
        viewInfo.layer.borderColor = UIColor.black.cgColor
        viewInfo.layer.masksToBounds = true
        
        userName.text = LoginViewController.currentUserName
        userEmail.text = LoginViewController.currentUserEmail
        
        picProfile.imageURL = "http://127.0.0.1:6000/"+LoginViewController.currentUserPicurl
        
        let myapiurl = "http://127.0.0.1:6000/api/user/profile/allmyposts/"+LoginViewController.currentUserEmail
        AF.request(myapiurl, method: .get).responseJSON { (myresponse) in
            switch myresponse.result{
            case .success:
                let myresult = try? JSON(data: myresponse.data!)
                
                let resultArray = myresult!
                //print(resultArray)

                self.arr_postName.removeAll()
                self.arr_postName.removeAll()
                self.arr_postEmail.removeAll()
                self.arr_postText.removeAll()
                self.arr_postLikes.removeAll()
                self.arr_postComments.removeAll()
                 self.arr_postDate.removeAll()


                for i in resultArray.arrayValue {

               let picUrl = i["picurl"].stringValue
               self.arr_postPicUrl.append(picUrl)
                    
                    let postName = i["name"].stringValue
                    self.arr_postName.append(postName)
                  
                    let postEmail = i["email"].stringValue
                    self.arr_postEmail.append(postEmail)
                  
                    let postText = i["text"].stringValue
                    self.arr_postText.append(postText)
                  
                    let postLikes = i["likesList"].arrayValue
                    self.arr_postLikes.append(postLikes)
                  
                    let postComments = i["commentsList"].arrayValue
                    self.arr_postComments.append(postComments)
                  
                    let postDate = i["date"].stringValue
                    self.arr_postDate.append(postDate)
                  
                  //print(postName)
                  // print(postEmail)
                  //print(postLikes.count)
                }
                self.postTableview.reloadData()
                break
                
            case .failure:
                print(myresponse.error!)
                break
            }
        }

        
    }
    
    
    @IBAction func profilepic_but(_ sender: UIButton) {
        showImagePickerController()
    }
    
    
    
}

extension ProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate    {
    
    
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var theimage = UIImage()
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            picProfile.image = editedImage
            theimage = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picProfile.image = originalImage
            theimage = originalImage
            
        }
        


        AF.upload(multipartFormData: { multipartFormData in



                guard let image = theimage as? UIImage else { return }
                let jpegData = image.jpegData(compressionQuality: 1.0)
            multipartFormData.append(Data((jpegData)!), withName: "profilepicture", fileName: LoginViewController.currentUserEmail+".jpg", mimeType: "image/jpg")

        }, to: "http://127.0.0.1:6000/api/user/profile/uploadpic/"+LoginViewController.currentUserEmail)

            .responseJSON { response in
                
                self.postTableview.reloadData()
                //let myresult = try? JSON(data: response.data!)
                //let resultArray = myresult!
                //print(resultArray)

        }

        
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
        
}


