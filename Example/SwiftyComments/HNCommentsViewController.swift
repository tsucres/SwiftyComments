//
//  HNCommentsViewController.swift
//  Commenting
//
//  Created by Stéphane Sercu on 5/07/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//
import UIKit
import SwiftyComments


class HNCommentsViewController: CommentsViewController, UITextViewDelegate {
    private let commentCellId = "hnComentCellId"
    private var allComments: [AttributedTextComment] = [] // All the comments (nested, not in a linear format)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HNCommentCell.self, forCellReuseIdentifier: commentCellId)
        
        tableView.backgroundColor = HNConstants.backgroundColor
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.beginRefreshing()
        
        // Asynchronously generating the AttributedStrings
        DispatchQueue.global(qos: .userInitiated).async {
            self.allComments = RandomDiscussion.generate().comments
            self.generateAttributedTexts(For: self.allComments)
            DispatchQueue.main.async {
                self.currentlyDisplayed = self.allComments
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            }
        }
    }
    
    func generateAttributedTexts(For comments: [AttributedTextComment]) {
        for com in comments {
            com.attributedContent = HNCommentContentParser.buildAttributedText(From: com.body!)
            self.generateAttributedTexts(For: com.replies as! [AttributedTextComment])
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = .black
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> CommentCell {
        //let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId, for: indexPath) as! HNCommentCell
        let commentCell = tableView.dequeueReusableCell(withIdentifier: commentCellId) as! HNCommentCell
        let comment = currentlyDisplayed[indexPath.row] as! AttributedTextComment
        commentCell.level = comment.level
        commentCell.commentContentAttributed = comment.attributedContent
        commentCell.posterName = comment.posterName
        commentCell.date = comment.soMuchTimeAgo()
        commentCell.nReplies = comment.replies.count
        commentCell.upvoted = comment.upvoted
        
        commentCell.content.upvoteBtn.addTarget(self, action: #selector(upvoted), for: .touchUpInside)
        commentCell.content.upvoteBtn.tag = indexPath.row
        commentCell.content.replyBtn.addTarget(self, action: #selector(replied), for: .touchUpInside)
        commentCell.content.replyBtn.tag = indexPath.row
        
        
        // ===========================================
        // If you want to experiment loading the attributedText with DocumentType.html
        // uncoment the following
        /*
        if let data = comment.body!.data(using: String.Encoding.utf8, allowLossyConversion: true) {
            commentCell.commentContentAttributed = try? NSAttributedString(data: data,
                          options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                          documentAttributes: nil)
        }
        */
        // ===========================================
        
        
        // Enable the shouldInterractWithURL
        //commentCell.content.bodyView.delegate = self
        
        return commentCell
    }
    
    @objc func upvoted(sender: UIButton) {
        print("Upvote comment at index \(sender.tag) of currentlyDisplayed")
    }
    @objc func replied(sender: UIButton) {
        print("Reply to comment at index \(sender.tag) of currentlyDisplayed")
    }
    
    // What to do when the user taps on a link in the comment
    /*func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let startPos = textView.position(from: textView.beginningOfDocument, in: .right, offset: characterRange.location)
        let endPos = textView.position(from: textView.beginningOfDocument, in: .right, offset: characterRange.location + characterRange.length)
        
        return true
    }*/
    
    
    //func textV
}
