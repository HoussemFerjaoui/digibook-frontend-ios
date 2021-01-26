//
//  LoginViewController.swift
//  DigiBook-App
//
//  Created by 123 on 07/01/2021.
//  Copyright © 2021 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    
    static var currentUserPicurl: String = ""
    static var currentUserName: String = ""
    static var currentUserEmail: String = ""
    static var currentUserDate: String = ""
    

    
    @IBOutlet weak var inputEmail: UITextField!
    
    @IBOutlet weak var inputPassword: UITextField!
    
    @IBOutlet weak var buttonLogin: UIButton!
    
    @IBOutlet weak var LabelError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        
        inputEmail.layer.cornerRadius = 20
        inputEmail.layer.borderWidth = 0.6
        inputEmail.layer.borderColor = UIColor.black.cgColor
        inputEmail.layer.masksToBounds = true
        inputEmail.frame.size.height = 50
        
        inputPassword.layer.cornerRadius = 20
        inputPassword.layer.borderWidth = 0.6
        inputPassword.layer.borderColor = UIColor.black.cgColor
        inputPassword.layer.masksToBounds = true
        inputPassword.frame.size.height = 50
        
        buttonLogin.layer.cornerRadius = 20
        buttonLogin.layer.borderWidth = 0.1
        buttonLogin.layer.borderColor = UIColor.black.cgColor
        buttonLogin.layer.masksToBounds = true
        buttonLogin.frame.size.height = 50
        
    }
    
    
    @IBAction func LoginFunction(_ sender: Any) {
        
        
        guard let email = inputEmail.text, !email.isEmpty else {return}
        guard let password = inputPassword.text, !password.isEmpty else {return}
               
               let serverUrl = "http://127.0.0.1:6000/api/user/loginios"
               
               let LoginRequest = [
                   "email" : email,
                   "password" :password,
               ]
                   
               AF.request(serverUrl, method: .post, parameters: LoginRequest, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
                   switch response.result {
                       
                   case .success:
                       let myresult = try? JSON(data: response.data!)
                       let resultArray = myresult!

                       let user_picurl = resultArray["picurl"].stringValue
                       let user_name = resultArray["name"].stringValue
                       let user_email = resultArray["email"].stringValue
                       let user_date = resultArray["date"].stringValue
                       LoginViewController.currentUserPicurl = user_picurl
                       LoginViewController.currentUserName = user_name
                       LoginViewController.currentUserEmail = user_email
                       LoginViewController.currentUserDate = user_date
      
                    self.performSegue(withIdentifier: "goHome", sender:nil)
                   
                   case .failure(let error):
                        if let httpStatusCode = response.response?.statusCode
                        {
                           switch(httpStatusCode) {
                              case 400:
                                  //print("invalide email")
                               self.LabelError.text = "invalide email"
                          
                              case 401:
                                  //print("email dosnt exist")
                               self.LabelError.text = "email dosnt exist"
                               
                               case 402:
                               //print("password incorrect")
                               self.LabelError.text = "password incorrect"
                   
                           default:
                               break
                           }
                           } else {
                              print(error)
                        }
                   }
               }
        
        
        
   
        
    }
    
  
    
    
    
}
