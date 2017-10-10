//
//  RedditCommentCell.swift
//  Commenting
//
//  Created by Stéphane Sercu on 26/06/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit
import SwiftyComments

struct RedditConstants {
    static let sepColor = UIColor(red: 239/255, green: 239/255, blue: 237/255, alpha: 1)
    static let posterColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
    static let backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 245/255, alpha: 1)
    static let commentMarginColor = #colorLiteral(red: 0.9880551696, green: 0.988458693, blue: 0.9839059711, alpha: 1)
    static let identationColor = #colorLiteral(red: 0.929128468, green: 0.9298127294, blue: 0.9208832383, alpha: 1)
}


class RedditCommentCell: CommentCell {
    private var content:RedditCommentView {
        get {
            return self.commentViewContent as! RedditCommentView
        }
    }
    open var commentContent: String! = "content" {
        didSet {
            self.content.commentContent = commentContent
        }
    }
    open var posterName: String! = "username" {
        didSet {
            self.content.posterName = posterName
        }
    }
    open var date: String! = "" {
        didSet {
            self.content.date = date
        }
    }
    open var upvotes: Int! = 42 {
        didSet {
            self.content.upvotes = upvotes
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commentViewContent = RedditCommentView()
        self.backgroundColor = RedditConstants.backgroundColor
        self.commentMarginColor = RedditConstants.commentMarginColor
        self.indentationIndicatorColor = RedditConstants.identationColor
        self.commentMargin = 0
        self.isIndentationIndicatorsExtended = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RedditCommentView: UIView {
    open var commentContent: String! = "content" {
        didSet {
            contentLabel.text = commentContent
        }
    }
    open var posterName: String! = "username" {
        didSet {
            updateUsernameLabel()
        }
    }
    open var date: String! = "" {
        didSet {
            updateUsernameLabel()
        }
    }
    open var upvotes: Int! = 42 {
        didSet {
            self.upvotesLabel.text = "\(self.upvotes!)"
        }
    }
    private func updateUsernameLabel() {
        posterLabel.text = "\(self.posterName!) • \(self.date!)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setLayout() {
        addSubview(posterLabel)
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        posterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        posterLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        contentLabel.topAnchor.constraint(equalTo: posterLabel.bottomAnchor).isActive = true
        
        setupControlView()
        
        addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        controlView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor).isActive = true
        controlView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    

    private func setupControlView() {
        let sep1 = UIView()
        sep1.backgroundColor = #colorLiteral(red: 0.9566848874, green: 0.9570848346, blue: 0.9525371194, alpha: 1)
        let sep2 = UIView()
        sep2.backgroundColor = #colorLiteral(red: 0.9566848874, green: 0.9570848346, blue: 0.9525371194, alpha: 1)
        
        controlView.addSubview(downvoteButton)
        controlView.addSubview(upvotesLabel)
        controlView.addSubview(upvoteButton)
        controlView.addSubview(replyButton)
        controlView.addSubview(moreBtn)
        controlView.addSubview(sep1)
        controlView.addSubview(sep2)
        
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvotesLabel.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        sep1.translatesAutoresizingMaskIntoConstraints = false
        sep2.translatesAutoresizingMaskIntoConstraints = false
        
        downvoteButton.trailingAnchor.constraint(equalTo: controlView.trailingAnchor, constant: -10).isActive = true
        downvoteButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        downvoteButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        upvotesLabel.trailingAnchor.constraint(equalTo: downvoteButton.leadingAnchor, constant: -10).isActive = true
        upvotesLabel.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        upvotesLabel.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        upvoteButton.trailingAnchor.constraint(equalTo: upvotesLabel.leadingAnchor, constant: -10).isActive = true
        upvoteButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        upvoteButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        
        sep1.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        sep1.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        sep1.widthAnchor.constraint(equalToConstant: 2/UIScreen.main.scale).isActive = true
        sep1.trailingAnchor.constraint(equalTo: upvoteButton.leadingAnchor, constant: -10).isActive = true
        
        replyButton.trailingAnchor.constraint(equalTo: sep1.leadingAnchor, constant: -10).isActive = true
        replyButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        replyButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        
        sep2.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        sep2.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        sep2.widthAnchor.constraint(equalToConstant: 2/UIScreen.main.scale).isActive = true
        sep2.trailingAnchor.constraint(equalTo: replyButton.leadingAnchor, constant: -10).isActive = true
        
        moreBtn.trailingAnchor.constraint(equalTo: sep2.leadingAnchor, constant: -10).isActive = true
        moreBtn.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        moreBtn.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        moreBtn.leadingAnchor.constraint(equalTo: controlView.leadingAnchor).isActive = true

    }
    let controlView = UIView()
    let moreBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "mre"), for: .normal)
        return btn
    }()
    let replyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(" Reply", for: .normal)
        btn.setTitleColor(RedditConstants.posterColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        btn.setImage(#imageLiteral(resourceName: "exprt"), for: .normal)
        return btn
    }()
    let upvoteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "upvte"), for: .normal)
        return btn
    }()
    let upvotesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = RedditConstants.posterColor
        lbl.text = "42"
        lbl.font = UIFont.systemFont(ofSize: 11)
        return lbl
    }()
    let downvoteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "downvte"), for: .normal)
        return btn
    }()
    let contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No content"
        lbl.textColor = UIColor.black
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    let posterLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "annonymous"
        lbl.textColor = RedditConstants.posterColor
        lbl.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    
    
}
