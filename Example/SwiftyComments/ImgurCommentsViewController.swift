//
//  ImgurCommentsViewController.swift
//  Commenting
//
//  Created by Stéphane Sercu on 27/06/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit
import SwiftyComments

class FullyExpandedImgurVC: ImgurCommentsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fullyExpanded = true
    }
}
class ImgurCommentsViewController: CommentsViewController {
    private let commentCellId = "imgurComentCellId"
    var allComments: [RichComment] = [] // All the comments (nested, not in a linear format)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ImgurCommentCell.self, forCellReuseIdentifier: commentCellId)
        
        tableView.backgroundColor = ImgurConstants.backgroundColor
        
        allComments = RandomDiscussion.generate().comments
        
        //linearizeComments(comments: allComments, linearizedComment: &currentlyDisplayed)
        
        currentlyDisplayed = allComments
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CommentCell {
        let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! ImgurCommentCell
        let comment = currentlyDisplayed[indexPath.row] as! RichComment
        commentCell.level = comment.level
        commentCell.commentContent = comment.body
        commentCell.posterName = comment.posterName
        commentCell.date = comment.soMuchTimeAgo()
        commentCell.upvotes = comment.upvotes ?? 0
        commentCell.downvotes = comment.downvotes ?? 0
        commentCell.nReplies = comment.replies.count
        
        commentCell.content.upvoteButton.tag = indexPath.row
        commentCell.content.upvoteButton.addTarget(self, action: #selector(upvoted(sender:)), for: .touchUpInside)
        
        commentCell.content.downvoteButton.tag = indexPath.row
        commentCell.content.downvoteButton.addTarget(self, action: #selector(downvoted(sender:)), for: .touchUpInside)
        

        commentCell.upvoted = comment.upvoted
        commentCell.downvoted = comment.downvoted
        return commentCell
    }
    
    @objc func upvoted(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? ImgurCommentCell {
            let intendToUpvote = !cell.upvoted
            cell.upvoted = intendToUpvote
            if cell.upvotes != nil {
                cell.upvotes! += Int((intendToUpvote ? 1 : -1))
            }
            if cell.downvoted {
                cell.downvoted = false
                cell.downvotes! -= 1
            }
            
            if let comment = currentlyDisplayed[sender.tag] as? RichComment {
                comment.upvoted = intendToUpvote
                if comment.upvotes != nil {
                    comment.upvotes! += Int((intendToUpvote ? 1 : -1))
                }
                if comment.downvoted {
                    comment.downvoted = false
                    comment.downvotes! -= 1
                }
            }
        }
    }
    @objc func downvoted(sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? ImgurCommentCell {
            let intendToDownvote = !cell.downvoted
            cell.downvoted = intendToDownvote
            if cell.downvotes != nil {
                cell.downvotes! += Int((intendToDownvote ? 1 : -1))
            }
            if cell.upvoted {
                cell.upvoted = false
                cell.upvotes! -= 1
            }
            if let comment = currentlyDisplayed[sender.tag] as? RichComment {
                comment.downvoted = intendToDownvote
                if comment.downvotes != nil {
                    comment.downvotes! += Int((intendToDownvote ? 1 : -1))
                }
                if comment.upvoted {
                    comment.upvoted = false
                    comment.upvotes! -= 1
                }
            }
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = ImgurConstants.backgroundColor
        self.navigationController?.navigationBar.tintColor = ImgurConstants.posterColor
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
