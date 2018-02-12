//
//  MockupData.swift
//  SwiftyComments_Example
//
//  Created by Stéphane Sercu on 9/10/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyComments

class RandomDiscussion {
    var comments: [AttributedTextComment]! = []
    
    
    /**
     Generate a random list of comments
     - note: the postedDate of the replies may be anterior to the comment they are a reply to, and you know what? No one cares.
     - parameters:
     - size: number of root comments
     - maximumChildren: maximum number of replies to a comment. This number is randomly chosen.
     */
    static func generate(size: Int = 10, maximumChildren: Int = 4) -> RandomDiscussion {
        let discussion = RandomDiscussion()
        for _ in 0 ..< size {
            var rootComment = randomComent()
            addReplyRecurs(&rootComment, maximumChildren: maximumChildren)
            discussion.comments.append(rootComment)
        }
        return discussion
    }
    
    /**
     Generate a random, lipsum-filled, comment.
     */
    static func randomComent() -> AttributedTextComment {
        let com = AttributedTextComment()
        com.id = Int(arc4random_uniform(100000)) + 1
        com.body = Lorem.sentences(Int(arc4random_uniform(4)) + 1)
        com.posterName = Lorem.word
        com.postedDate = Double(arc4random_uniform(UInt32(1483228800 - 1262304000)-1)) + 1262304000
        com.upvotes = Int(arc4random_uniform(500)) + 1
        com.downvotes = Int(arc4random_uniform(100)) + 1
        com.title = Lorem.sentence
        return com
    }
    
    /**
     Recursively add a random number of replies to parent.
     At each recursion, the maximum number of children is
     decreased by 1 until it reaches 0.
     */
    private static func addReplyRecurs( _ parent: inout AttributedTextComment, maximumChildren: Int) {
        if maximumChildren == 0 { return }
        for _ in 0..<(Int(arc4random_uniform(UInt32(maximumChildren-1))) + 1) {
            var com = randomComent()
            parent.addReply(com)
            com.replyTo = parent
            com.level = parent.level+1
            addReplyRecurs(&com, maximumChildren: maximumChildren-1)
        }
        
    }
    
    
}

/// Model of a comment with attributedText content.
class AttributedTextComment: RichComment {
    var attributedContent: NSAttributedString?
}


/**
 This class models a comment with all the most
 common attributes in the commenting systems.
 It's used as an exemple through the implemented
 commenting systems.
 **/
class RichComment: BaseComment {
    var id: Int?
    var upvotes: Int?
    var downvotes: Int?
    var body: String?
    var title: String?
    var posterName: String?
    var postedDate: Double? // epochtime (since 1970)
    var upvoted: Bool = false
    var downvoted: Bool = false
    var isFolded: Bool = false
    
    /**
     Express the postedDate in following format: "[x] [time period] ago"
     */
    func soMuchTimeAgo() -> String? {
        if self.postedDate == nil {
            return nil
        }
        let diff = Date().timeIntervalSince1970 - self.postedDate!
        var str: String = ""
        if  diff < 60 {
            str = "now"
        } else if diff < 3600 {
            let out = Int(round(diff/60))
            str = (out == 1 ? "1 minute ago" : "\(out) minutes ago")
        } else if diff < 3600 * 24 {
            let out = Int(round(diff/3600))
            str = (out == 1 ? "1 hour ago" : "\(out) hours ago")
        } else if diff < 3600 * 24 * 2 {
            str = "yesterday"
        } else if diff < 3600 * 24 * 7 {
            let out = Int(round(diff/(3600*24)))
            str = (out == 1 ? "1 day ago" : "\(out) days ago")
        } else if diff < 3600 * 24 * 7 * 4{
            let out = Int(round(diff/(3600*24*7)))
            str = (out == 1 ? "1 week ago" : "\(out) weeks ago")
        } else if diff < 3600 * 24 * 7 * 4 * 12{
            let out = Int(round(diff/(3600*24*7*4)))
            str = (out == 1 ? "1 month ago" : "\(out) months ago")
        } else {//if diff < 3600 * 24 * 7 * 4 * 12{
            let out = Int(round(diff/(3600*24*7*4*12)))
            str = (out == 1 ? "1 year ago" : "\(out) years ago")
        }
        return str
    }
}

class BaseComment: AbstractComment {
    var replies: [AbstractComment]! = []
    var level: Int!
    weak var replyTo: AbstractComment?
    
    convenience init() {
        self.init(level: 0, replyTo: nil)
    }
    init(level: Int, replyTo: BaseComment?) {
        self.level = level
        self.replyTo = replyTo
    }
    func addReply(_ reply: BaseComment) {
        self.replies.append(reply)
    }
    
}

