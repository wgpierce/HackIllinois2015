//
//  StartViewController.swift
//  YTGuide
//
//  Created by David Wu on 2/27/15.
//  Copyright (c) 2015 Gofake1. All rights reserved.
//
//  Handles authentication

import UIKit

class StartViewController: UIViewController, UIWebViewDelegate {
	
	let keychainName = "YTGuide"
	let clientID = "848904554980-4u8qv891a6i960e3r9h3p55k6u3qdnfj.apps.googleusercontent.com"
	let clientSecret = "QO4_YazBI-ypENIlTFh2SAY0"
	let scope = "https://www.googleapis.com/auth/youtube.readonly"
	let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
	var authCode = ""
	var accessToken = ""
	var refreshToken = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		// Get auth code
		let webView = UIWebView(frame: CGRectMake(0, 22, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
		webView.tag = 1
		webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://accounts.google.com/o/oauth2/auth?" +
			"client_id=\(self.clientID)&" +
			"redirect_uri=\(self.redirectURI)&" +
			"scope=\(self.scope)&" +
			"response_type=code&" +
			"access_type=offline")!))
		webView.delegate = self
		self.view.addSubview(webView)
    }
	
	func requestLogin() {
		let url = NSURL(string: "https://accounts.google.com/o/oauth2/token")
		var request = NSMutableURLRequest(URL: url!)
		request.HTTPMethod = "POST"
		// Google tells us to do this, but it doesn't work
		//request.addValue("application/x-www-form-unencoded", forHTTPHeaderField: "Content-Type")
		request.HTTPBody = ("grant_type=authorization_code&" +
							"code=\(self.authCode)&" +
							"client_id=\(self.clientID)&" +
							"client_secret=\(self.clientSecret)&" +
							"redirect_uri=\(self.redirectURI)"
							).dataUsingEncoding(NSUTF8StringEncoding)
		let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
		let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
			// Store tokens from JSON
			var error: NSError?
			let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as NSDictionary
			self.accessToken = jsonDict.objectForKey("access_token") as String
			self.refreshToken = jsonDict.objectForKey("refresh_token") as String
			let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
			appDelegate.accessToken = self.accessToken
			dispatch_async(dispatch_get_main_queue(), {
				self.performSegueWithIdentifier("login", sender: self)
			})
		})
		task.resume()
	}
	
	// MARK: - UIWebViewDelegate
	func webViewDidFinishLoad(webView: UIWebView) {
		let pageTitle: NSString = webView.stringByEvaluatingJavaScriptFromString("document.title")!
		if (pageTitle.rangeOfString("Success").location != NSNotFound) {
			self.authCode = pageTitle.substringFromIndex(13)
			// Exchange auth code for refresh and access tokens
			self.requestLogin()
			
			self.view.viewWithTag(1)?.removeFromSuperview()
		}
	}

}
