//
//  DetailsViewController.swift
//  DigiBook-App
//
//  Created by 123 on 12/01/2021.
//  Copyright © 2021 Esprit. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Foundation
import LazyImage


class DetailsViewController: UIViewController {
    

    var Book_data:JSON?
    var authordata:String?
    var selectedbookresponse:JSON?

    @IBOutlet var fav_label: UILabel!
    @IBOutlet var likes_label: UILabel!
    @IBOutlet var like_but_out: UIButton!
    
    @IBOutlet var fav_but_out: UIButton!
    
    @IBOutlet var book_image: LazyImageView!
    
    @IBOutlet var book_title: UILabel!
    

    @IBOutlet var book_authors: UILabel!
    
    
    @IBOutlet var book_text: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //print(Book_data!["volumeInfo"]["title"].stringValue)
        
        book_title.text = Book_data!["volumeInfo"]["title"].stringValue
        book_image.imageURL = Book_data!["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
        book_text.text = Book_data!["searchInfo"]["textSnippet"].stringValue
        
        let authorslist:Array? = Book_data!["volumeInfo"]["authors"].array
        if(authorslist != nil){
        for author in authorslist!{
            var char =  ""
            char += author.stringValue
            book_authors.text = char
            //newauthorslist?.append(author.stringValue)
        }
        }else{
            book_authors.text = "not available"
        }
        
        //print(LoginViewController.selectedbookinfo!["bookid"].stringValue)
        
        // extendbook
          let serverUrl = "http://127.0.0.1:6000/booksearch/extendedresults"
        
        
        let authorslist2:Array? = Book_data!["volumeInfo"]["authors"].array
        if(authorslist2 != nil){
        for author in authorslist2!{
            var char =  ""
            char += author.stringValue
            authordata = char
            //newauthorslist?.append(author.stringValue)
        }
        }else{
            authordata = "not available"
        }
        
        let selectedbook = [
            "bookid" : Book_data!["id"].stringValue,
            "bookname" : Book_data!["volumeInfo"]["title"].stringValue,
            "bookauthor" : authordata!,
            "bookcover" : Book_data!["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
        ]
        
        AF.request(serverUrl, method: .post, parameters: selectedbook, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
            switch response.result {
                
            case .success:
                //let responseValue = response.value!
                //print(responseValue)
                
                let myresult = try? JSON(data: response.data!)
                let resultArray = myresult!
                self.selectedbookresponse = resultArray
                
                var ch:String
    
                let listt:Array<JSON> = resultArray["upvotelist"].arrayValue
                for i in listt{
                    ch = i.string!
                    if(ch==LoginViewController.currentUserEmail){
                        self.like_but_out.tintColor = UIColor.blue
                        self.likes_label.text = String(resultArray["upvotelist"].count)
                        self.likes_label.textColor = UIColor.blue
                    }else{
                        self.likes_label.text = String(resultArray["upvotelist"].count) //String(resultArray["upvotelist"].count)
                        self.likes_label.textColor = UIColor.gray
                        self.like_but_out.tintColor = UIColor.gray
                    }
                    //print(ch)
                }
                
                let favlist:Array<JSON> = resultArray["favlist"].arrayValue
                for i in favlist{
                    ch = i.string!
                    if(ch==LoginViewController.currentUserEmail){
                        self.fav_but_out.tintColor = UIColor.red
                        self.fav_label.text = String(resultArray["favlist"].count)
                        self.fav_label.textColor = UIColor.red
                    }else{
                        self.fav_label.text = String(resultArray["favlist"].count)
                        self.fav_label.textColor = UIColor.gray
                        self.fav_but_out.tintColor = UIColor.gray

                    }
                    //print(ch)
                }
                //print(resultArray["upvotelist"].array!)
                
                //if(resultArray["upvotelist"].array?.contains(LoginViewController.currentUserEmail )){
                    
                //}
                break
            case .failure(let error):
                       print(error)
                       break
            }
        }
        
    }
    
    
    @IBAction func upvote_button(_ sender: UIButton) {
        
        let serverUrl = "http://127.0.0.1:6000/booksearch/extendedupvote/"+Book_data!["id"].stringValue+"/"+LoginViewController.currentUserEmail
        print(serverUrl)
        
        AF.request(serverUrl, method: .post, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
                   switch response.result {
                       
                   case .success:
                       let responseValue = response.value!
                        //print(responseValue)
                       if(responseValue == "Like"){
                        sender.tintColor = UIColor.blue
                        self.likes_label.text = String(self.selectedbookresponse!["upvotelist"].count + 1)
                        self.likes_label.textColor = UIColor.blue
                        
                       }else{
                        sender.tintColor = UIColor.gray
                        self.likes_label.text = String(self.selectedbookresponse!["upvotelist"].count - 1)
                        self.likes_label.textColor = UIColor.gray
                        
                       }
                       self.viewDidLoad()
                       
                    print(responseValue)

                   case .failure(let error):
                              print(error)
                    break
                        
                   }
        }
        
    }
    

    @IBAction func favo_button(_ sender: UIButton) {
        
        let serverUrl = "http://127.0.0.1:6000/booksearch/extendedaddfav/"+Book_data!["id"].stringValue+"/"+LoginViewController.currentUserEmail
        print(serverUrl)
        
        AF.request(serverUrl, method: .post, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
                   switch response.result {
                       
                   case .success:
                       let responseValue = response.value!
                        //print(responseValue)
                       if(responseValue == "Like"){
                        sender.tintColor = UIColor.red
                        self.fav_label.text = String(self.selectedbookresponse!["favlist"].count + 1)
                        self.fav_label.textColor = UIColor.red
                        
                       }else{
                        sender.tintColor = UIColor.gray
                        self.fav_label.text = String(self.selectedbookresponse!["favlist"].count - 1)
                        self.fav_label.textColor = UIColor.gray
                        
                       }
                       self.viewDidLoad()
                       
                    print(responseValue)

                   case .failure(let error):
                              print(error)
                    break
                        
                   }
        }
        
    }
    
}
