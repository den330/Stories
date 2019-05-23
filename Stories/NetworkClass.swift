//
//  NetworkClass.swift
//  Stories
//
//  Created by 330Mac on 2018-12-03.
//  Copyright © 2018 Yaxin Yuan. All rights reserved.
//

import Foundation
import Alamofire

class NetworkClass{
    struct URLInfo{
        static let mainUrl = "https://www.wattpad.com/api/v3/stories?offset=0&limit=30&fields=stories(id,title,cover,user),nextUrl"
    }
    
    class func getStories(withUrlStr: String?=nil, completion: @escaping ([Story]?, String?, Error?) -> Void){
        var request = URLRequest(url: (withUrlStr != nil) ? URL(string: withUrlStr!)! : URL(string: URLInfo.mainUrl)!)
        request.httpMethod = HTTPMethod.get.rawValue
        Alamofire.request(request).responseJSON(completionHandler: {
            res in
            switch res.result{
            case .success(let value):
                if let dict = value as? [String : Any]{
                    var moreUrl: String?
                    if let nextUrl = dict["nextUrl"] as? String{
                        moreUrl = nextUrl
                    }
                    var storyArr: [Story]? = StoryParse.parseStoryJson(value: dict)
//                    if let stories = dict["stories"] as?
//                        [[String : Any]]{
//                        for story in stories{
//                            let newStory = Story()
//                            newStory.title = story["title"] as? String
//                            newStory.coverImageURLString = story["cover"] as? String
//                            if let authorInfo = story["user"] as? [String: Any]{
//                                newStory.author = authorInfo["fullname"] as? String
//                            }
//                            storyArr.append(newStory)
//                        }
//                    }
                    
                    completion(storyArr, moreUrl, nil)
                }
            case .failure(let err):
                print("error is \(err)")
                completion(nil, nil, err)
            }
        })
    }
}


        


