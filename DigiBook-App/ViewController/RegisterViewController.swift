//
//  RegisterViewController.swift
//  DigiBook-App
//
//  Created by 123 on 07/01/2021.
//  Copyright © 2021 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController {

   
    
    @IBOutlet weak var inputName: UITextField!
    @IBOutlet weak var inputEmail: UITextField!
    @IBOutlet weak var inputPassword: UITextField!
    @IBOutlet weak var inputConfirmPassword: UITextField!
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var LabelError: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        title = "Register"
        
        inputName.layer.cornerRadius = 20
        inputName.layer.borderWidth = 0.6
        inputName.layer.borderColor = UIColor.black.cgColor
        inputName.layer.masksToBounds = true
        inputName.frame.size.height = 50
        
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
        
        inputConfirmPassword.layer.cornerRadius = 20
        inputConfirmPassword.layer.borderWidth = 0.6
        inputConfirmPassword.layer.borderColor = UIColor.black.cgColor
        inputConfirmPassword.layer.masksToBounds = true
        inputConfirmPassword.frame.size.height = 50
        
        buttonRegister.layer.cornerRadius = 20
        buttonRegister.layer.borderWidth = 0.1
        buttonRegister.layer.borderColor = UIColor.black.cgColor
        buttonRegister.layer.masksToBounds = true
        buttonRegister.frame.size.height = 50
        
    
        
    }
    
    
    @IBAction func RegisterFunction(_ sender: Any) {
        
        guard let name = inputName.text, !name.isEmpty else {return}
        guard let email = inputEmail.text, !email.isEmpty else {return}
        guard let password = inputPassword.text, !password.isEmpty else {return}
        guard let confirmpassword = inputConfirmPassword.text, !confirmpassword.isEmpty else {return}
        
          let serverUrl = "http://127.0.0.1:6000/api/user/registerios"
        
        let registerRequest = [
            "name" : name,
            "email" : email,
            "password" : password,
            "ConfirmPassword" : confirmpassword,
        ]
        
        AF.request(serverUrl, method: .post, parameters: registerRequest, encoding: JSONEncoding.default, headers: nil).validate().responseString { response in
            switch response.result {
                
            case .success:
                let responseValue = response.value!
                        print(responseValue)
                
            let myalert = UIAlertController(title: "DigiBook", message: "Your account has been create", preferredStyle: UIAlertController.Style.alert)
                myalert.addAction(UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction!) in})
            self.present(myalert, animated: true)
                
                self.inputEmail.text = nil
                self.inputName.text = nil
                self.inputPassword.text = nil
                self.inputConfirmPassword.text = nil
                self.LabelError.text = nil
                
                //self.performSegue(withIdentifier: "goLogin", sender:nil)
                
            case .failure(let error):
                 if let httpStatusCode = response.response?.statusCode
                 {
                    switch(httpStatusCode) {
                       case 400:
                           //print("invalide email / name and password most be 6 or .... characters ")
                           self.LabelError.text = "invalide email"
                   
                       case 401:
                           //print("wrong confirm password")
                        self.LabelError.text = "wrong confirm password"
                        
                        case 402:
                        //print("user already exist")
                        self.LabelError.text = "user already exist"
            
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
	
