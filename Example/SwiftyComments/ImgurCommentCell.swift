//
//  ImgurCommentCell.swift
//  Commenting
//
//  Created by Stéphane Sercu on 26/06/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit
import SwiftyComments

struct ImgurConstants {
    // CommentView (ie. the comment itself)
    static let posterColor = #colorLiteral(red: 0.6878166795, green: 0.7086901069, blue: 0.7436080575, alpha: 1)
    static let backgroundColor = #colorLiteral(red: 0.1297373474, green: 0.1288487017, blue: 0.1419626176, alpha: 1)
    
    // CommentCell (ie. outside the comment itself)
    static let commentMarginColor = #colorLiteral(red: 0.1811942458, green: 0.1874002516, blue: 0.2092511654, alpha: 1)
    static let commentMargin:CGFloat! = 3.0
    
    static let identationIndicatorColor = #colorLiteral(red: 0.460793674, green: 0.4847883582, blue: 0.5284711719, alpha: 1)
    static let indentationIndicationThickness:CGFloat! = 3.0
    
    static let indentationColor = #colorLiteral(red: 0.1811942458, green: 0.1874002516, blue: 0.2092511654, alpha: 1)
}


class ImgurCommentCell: CommentCell {
    open var content:ImgurCommentView {
        get {
            return self.commentViewContent as! ImgurCommentView
        }
    }
    open var commentContent: String! {
        get {
            return self.content.commentContent
        } set(value) {
            self.content.commentContent = value
        }
    }
    open var posterName: String! {
        get {
            return self.content.posterName
        } set(value) {
            self.content.posterName = value
        }
    }
    open var date: String! {
        get {
            return self.content.date
        } set(value) {
            self.content.date = value
        }
    }
    open var upvotes: Int! {
        get {
            return self.content.upvotes
        } set(value) {
            self.content.upvotes = value
        }
    }
    open var downvotes: Int! {
        get {
            return self.content.downvotes
        } set(value) {
            self.content.downvotes = value
        }
    }
    open var nReplies: Int! {
        get {
            return self.content.nReplies
        } set(value) {
            self.content.nReplies = value
        }
    }
    open var upvoted: Bool = false {
        didSet {
            if upvoted {
                self.content.downvoteButton.tintColor = ImgurConstants.posterColor
                self.content.upvoteButton.tintColor = .green
            } else {
                self.content.upvoteButton.tintColor = ImgurConstants.posterColor
            }
        }
    }
    open var downvoted: Bool = false {
        didSet {
            if downvoted {
                self.content.upvoteButton.tintColor = ImgurConstants.posterColor
                self.content.downvoteButton.tintColor = .red
            } else {
                self.content.downvoteButton.tintColor = ImgurConstants.posterColor
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commentViewContent = ImgurCommentView()
        
        // H-Space between comments
        self.commentMarginColor = ImgurConstants.commentMarginColor
        self.commentMargin = ImgurConstants.commentMargin
        self.rootCommentMargin = ImgurConstants.commentMargin
        self.rootCommentMarginColor = ImgurConstants.commentMarginColor
        
        // Indentation bars
        self.indentationIndicatorColor = ImgurConstants.identationIndicatorColor
        self.indentationIndicatorThickness = ImgurConstants.indentationIndicationThickness
        
        // Identation space
        self.indentationColor = ImgurConstants.indentationColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImgurCommentView: UIView {
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
    open var upvotes: Int! = 0 {
        didSet {
            self.upvoteButton.setTitle("\(upvotes ?? 0)", for: .normal)
        }
    }
    open var downvotes: Int! = 0 {
        didSet {
            self.downvoteButton.setTitle("\(downvotes ?? 0)", for: .normal)
        }
    }
    open var nReplies: Int = 0 {
        didSet {
            if nReplies == 0 {
                nRepliesLabel.isHidden = true
            } else if nReplies == 1 {
                nRepliesLabel.isHidden = false
                nRepliesLabel.text = " 1 Reply "
            } else {
                nRepliesLabel.isHidden = false
                nRepliesLabel.text = " \(nReplies) Replies "
            }
        }
    }
    
    private func updateUsernameLabel() {
        posterLabel.text = "\(self.posterName!) • \(self.date!)"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = ImgurConstants.backgroundColor
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setLayout() {
        let hMargins: CGFloat = 10
        let vMargins: CGFloat = 10
        
        
        setupHeaderView()
        addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: hMargins).isActive = true
        headerView.topAnchor.constraint(equalTo: self.topAnchor, constant: vMargins).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -hMargins).isActive = true
        
        setupControlView()
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: hMargins).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -hMargins).isActive = true
        contentLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: vMargins).isActive = true
        
        
        addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -hMargins).isActive = true
        controlView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: vMargins).isActive = true
        controlView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -vMargins).isActive = true
        controlView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: hMargins).isActive = true
    }
    
    let posterLabel = UILabel()
    let nRepliesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = " n Replies "
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.semibold)
        lbl.backgroundColor = #colorLiteral(red: 0.4529536963, green: 0.4769433141, blue: 0.5206263065, alpha: 1)
        lbl.layer.masksToBounds = true
        lbl.layer.cornerRadius = 7
        return lbl
    }()
    
    let headerView = UIView()
    
    private func setupHeaderView() {
        posterLabel.text = "annonymous"
        posterLabel.textColor = ImgurConstants.posterColor
        posterLabel.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
        posterLabel.textAlignment = .left
        
        
        headerView.addSubview(posterLabel)
        headerView.addSubview(nRepliesLabel)
        
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        nRepliesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        posterLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        posterLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        posterLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        posterLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.5, constant: -1).isActive = true
        
        nRepliesLabel.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        nRepliesLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        nRepliesLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        //nRepliesLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.5, constant: -1).isActive = true
        
        
    }
    let controlView = UIView()
    
    let upvoteButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ImgurConstants.posterColor, for: .normal)
        btn.setTitle("42", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.bold)
        btn.setImage(#imageLiteral(resourceName: "imgurUpvte").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = ImgurConstants.posterColor
        
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        return btn
    }()
    let downvoteButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(ImgurConstants.posterColor, for: .normal)
        btn.setTitle("8", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.bold)
        btn.setImage(#imageLiteral(resourceName: "imgurDownvte").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = ImgurConstants.posterColor
        
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        return btn
    }()
    let replyButton = UIButton(type: UIButton.ButtonType.custom)
    let moreBtn = UIButton(type: UIButton.ButtonType.custom)
    private func setupControlView() {
        
        replyButton.setTitle(" Reply", for: .normal)
        replyButton.setTitleColor(ImgurConstants.posterColor, for: .normal)
        replyButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.bold)
        
        
        
        
        moreBtn.setImage(#imageLiteral(resourceName: "mre"), for: .normal)
        
        controlView.addSubview(upvoteButton)
        controlView.addSubview(downvoteButton)
        controlView.addSubview(replyButton)
        controlView.addSubview(moreBtn)
        
        downvoteButton.translatesAutoresizingMaskIntoConstraints = false
        upvoteButton.translatesAutoresizingMaskIntoConstraints = false
        replyButton.translatesAutoresizingMaskIntoConstraints = false
        moreBtn.translatesAutoresizingMaskIntoConstraints = false
        
        
        upvoteButton.leadingAnchor.constraint(equalTo: controlView.leadingAnchor).isActive = true
        upvoteButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        upvoteButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        
        downvoteButton.leadingAnchor.constraint(equalTo: upvoteButton.trailingAnchor, constant: 50).isActive = true
        downvoteButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        downvoteButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        
        replyButton.leadingAnchor.constraint(equalTo: downvoteButton.trailingAnchor, constant: 50).isActive = true
        replyButton.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        replyButton.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        
        
        moreBtn.trailingAnchor.constraint(equalTo: controlView.trailingAnchor).isActive = true
        moreBtn.bottomAnchor.constraint(equalTo: controlView.bottomAnchor).isActive = true
        moreBtn.topAnchor.constraint(equalTo: controlView.topAnchor).isActive = true
        
    }
    
    var contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No content"
        lbl.textColor = UIColor.white
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    
}
