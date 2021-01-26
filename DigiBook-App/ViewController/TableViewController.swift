//
//  TableViewController.swift
//  DigiBook-App
//
//  Created by 123 on 09/01/2021.
//  Copyright © 2021 Esprit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TableViewController: UIViewController{
    var arr_post_name = [String]()
    var arr_post_email = [String]()



    override func viewDidLoad() {
        super.viewDidLoad()
    
               let myurl = "http://192.168.1.13:3000/api/user/home/getallposts"
               AF.request(myurl, method: .get).responseJSON { (myresponse) in
                   switch myresponse.result{
                    
                   case .success:
                       let myresult = try? JSON(data: myresponse.data!)
      
                       let resultArray = myresult!
                       //print(resultArray)
                       //self.arr_post_name.removeAll()
          
                       for i in resultArray.arrayValue
                       {
                        let postName = i["name"].stringValue
                        let postEmail = i["email"].stringValue
                        print("postName:",postName)
                        print("Email:",postEmail)

                        self.arr_post_name.append(postName)
                        self.arr_post_email.append(postEmail)
                       }
                       
                   case .failure:
                       print(myresponse.error!)
                       break
                   }
               }

        // Do any additional setup after loading the view.
    }
    


}
