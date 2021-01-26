//
//  SearchViewController.swift
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


class SearchViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate  {
    
    //var authordata:String?
    //static var selectedbookinfo:JSON?
    
    @IBOutlet var search_text: UITextField!
    
    @IBOutlet var uploadimageview: UIImageView!
    
    var arr_books = [JSON]()
    
    @IBOutlet var postTableview: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "mCell")
              let contentview = cell?.contentView
              let imageview = contentview?.viewWithTag(1) as! LazyImageView
              let labelName = contentview?.viewWithTag(2) as! UILabel
              let labelEmail = contentview?.viewWithTag(3) as! UILabel
        
        imageview.imageURL = arr_books[indexPath.row]["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
        
         //var url = URL(string: arr_books[indexPath.row]["imageLinks"]["thumbnail"].stringValue)
        //var data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        
              //imageview.image = UIImage(named: arr_books[indexPath.row]["imageLinks"]["thumbnail"])
            labelName.text = arr_books[indexPath.row]["volumeInfo"]["title"].stringValue
        

        let authorslist:Array? = arr_books[indexPath.row]["volumeInfo"]["authors"].array
        if(authorslist != nil){
        for author in authorslist!{
            var char =  ""
            char += author.stringValue
            labelEmail.text = char
            //newauthorslist?.append(author.stringValue)
        }
        }else{
            labelEmail.text = "not available"
        }
        
        //labelEmail.text = newauthorslist!.joined(separator: " ")

              return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        //let bookName = arr_books[indexPath.row]["volumeInfo"]["title"].stringValue
        //let date = "hello"
        let book = arr_books[indexPath.row]
        
        // extendbook
          /*let serverUrl = "http://127.0.0.1:3000/booksearch/extendedresults"
        
        
        let authorslist:Array? = arr_books[indexPath.row]["volumeInfo"]["authors"].array
        if(authorslist != nil){
        for author in authorslist!{
            var char =  ""
            char += author.stringValue
            authordata = char
            //newauthorslist?.append(author.stringValue)
        }
        }else{
            authordata = "not available"
        }
        
        let selectedbook = [
            "bookid" : arr_books[indexPath.row]["id"].stringValue,
            "bookname" : arr_books[indexPath.row]["volumeInfo"]["title"].stringValue,
            "bookauthor" : authordata!,
            "bookcover" : arr_books[indexPath.row]["volumeInfo"]["imageLinks"]["thumbnail"].stringValue
        ]
        
        AF.request(serverUrl, method: .post, parameters: selectedbook, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
            switch response.result {
                
            case .success:
                let responseValue = response.value!
                //print(responseValue)
                
                let myresult = try? JSON(data: response.data!)
                let resultArray = myresult!
                
                //LoginViewController.selectedbookinfo = resultArray
                //print(SearchViewController.selectedbookinfo!["bookid"].stringValue)
                break
            case .failure(let error):
                       print(error)
                       break
            }
        }*/
        
        
         performSegue(withIdentifier: "mSegueDeatail", sender: book)
        //print(bookName)
        
     }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           
           if segue.identifier == "mSegueDeatail" {
                         
                         let thebook = sender as! JSON
                         let detailsViewController = segue.destination as! DetailsViewController
                         detailsViewController.Book_data = thebook
                     }
          
       }
 
 
 
 
 
    
    
    
    
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"

        
        // Do any additional setup after loading the view.
    }
    


    
    //actions
    
    @IBAction func uploadPictureButton(_ sender: UIButton) {
        
        let serverUrl = "http://127.0.0.1:6000/booksearch/textsearch/"+self.search_text.text!
                 
                 AF.request(serverUrl, method: .post, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
                            switch response.result {
                                
                            case .success:
                            
                                let myresult = try? JSON(data: response.data!)
                                let resultArray = myresult!
                                //print(resultArray["totalItems"].int!)
                                if(resultArray["totalItems"].int! != 0){
                                self.arr_books = resultArray["items"].array! // list of JSON list<JSON>
                                //print(self.arr_books[0]["volumeInfo"]["imageLinks"]["thumbnail"].stringValue)
                                self.viewDidLoad()
                                self.postTableview.reloadData()
                                //for book in items_list!{
                                    
                                    //print(book["volumeInfo"]["title"])
                                    //let postName = i["name"].stringValue
                                    //self.arr_image.append(postName)
                                }else{
                                    let myalert = UIAlertController(title: "DigiBook", message: "No Results Found", preferredStyle: UIAlertController.Style.alert)
                                        myalert.addAction(UIAlertAction(title: "TryAgain", style: .default) { (action:UIAlertAction!) in})
                                    self.present(myalert, animated: true)
                                }
                                    
                                    
                                    
                                //}
                                break
                            case .failure(let error):
                                       print(error)
                             break
                                 
                            }
                 }
    }
    
    
    
    
    @IBAction func uploadbutton(_ sender: UIButton) {
        showImagePickerController()
    }

    
}

extension SearchViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate    {
    
    
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
            uploadimageview.image = editedImage
            theimage = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uploadimageview.image = originalImage
            theimage = originalImage
        }
        
        //let param: [String:Any] = ["your_parameters"]
    
       //var imagee = UIImage(named: "moi.jpg")
        
        /*let imageData = image.jpegData(compressionQuality: 0.50)
        print(image, imageData!)

        AF.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData!, withName: "file", fileName: "swift_file.jpg", mimeType: "image/jpg")

            }, to: "http://127.0.0.1:3000/booksearch/search", method: .post)*/
        
        
        //let parameters = ["name": rname, "method": post] //var parameters: [String: Any] = [:]

        AF.upload(multipartFormData: { multipartFormData in



                guard let image = theimage as? UIImage else { return }
                let jpegData = image.jpegData(compressionQuality: 1.0)
                multipartFormData.append(Data((jpegData)!), withName: "textimage", fileName: "name.jpg", mimeType: "image/jpg")

        }, to: "http://127.0.0.1:6000/booksearch/search")

            .responseJSON { response in
                let myresult = try? JSON(data: response.data!)
                let resultArray = myresult!

                if(resultArray["totalItems"].int! != 0){
                self.arr_books = resultArray["items"].array! // list of JSON list<JSON>
                //print(self.arr_books[0]["volumeInfo"]["imageLinks"]["thumbnail"].stringValue)
                self.viewDidLoad()
                self.postTableview.reloadData()
                }else{
                    let myalert = UIAlertController(title: "DigiBook", message: "No Results Found", preferredStyle: UIAlertController.Style.alert)
                        myalert.addAction(UIAlertAction(title: "TryAgain", style: .default) { (action:UIAlertAction!) in})
                    self.present(myalert, animated: true)
                }
        }

        
        
        dismiss(animated: true, completion: nil)
    }
        
}
    

