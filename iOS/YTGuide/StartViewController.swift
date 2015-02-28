//
//  StartViewController.swift
//  YTGuide
//
//  Created by David Wu on 2/27/15.
//  Copyright (c) 2015 Gofake1. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	func requestUserHistory() {
		let url = NSURL(string: "https://accounts.google.com/o/oauth2/auth?" +
				  "client_id=848904554980-4u8qv891a6i960e3r9h3p55k6u3qdnfj.apps.googleusercontent.com&" +
				  "redirect_uri=http%3A%2F%2Flocalhost%2Foauth2callback&" +
				  "scope=https://www.googleapis.com/auth/youtube.readonly&" +
				  "response_type=code")
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
		
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
