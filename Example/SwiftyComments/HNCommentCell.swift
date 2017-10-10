//
//  HNCommentCell.swift
//  Commenting
//
//  Created by Stéphane Sercu on 5/07/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit
import SwiftyComments

struct HNConstants {
    static let sepColor = #colorLiteral(red: 0.09410729259, green: 0.09412366897, blue: 0.09409976751, alpha: 1)
    static let posterColor = UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
    static let backgroundColor = #colorLiteral(red: 0.09410729259, green: 0.09412366897, blue: 0.09409976751, alpha: 1)
    static let commentMarginColor = #colorLiteral(red: 0.09410729259, green: 0.09412366897, blue: 0.09409976751, alpha: 1)
    static let identationColor = #colorLiteral(red: 0.09410729259, green: 0.09412366897, blue: 0.09409976751, alpha: 1)
}


class HNCommentCell: CommentCell {
    var content:HNCommentView {
        get {
            return self.commentViewContent as! HNCommentView
        }
    }
    open var commentContentAttributed: NSAttributedString? {
        didSet {
            self.content.body = commentContentAttributed
        }
    }
    open var posterName: String! = "username" {
        didSet {
            self.content.posterName = posterName
        }
    }
    open var date: String! = "0 hour ago" {
        didSet {
            self.content.date = date
        }
    }
    open var nReplies: Int! = 0 {
        didSet {
            self.content.nReplies = nReplies
        }
    }
    open var upvoted: Bool = false {
        didSet {
            self.content.upvoted = upvoted
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commentViewContent = HNCommentView()
        self.backgroundColor = HNConstants.backgroundColor
        self.commentMarginColor = HNConstants.commentMarginColor
        self.indentationIndicatorColor = HNConstants.identationColor
        self.rootCommentMarginColor = #colorLiteral(red: 0.1176350638, green: 0.117654033, blue: 0.1176263615, alpha: 1)
        self.indentationColor = #colorLiteral(red: 0.1176350638, green: 0.117654033, blue: 0.1176263615, alpha: 1)
        self.commentMargin = 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HNCommentView: UIView {
    var body: NSAttributedString? {
        didSet {
            self.bodyView.attributedText = body
        }
    }
    
    var posterName: String? {
        didSet {
            self.usernameView.setTitle(posterName, for: .normal)
        }
    }
    
    var date: String! {
        didSet {
            self.createdView.text = date
        }
    }
    
    var nReplies: Int! {
        didSet {
            if nReplies > 0 {
                self.nRepliesLabel.text = "\(nReplies!) replies"
            } else {
                self.nRepliesLabel.text = ""
            }
            
        }
    }
    var upvoted: Bool = false {
        didSet {
            self.upvoteBtn.tintColor = upvoted ? #colorLiteral(red: 0.08024211973, green: 0.7872473598, blue: 0.2486046553, alpha: 1) : #colorLiteral(red: 0.4038896859, green: 0.4039401412, blue: 0.4038665593, alpha: 1)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = HNConstants.backgroundColor
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let HMargin: CGFloat = 8
    private let VMargin: CGFloat = 8
    func setupLayout() {
        
        
        self.addSubview(usernameView)
        usernameView.translatesAutoresizingMaskIntoConstraints = false
        usernameView.topAnchor.constraint(equalTo: self.topAnchor, constant: VMargin).isActive = true
        usernameView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: HMargin).isActive = true
        
        self.addSubview(createdView)
        createdView.translatesAutoresizingMaskIntoConstraints = false
        createdView.leadingAnchor.constraint(equalTo: usernameView.trailingAnchor, constant: 5).isActive = true
        createdView.centerYAnchor.constraint(equalTo: usernameView.centerYAnchor).isActive = true
        
        self.addSubview(nRepliesLabel)
        nRepliesLabel.translatesAutoresizingMaskIntoConstraints = false
        nRepliesLabel.centerYAnchor.constraint(equalTo: usernameView.centerYAnchor).isActive = true
        nRepliesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        
        self.addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.topAnchor.constraint(equalTo: usernameView.bottomAnchor).isActive = true
        bodyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        bodyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: HMargin).isActive = true
        
        setupControlBar()
        
    }
    
    /// Add Upvote & Reply buttons (and helper labels) to the view
    private func setupControlBar() {
        let controlBarContainerView = UIView()
        
       
        controlBarContainerView.addSubview(replyBtn)
        replyBtn.translatesAutoresizingMaskIntoConstraints = false
        replyBtn.topAnchor.constraint(equalTo: controlBarContainerView.topAnchor).isActive = true
        replyBtn.bottomAnchor.constraint(equalTo: controlBarContainerView.bottomAnchor).isActive = true
        replyBtn.trailingAnchor.constraint(equalTo: controlBarContainerView.trailingAnchor).isActive = true
        replyBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
     
        controlBarContainerView.addSubview(upvoteBtn)
        upvoteBtn.translatesAutoresizingMaskIntoConstraints = false
        upvoteBtn.topAnchor.constraint(equalTo: controlBarContainerView.topAnchor).isActive = true
        upvoteBtn.bottomAnchor.constraint(equalTo: controlBarContainerView.bottomAnchor).isActive = true
        upvoteBtn.trailingAnchor.constraint(equalTo: replyBtn.leadingAnchor, constant: -15).isActive = true
        upvoteBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        upvoteBtn.leadingAnchor.constraint(equalTo: controlBarContainerView.leadingAnchor).isActive = true
        
        self.addSubview(controlBarContainerView)
        controlBarContainerView.translatesAutoresizingMaskIntoConstraints = false
        controlBarContainerView.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 5).isActive = true
        controlBarContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -HMargin).isActive = true
        controlBarContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -VMargin).isActive = true
        
    }
    
    let nRepliesLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "0 reply"
        lbl.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.thin)
        return lbl
    }()
    let upvoteBtn: UIButton = {
        let btn = UIButton()
        let img = #imageLiteral(resourceName: "hadUpvte").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.setTitle("Upvote", for: .normal)
        
        
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        btn.setTitleColor(#colorLiteral(red: 0.4038896859, green: 0.4039401412, blue: 0.4038665593, alpha: 1), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        btn.tintColor = #colorLiteral(red: 0.4038896859, green: 0.4039401412, blue: 0.4038665593, alpha: 1)
        
        return btn
    }()
    let replyBtn: UIButton = {
        let btn = UIButton()
        let img = #imageLiteral(resourceName: "HNRespond").withRenderingMode(.alwaysTemplate)
        btn.setImage(img, for: .normal)
        btn.setTitle("Reply", for: .normal)
        
        
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.thin)
        btn.setTitleColor(#colorLiteral(red: 0.4038896859, green: 0.4039401412, blue: 0.4038665593, alpha: 1), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        btn.tintColor = #colorLiteral(red: 0.4038896859, green: 0.4039401412, blue: 0.4038665593, alpha: 1)
        
        return btn
    }()
    
    let bodyView: UITextView = {
        let lbl = UITextView()
        lbl.isEditable = false
        lbl.isScrollEnabled = false
        lbl.textAlignment = .left
        lbl.backgroundColor = .clear
        lbl.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        return lbl
    }()

    let usernameView: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .normal)
        btn.setTitle("Anonymous", for: .normal)
        btn.titleLabel!.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        return btn
    }()
    let createdView: UILabel = {
        let lbl = UILabel()
        lbl.text = "6 days ago"
        lbl.textColor = #colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.thin)
        return lbl
    }()
    
}




