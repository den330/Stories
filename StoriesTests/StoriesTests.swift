//
//  StoriesTests.swift
//  StoriesTests
//
//  Created by 330Mac on 2019-01-09.
//  Copyright © 2019 Yaxin Yuan. All rights reserved.
//

import XCTest

class StoriesTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEmptyStoryParse() {
        XCTAssertTrue(StoryParse.parseStoryJson(value: "")!.isEmpty)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    func testExpectedStoryParse(){
        let jsonToBeTested = ["stories": [["title": "title", "cover": "cover", "user": ["fullname": "name"]]]]
        let story = Story()
        story.author = "name"
        story.coverImageURLString = "cover"
        story.title = "title"
        let expectedOutput = [story]
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
