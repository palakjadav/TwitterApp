//
//  ComposeTweetViewController.swift
//  TwitterApp
//
//  Created by Palak Jadav on 3/5/17.
//  Copyright © 2017 flounderware. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {

    
   
    @IBOutlet weak var composeTweet: UITextView!
    @IBOutlet weak var tweetButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.composeTweet.layer.borderWidth = 2
        self.composeTweet.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetButton(_ sender: UIButton) {
        let tweetText = composeTweet.text
        let paramsDict: NSDictionary = NSDictionary(dictionary: ["status" : tweetText!])
        TwitterClient.sharedInstance?.compose(tweetText: tweetText!, params: paramsDict, completion: { (error) -> () in
            print("Composing")
            print(error?.localizedDescription)
        })
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
