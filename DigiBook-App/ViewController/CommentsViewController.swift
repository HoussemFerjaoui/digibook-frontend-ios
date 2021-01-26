//
//  CommentsViewController.swift
//  DigiBook-App
//
//  Created by 123 on 11/01/2021.
//  Copyright © 2021 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import LazyImage

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var postDate:String?
    
    var arr_commentName = [String]()
    var arr_commentEmail = [String]()
    var arr_commentText = [String]()
    var arr_commentPicUrl = [String]()
    var arr_commentDate = [String]()
    
    @IBOutlet weak var postTableview: UITableView!
    @IBOutlet weak var CommentText: UITextField!
    @IBOutlet weak var AddCommentOutlet: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_commentName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "mCell")
               let contentview = cell?.contentView
               let imageview = contentview?.viewWithTag(1)as! LazyImageView
               let labelName = contentview?.viewWithTag(2) as! UILabel
               let labelEmail = contentview?.viewWithTag(3) as! UILabel
               let labelText = contentview?.viewWithTag(4) as! UITextView
               let labelDate = contentview?.viewWithTag(5) as! UILabel
               
               //imageview.image = UIImage(named: imgUserdata[indexPath.row])
               imageview.imageURL = "http://127.0.0.1:6000/"+arr_commentPicUrl[indexPath.row]
               labelName.text = arr_commentName[indexPath.row]
               labelEmail.text = arr_commentEmail[indexPath.row]
               labelText.text = arr_commentText[indexPath.row]
               labelDate.text = arr_commentDate[indexPath.row]
               
               return cell!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        
        CommentText.layer.cornerRadius = 7
        CommentText.layer.borderWidth = 0.1
        CommentText.layer.borderColor = UIColor.black.cgColor
        CommentText.layer.masksToBounds = true
        CommentText.frame.size.height = 45
        
        AddCommentOutlet.layer.cornerRadius = 7
        AddCommentOutlet.layer.borderWidth = 0.1
        AddCommentOutlet.layer.borderColor = UIColor.black.cgColor
        AddCommentOutlet.layer.masksToBounds = true
        AddCommentOutlet.frame.size.height = 45
        
        
        let myapiurl = "http://127.0.0.1:6000/api/user/home/allpostcomments/"+postDate!
        AF.request(myapiurl, method: .get).responseJSON { (myresponse) in
            switch myresponse.result{
            case .success:
                let myresult = try? JSON(data: myresponse.data!)
                
                let resultArray = myresult!
                //print(resultArray)

            self.arr_commentPicUrl.removeAll()
                self.arr_commentName.removeAll()
                self.arr_commentEmail.removeAll()
                self.arr_commentText.removeAll()
                self.arr_commentDate.removeAll()


                for i in resultArray.arrayValue {

                let picUrl = i["picurl"].stringValue
                self.arr_commentPicUrl.append(picUrl)
                    
                    let commentName = i["name"].stringValue
                    self.arr_commentName.append(commentName)
                  
                    let commentEmail = i["email"].stringValue
                    self.arr_commentEmail.append(commentEmail)
                  
                    let commentText = i["text"].stringValue
                    self.arr_commentText.append(commentText)
                  
                    let commentDate = i["date"].stringValue
                    self.arr_commentDate.append(commentDate)
                  
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

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Addcomment(_ sender: Any) {
        
        guard let content = CommentText.text, !content.isEmpty else {return}
        
        let serverUrl = "http://127.0.0.1:6000/api/user/home/addcomment"
          
          let CommentRequest = [
              "name" : LoginViewController.currentUserName,
              "email" : LoginViewController.currentUserEmail,
              "picurl" : LoginViewController.currentUserPicurl,
              "text" : content,
              "date" : postDate!,
              ]
          
          AF.request(serverUrl, method: .post, parameters: CommentRequest, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
              switch response.result {
                  
              case .success:
                
                  self.CommentText.text = nil
                  self.viewDidLoad()
                  self.postTableview.reloadData()
                
            
               /*
              let myalert = UIAlertController(title: "DigiBook", message: "Your Comment has been create", preferredStyle: UIAlertController.Style.alert)
                  myalert.addAction(UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction!) in})
              self.present(myalert, animated: true)
*/
                  
              case .failure(let error):

                         print(error)
              }
          }
 
    }
    

}
