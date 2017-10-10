//
//  ViewController.swift
//  Commenting
//
//  Created by Stéphane Sercu on 15/04/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit
import SwiftyComments

/// Simplest implementation, colored to show the different zones in a commentCell.
class SimpleCommentsViewController: CommentsViewController, UITextViewDelegate {
    private let commentCellId = "simpleCommentCellId"
    var allComments: [RichComment] = [] // All the comments (nested, not in a linear format)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SimpleCommentCell.self, forCellReuseIdentifier: commentCellId)
        
        allComments = RandomDiscussion.generate().comments
        currentlyDisplayed = allComments

    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CommentCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! SimpleCommentCell
        let comment = currentlyDisplayed[indexPath.row] as! RichComment
        commentCell.level = comment.level
        commentCell.commentContent = comment.body
        commentCell.posterName = comment.posterName
        return commentCell
    }
    
}










