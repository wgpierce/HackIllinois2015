//
//  MainViewController.swift
//  YTGuide
//
//  Created by David Wu on 2/28/15.
//  Copyright (c) 2015 Gofake1. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	var accessToken: String!
	var watchHistoryID: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		self.accessToken = appDelegate.accessToken
		self.requestWatchHistoryID()
    }
	
	func requestWatchHistoryID() {
		let url = NSURL(string: "https://www.googleapis.com/youtube/v3/channels?part=contentDetails&mine=true&access_token=\(self.accessToken)")
		var request = NSMutableURLRequest(URL: url!)
		//request.addValue(self.accessToken, forHTTPHeaderField: "Authorization: Bearer")
		let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
		let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
			// Extract watch history playlist ID
			var error: NSError?
			let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &error) as NSDictionary
			let itemsArray = jsonDict.objectForKey("items") as NSArray
			let itemsDict = itemsArray[0] as NSDictionary
			let contentsDict = itemsDict.objectForKey("contentDetails") as NSDictionary
			let playlistsDict = contentsDict.objectForKey("relatedPlaylists") as NSDictionary
			self.watchHistoryID = playlistsDict.objectForKey("watchHistory") as String!
			self.requestWatchHistory()
		})
		task.resume()
	}
	
	func requestWatchHistory() {
		let url = NSURL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(self.watchHistoryID)&maxResults=50&access_token=\(self.accessToken)")
		var request = NSURLRequest(URL: url!)
		let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
		let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
			println(NSString(data: data, encoding: NSUTF8StringEncoding)!)
			// UIWebView must be called from main thread
			dispatch_async(dispatch_get_main_queue(), {
				self.recommendVideo()
			})
		})
		task.resume()
	}
	
	func recommendVideo() {
		// Bluemix
		self.displayVideoFromURL("n8Wq9Z5Ktc0")
	}
	
	func displayVideoFromURL(id: String) {
		let webView = UIWebView(frame: CGRectMake(0, 22, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
		let embedHTML = "<html><head><style type=\"text/css\"> iframe {position:absolute; top:50%%; margin-top:-130px;} body { background-color: transparent; color: white; } </style></head> <body style=\"margin:0\"> <iframe width=\"100%%\" height=\"240px\" src=http://www.youtube.com/embed/\(id) frameborder=\"0\" allowfullscreen></iframe></body></html>"
		webView.loadHTMLString(embedHTML, baseURL: nil)
		self.view.addSubview(webView)
	}

}
