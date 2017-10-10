//
//  RedditCommentsViewController.swift
//  Commenting
//
//  Created by Stéphane Sercu on 27/06/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit
import SwiftyComments


class RedditCommentsViewController: CommentsViewController {
    private let commentCellId = "redditComentCellId"
    var allComments: [RichComment] = [] // All the comments (nested, not in a linear format)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RedditCommentCell.self, forCellReuseIdentifier: commentCellId)
        
        tableView.backgroundColor = RedditConstants.backgroundColor
        
        allComments = RandomDiscussion.generate().comments
        
        currentlyDisplayed = allComments
        //linearizeComments(comments: allComments, linearizedComment: &currentlyDisplayed)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CommentCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! RedditCommentCell
        let comment = currentlyDisplayed[indexPath.row] as! RichComment
        commentCell.level = comment.level
        commentCell.commentContent = comment.body
        commentCell.posterName = comment.posterName
        commentCell.date = comment.soMuchTimeAgo()
        commentCell.upvotes = comment.upvotes
        
        return commentCell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        UIApplication.shared.statusBarStyle = .default
    }
}
