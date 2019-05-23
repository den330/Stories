//
//  StoryParse.swift
//  Stories
//
//  Created by 330Mac on 2019-01-09.
//  Copyright © 2019 Yaxin Yuan. All rights reserved.
//

import Foundation

class StoryParse{
    class func parseStoryJson(value: Any) -> [Story]?{
        var storyArr: [Story] = []
        if let dict = value as? [String : Any]{
            if let stories = dict["stories"] as?
                [[String : Any]]{
                for story in stories{
                    let newStory = Story()
                    newStory.title = story["title"] as? String
                    newStory.coverImageURLString = story["cover"] as? String
                    if let authorInfo = story["user"] as? [String: Any]{
                        newStory.author = authorInfo["fullname"] as? String
                    }
                    storyArr.append(newStory)
                }
            }
        }
        return storyArr
    }
}
