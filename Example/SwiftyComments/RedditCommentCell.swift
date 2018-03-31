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
    static let sepColor = #colorLiteral(red: 0.9686660171, green: 0.9768124223, blue: 0.9722633958, alpha: 1)
    static let backgroundColor = #colorLiteral(red: 0.9961144328, green: 1, blue: 0.9999337792, alpha: 1)
    static let commentMarginColor = RedditConstants.backgroundColor
    static let rootCommentMarginColor = #colorLiteral(red: 0.9332661033, green: 0.9416968226, blue: 0.9327681065, alpha: 1)
    static let identationColor = #colorLiteral(red: 0.929128468, green: 0.9298127294, blue: 0.9208832383, alpha: 1)
    static let metadataFont = UIFont.systemFont(ofSize: 13, weight: .regular)
    static let metadataColor = #colorLiteral(red: 0.6823018193, green: 0.682382822, blue: 0.6822645068, alpha: 1)
    static let textFont = UIFont.systemFont(ofSize: 15, weight: .regular)
    static let textColor = #colorLiteral(red: 0.4042215049, green: 0.4158815145, blue: 0.4158077836, alpha: 1)
    static let controlsColor = #colorLiteral(red: 0.7295756936, green: 0.733242631, blue: 0.7375010848, alpha: 1)
    static let flashyColor = #colorLiteral(red: 0.1220618263, green: 0.8247511387, blue: 0.7332885861, alpha: 1)
}


class RedditCommentCell: CommentCell {
    private var content:RedditCommentView {
        get {
            return self.commentViewContent as! RedditCommentView
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
    open var isFolded: Bool {
        get {
            return self.content.isFolded
        } set(value) {
            if value != isFolded {
                UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [.autoreverse], animations: {
                    self.backgroundColor = RedditConstants.flashyColor.withAlphaComponent(0.06)
                }, completion: { (done) in
                    self.backgroundColor = RedditConstants.backgroundColor
                })
                
                self.content.isFolded = value
            }
            
        }
    }
    lazy var foldBackgroundColorAnimation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "backgroundColor")
        anim.duration = 1.0;
        anim.autoreverses = true
        var h:CGFloat = 0.0, s:CGFloat = 0.0, l:CGFloat = 0.0, a:CGFloat = 0.0
        RedditConstants.backgroundColor.getHue(&h, saturation: &s, brightness: &l, alpha: &a)
        anim.fromValue = RedditConstants.backgroundColor
        anim.toValue = UIColor.init(hue: h, saturation: s, brightness: l+0.2, alpha: a);
        return anim;
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commentViewContent = RedditCommentView()
        self.backgroundColor = RedditConstants.backgroundColor
        self.commentMarginColor = RedditConstants.commentMarginColor
        self.rootCommentMargin = 8
        self.rootCommentMarginColor = RedditConstants.rootCommentMarginColor
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
    open var isFolded: Bool! = false {
        didSet {
            if isFolded {
                fold()
            } else {
                unfold()
            }
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
    
    private func fold() {
        contentHeightConstraint?.isActive = true
        controlBarHeightConstraint?.isActive = true
        controlView.isHidden = true
    }
    private func unfold() {
        contentHeightConstraint?.isActive = false
        controlBarHeightConstraint?.isActive = false
        controlView.isHidden = false
    }
    private var contentHeightConstraint: NSLayoutConstraint?
    private var controlBarHeightConstraint: NSLayoutConstraint?
    
    
    private func setLayout() {
        addSubview(posterLabel)
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        posterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        posterLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        contentLabel.topAnchor.constraint(equalTo: posterLabel.bottomAnchor, constant: 3).isActive = true
        contentHeightConstraint = contentLabel.heightAnchor.constraint(equalToConstant: 0)
        setupControlView()
        
        addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        controlView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 5).isActive = true
        controlView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        controlBarHeightConstraint = controlView.heightAnchor.constraint(equalToConstant: 0)
    }
    

    private func setupControlView() {
        let sep1 = UIView()
        sep1.backgroundColor = RedditConstants.sepColor
        let sep2 = UIView()
        sep2.backgroundColor = RedditConstants.sepColor
        
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
        btn.setImage(#imageLiteral(resourceName: "mre").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = RedditConstants.controlsColor
        return btn
    }()
    let replyButton: UIButton = {
        let btn = UIButton()
        btn.setTitle(" Reply", for: .normal)
        btn.setTitleColor(RedditConstants.controlsColor, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        btn.setImage(#imageLiteral(resourceName: "exprt").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = RedditConstants.controlsColor
        return btn
    }()
    let upvoteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "upvte").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = RedditConstants.controlsColor
        return btn
    }()
    let upvotesLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = RedditConstants.controlsColor
        lbl.text = "42"
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return lbl
    }()
    let downvoteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "downvte").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = RedditConstants.controlsColor
        return btn
    }()
    let contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No content"
        lbl.textColor = RedditConstants.textColor
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = RedditConstants.textFont
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    let posterLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "annonymous"
        lbl.textColor = RedditConstants.metadataColor
        lbl.font = RedditConstants.metadataFont
        lbl.textAlignment = .left
        return lbl
    }()
    
}
