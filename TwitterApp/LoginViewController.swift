//
//  LoginViewController.swift
//  TwitterApp
//
//  Created by Palak Jadav on 2/22/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        
        TwitterClient.sharedInstance?.login(success: {
            print("I've logged in")
            
            self.performSegue(withIdentifier:
                "loginSegue", sender: nil)
            
        }, failure: { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        })
        
        //let twitterClient = BDBOAuth1SessionManager(baseURL: NSURL(string:"https://api.twitter.com") as URL!, consumerKey: "RTy86eGBWShLGa92UMRDh4fUq", consumerSecret: "XXIc7DTGtoIPYzqv8GUIWOzz9khK61exQlaYFxlO4Rb3xz4S7L")

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
