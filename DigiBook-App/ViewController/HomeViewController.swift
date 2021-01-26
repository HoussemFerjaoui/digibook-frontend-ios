//
//  HomeViewController.swift
//  DigiBook-App
//
//  Created by 123 on 03/01/2021.
//  Copyright © 2021 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import LazyImage

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var ViewPost: UIView!
    @IBOutlet weak var TextPost: UITextField!
    @IBOutlet weak var PostButtonOutlet: UIButton!

    @IBOutlet weak var postTableview: UITableView!

   
    //var imgUserdata = ["img5","img5","img5","img5","img5","img5"]
    
    var ResponseMassage :String = ""

    var arr_postName = [String]()
    var arr_postEmail = [String]()
    var arr_postText = [String]()
    var arr_postLikes = [Array<Any>]()
    var arr_postDate = [String]()
    var arr_postPicUrl = [String]()
 
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
        let buttonComments = contentview?.viewWithTag(6) as! UIButton
        let labelDate = contentview?.viewWithTag(7) as! UILabel
        let buttonLike = contentview?.viewWithTag(8) as! SubclassedUIButton
        
        imageview.imageURL = "http://127.0.0.1:6000/"+arr_postPicUrl[indexPath.row]
        //print(arr_postPicUrl[indexPath.row])
        //print(arr_postName[indexPath.row])

        labelName.text = arr_postName[indexPath.row]
        labelEmail.text = arr_postEmail[indexPath.row]
        labelText.text = arr_postText[indexPath.row]
        labelLikes.text = "Likes:"+" "+String(arr_postLikes[indexPath.row].count)
        
        //var ch = arr_postLikes[indexPath.row][0] as! JSON
        if(arr_postLikes[indexPath.row].count != 0){
            //print(arr_postLikes[indexPath.row][0])
            let ch = arr_postLikes[indexPath.row][0] as! JSON
            //print(ch)
            if(ch.string == LoginViewController.currentUserEmail){
                buttonLike.tintColor = UIColor.red
            }
            }else{
            buttonLike.tintColor = UIColor.gray
        }
            
        
        //
        //var email = LoginViewController.currentUserEmail
        
        /*for sublist in arr_postLikes{
            
            
            //let templist = sublist[0] as! String
            var test: String?
            test = sublist[0] as! String
            print(test!)
            /*do{
            var data1 = try JSONSerialization.data(withJSONObject: sublist[0], options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let finalchar = String(data: data1, encoding: String.Encoding.utf8)
            //print(templist.contains(LoginViewController.currentUserEmail))
            if(finalchar!.contains(LoginViewController.currentUserEmail)){
                buttonLike.tintColor = UIColor.red
            }else{
                buttonLike.tintColor = UIColor.gray
            }
            }catch let myJSONError{
                    print(myJSONError)
            }*/
        }
        */
        buttonComments.setTitle("Comments:", for: .normal)
        labelDate.text = arr_postDate[indexPath.row]
        
        
        buttonLike.indexPath = indexPath.row
        buttonLike.addTarget(self, action: #selector(buttonSelected), for: .touchUpInside)
        

        return cell!
    }
    
   

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         let date = arr_postDate[indexPath.row]
         performSegue(withIdentifier: "mSegue", sender: date)
        
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
           if segue.identifier == "mSegue" {
               
               let date = sender as! String
               let commentsViewController = segue.destination as! CommentsViewController
               commentsViewController.postDate = date
           }
          
       }
       
     
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.tabBarController!.navigationController!.setNavigationBarHidden(true, animated: false)
       }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        title = "Home"
        
        ViewPost.layer.cornerRadius = 10
        ViewPost.layer.borderWidth = 0.1
        ViewPost.layer.borderColor = UIColor.black.cgColor
        ViewPost.layer.masksToBounds = true
        
        TextPost.layer.cornerRadius = 10
        TextPost.layer.borderWidth = 0.1
        TextPost.layer.borderColor = UIColor.black.cgColor
        TextPost.layer.masksToBounds = true
        TextPost.frame.size.height = 60
        
        PostButtonOutlet.layer.cornerRadius = 15
        PostButtonOutlet.layer.borderWidth = 0.1
        PostButtonOutlet.layer.borderColor = UIColor.black.cgColor
        PostButtonOutlet.layer.masksToBounds = true
        PostButtonOutlet.frame.size.height = 35
        
        
      let myapiurl = "http://127.0.0.1:6000/api/user/home/getallposts"
      AF.request(myapiurl, method: .get).responseJSON { (myresponse) in
          switch myresponse.result{
          case .success:
              let myresult = try? JSON(data: myresponse.data!)
              
              let resultArray = myresult!
              //print(resultArray)

              self.arr_postPicUrl.removeAll()
              self.arr_postName.removeAll()
              self.arr_postEmail.removeAll()
              self.arr_postText.removeAll()
              self.arr_postLikes.removeAll()
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
                //print(self.arr_postLikes)
                
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
    
   
 
    @IBAction func AddPost(_ sender: Any) {
        
        guard let content = TextPost.text, !content.isEmpty else {return}
     
        
          let serverUrl = "http://127.0.0.1:6000/api/user/home/addpost"
        
        let PostRequest = [
            "name" : LoginViewController.currentUserName,
            "email" : LoginViewController.currentUserEmail,
            "text" : content,
            "picurl" : LoginViewController.currentUserPicurl,
        ]
        
        AF.request(serverUrl, method: .post, parameters: PostRequest, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
            switch response.result {
                
            case .success:
              
                self.TextPost.text = nil
                self.viewDidLoad()
                self.postTableview.reloadData()
          
/*          //message toast
            let myalert = UIAlertController(title: "DigiBook", message: "Your Post has been create", preferredStyle: UIAlertController.Style.alert)
                myalert.addAction(UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction!) in})
            self.present(myalert, animated: true)
*/
                
            case .failure(let error):

                       print(error)
            }
        }
        
        
    }
    
    
    func checkLike(owneremail: String, postid: String) {
        //print(arr_postDate[sender.tag])
        //print(arr_postEmail[sender.tag])
        var postfkingid = postid
        postfkingid.removeLast()
        
        
        let serverUrl = "http://127.0.0.1:6000/api/user/home/likepost/"+LoginViewController.currentUserEmail+"/"+owneremail+"/"+postfkingid+"+00:00"
        print(serverUrl)
        
        AF.request(serverUrl, method: .post, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
                   switch response.result {
                       
                   case .success:
                       let responseValue = response.value!
                        //print(responseValue)
                       self.viewDidLoad()
                       self.postTableview.reloadData()
                       
                       let likenotif = [
                           "name" : LoginViewController.currentUserName,
                           "email" : owneremail,
                           "action" : "Liked your post",
                           "currentemail" : LoginViewController.currentUserEmail,
                           "picurl" : LoginViewController.currentUserPicurl,
                           "notificationid" : postid
                       ]
                       let notifurl = "http://127.0.0.1:6000/api/user/notifications/addnotification"
                           AF.request(notifurl, method: .post, parameters: likenotif, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
                               switch response.result {
                                   
                               case .success:
                                   //let responseValue = response.value!
                                   //print(responseValue)
                                   
                                   let myresult = try? JSON(data: response.data!)
                                   let resultArray = myresult!
                                   print(resultArray)
                                   break
                               case .failure(let error):
                                          print(error)
                                          break
                               }
                           }
                    
                    self.ResponseMassage = responseValue
                    print(responseValue)

                   case .failure(let error):
                              print(error)
                    break
                        
                   }
        }
    }
    
    @objc func buttonSelected(sender: SubclassedUIButton){
               //print(sender.tag)
               //sender.tintColor = UIColor .red
        
        checkLike(owneremail: arr_postEmail[sender.indexPath!], postid: arr_postDate[sender.indexPath!])
        
        
        
        /*if (ResponseMassage == "NoLike")
        {
            sender.tintColor = UIColor.red
            self.viewDidLoad()
            self.postTableview.reloadData()
            
        }else if(ResponseMassage == "Like")
        {
            sender.tintColor = UIColor.gray
            self.viewDidLoad()
            self.postTableview.reloadData()
        }*/
               
}
    
    
    static func fix_postid(postid:String) -> String {
        var copypostid = postid
        copypostid.removeLast()
        let newpostid = copypostid + "+00:00"
        return newpostid
    }
    


}
