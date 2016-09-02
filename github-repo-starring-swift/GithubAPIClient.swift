//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let urlString = "\(Secrets.githubAPIURL)/repositories?client_id=\(Secrets.githubClientID)&client_secret=\(Secrets.githubClientSecret)"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    //this function is to check if the repository is starred or not
    class func checkIfRepositoryIsStarred(fullName: String, completion: (Bool) -> ())
    {
        let urlString = "\(Secrets.githubAPIURL)/user/starred/\(fullName)"
        //this is the original URL
        
        let urlNSURL = NSURL(string: urlString)
        //converting the url into an NSURL 
        
        guard let unwrappedurlNSURL = urlNSURL else {print("An error occurred here"); return}
        //you must unwrapp the NSURL in order to proceed, don't forget!
        
        let session = NSURLSession.sharedSession()
        //creation of the session, accessing the URL
        
        let request = NSMutableURLRequest(URL: unwrappedurlNSURL)
        //creation of the request
        //Search up the difference between NSURLRequest vs. NSMutableRequest
        
        request.HTTPMethod = "GET"
        //request has an HTTPMethod of type "GET" to obtain information
        
        request.addValue("\(Secrets.access_token)", forHTTPHeaderField: "Authorization")
        //request has a token attached to it
        
        
        //Remember to create a task when you have to attach a value for the HTTPHeaderField
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard let unwrappedResponse = response else{print("An error occurred here"); return}
            //by default everything that is returned from an API call is an optional because you may              have an error, or data, or response or you may not
//
            let httpResponse = unwrappedResponse as! NSHTTPURLResponse
//            //then you are casting the httpResponse as an NSHTTPURLResponse
            
            let statusCode = httpResponse.statusCode
            //the NSHTTPURLResponse has the property statusCode and since we want to know if the the repo is starred or not we are only interested in the response
            print("\(fullName)\n\n\n\n\n#######\(statusCode)")
            
            if statusCode == 204 {
                print("\(fullName)\n\n\n\n########this repository is starred by you")
                completion(true)
            }
            
            else if statusCode == 404 {
                print("\(fullName)\n\n\n\n\n#########this repository is not starred by you")
                completion(false)
            }
        }
        task.resume()
    }
    
    class func starRepository(fullName: String, completion: () -> ())
    {
        let urlString = "\(Secrets.githubAPIURL)/user/starred\(fullName)"
        //this is the original URL
        
        let urlNSURL = NSURL(string: urlString)
        //converting the url into an NSURL
        
        guard let unwrappedurlNSURL = urlNSURL else {print("An error occurred here"); return}
        //you must unwrapp the NSURL in order to proceed, don't forget!
        
        let session = NSURLSession.sharedSession()
        //creation of the session
        
        let request = NSMutableURLRequest(URL: unwrappedurlNSURL)
        //creation of the request
        //Search up the difference between NSURLRequest vs. NSMutableRequest
        
        request.HTTPMethod = "PUT"
        //request has an HTTPMethod of type "GET" to obtain information
        
        request.addValue("\(Secrets.access_token)", forHTTPHeaderField: "Authorization")
        //request has a token attached to it
        
        //Remember to create a task when you have to attach a value for the HTTPHeaderField
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard let unwrappedResponse = response else{print("An error occurred here"); return}
            //by default everything that is returned from an API call is an optional because you may have an error, or data, or response or you may not based on what happens in the API call
            
            let httpResponse = unwrappedResponse as! NSHTTPURLResponse
            //then you are casting the httpResponse as an NSHTTPURLResponse
            
            let statusCode = httpResponse.statusCode
            //the NSHTTPURLResponse has the property statusCode and since we want to know if the the repo is starred or not we are only interested in the response
            
            if statusCode == 204 {
                print("starred")
                //this repository is starred
            }
        }
        task.resume()
    }
    

    
    class func unstarRepository(fullName: String,  completion:() -> ())
    {
        let urlString = "\(Secrets.githubAPIURL)/user/starred\(fullName)"
        //this is the original URL
        
        let urlNSURL = NSURL(string: urlString)
        //converting the url into an NSURL
        
        guard let unwrappedurlNSURL = urlNSURL else {print("An error occurred here"); return}
        //you must unwrapp the NSURL in order to proceed, don't forget!
        
        let session = NSURLSession.sharedSession()
        //creation of the session
        
        let request = NSMutableURLRequest(URL: unwrappedurlNSURL)
        //creation of the request
        //Search up the difference between NSURLRequest vs. NSMutableRequest
        
        request.HTTPMethod = "DELETE"
        //request has an HTTPMethod of type "GET" to obtain information
        
        request.addValue("\(Secrets.access_token)", forHTTPHeaderField: "Authorization")
        //request has a token attached to it
        
        //Remember to create a task when you have to attach a value for the HTTPHeaderField
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            
            guard let unwrappedResponse = response else{print("An error occurred here"); return}
            //by default everything that is returned from an API call is an optional because you may have an error, or data, or response or you may not based on what happens in the API call
            
            let httpResponse = unwrappedResponse as! NSHTTPURLResponse
            //then you are casting the httpResponse as an NSHTTPURLResponse
            
            let statusCode = httpResponse.statusCode
            //the NSHTTPURLResponse has the property statusCode and since we want to know if the the repo is starred or not we are only interested in the response
            
            if statusCode == 204 {
                print("this repository is unstarred by you")
                //this repository is starred
            }
        }
        task.resume()

    }
    
}

