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
	var watchLaterID: String!
	var favoritesID: String!
	var likesID: String!
	var watsonInput: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
		self.accessToken = appDelegate.accessToken
		self.requestPlaylistIDs()
    }
	
	func requestPlaylistIDs() {
		let url = NSURL(string: "https://www.googleapis.com/youtube/v3/channels?part=contentDetails&mine=true&access_token=\(self.accessToken)")
		let request = NSURLRequest(URL: url!)
		let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
		let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
			// Extract playlist IDs
			let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as NSDictionary
			let itemsArray = jsonDict.objectForKey("items") as NSArray
			let itemsDict = itemsArray[0] as NSDictionary
			let contentsDict = itemsDict.objectForKey("contentDetails") as NSDictionary
			let playlistsDict = contentsDict.objectForKey("relatedPlaylists") as NSDictionary
			
			self.watchHistoryID = playlistsDict.objectForKey("watchHistory") as String!
			self.watchLaterID = playlistsDict.objectForKey("watchLater") as String!
			self.favoritesID = playlistsDict.objectForKey("favorites") as String!
			self.likesID = playlistsDict.objectForKey("likes") as String!
			
			// Get playlist details without race condition
			dispatch_sync(dispatch_queue_create("net.gofake1.YTGuide.queue", nil), {
				self.requestPlaylistsWithID(self.watchHistoryID)
				self.requestPlaylistsWithID(self.watchLaterID)
				self.requestPlaylistsWithID(self.favoritesID)
				self.requestPlaylistsWithID(self.likesID)
			})
			// Update UI afterwards
			dispatch_sync(dispatch_get_main_queue(), {
				self.recommendVideo()
			})
		})
		task.resume()
	}
	
	func requestPlaylistsWithID(id: String) {
		var url = NSURL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=\(id)&maxResults=50&access_token=\(self.accessToken)")
		var request = NSURLRequest(URL: url!)
		let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
		var task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
			let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil) as NSDictionary
			let itemsArray = jsonDict.objectForKey("items") as NSArray
			for itemDict in itemsArray {
				let snippetDict = itemDict.objectForKey("snippet") as NSDictionary
				let itemDescription = snippetDict.objectForKey("description") as String!
				self.watsonInput += itemDescription
			}
		})
		task.resume()
	}
	
	func recommendVideo() {
		// Send user data to Bluemix and expect response
		
		self.displayVideoFromURL("n8Wq9Z5Ktc0")
	}
	
	func displayVideoFromURL(id: String) {
		let webView = UIWebView(frame: CGRectMake(0, 22, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
		let embedHTML = "<html><head><style type=\"text/css\"> iframe {position:absolute; top:50%%; margin-top:-130px;} body { background-color: transparent; color: white; } </style></head> <body style=\"margin:0\"> <iframe width=\"100%%\" height=\"240px\" src=http://www.youtube.com/embed/\(id) frameborder=\"0\" allowfullscreen></iframe></body></html>"
		webView.loadHTMLString(embedHTML, baseURL: nil)
		self.view.addSubview(webView)
	}

}
