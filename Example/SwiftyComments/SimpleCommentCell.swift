//
//  SimpleCommentView.swift
//  Commenting
//
//  Created by Stéphane Sercu on 24/04/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit
import SwiftyComments

class SimpleCommentCell: CommentCell {
    var content:SimpleCommentView {
        get {
            return self.commentViewContent as! SimpleCommentView
        }
    }
    open var commentContent: String! = "content" {
        didSet {
            (self.commentViewContent as! SimpleCommentView).commentContent = commentContent
        }
    }
    open var posterName: String! {
        get {
            return self.content.posterName
        } set(value) {
            self.content.posterName = value
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commentViewContent = SimpleCommentView()
        
        
        self.rootCommentMarginColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        self.rootCommentMargin = 20
        self.commentMarginColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        self.commentMargin = 10
        self.indentationColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        self.indentationIndicatorColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        self.indentationIndicatorThickness = 5
        self.indentationUnit = 40
        
        self.commentViewContent?.backgroundColor = .gray
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SimpleCommentView: UIView {
    open var commentContent: String! = "content" {
        didSet {
            contentLabel.text = commentContent
        }
    }
    open var posterName: String! = "username" {
        didSet {
            posterLabel.text = posterName
        }
    }
    
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        let margin: CGFloat = 10
        
        addSubview(posterLabel)
        posterLabel.translatesAutoresizingMaskIntoConstraints = false
        posterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin).isActive = true
        posterLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin).isActive = true
        
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: margin).isActive = true
        contentLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
        contentLabel.topAnchor.constraint(equalTo: posterLabel.bottomAnchor).isActive = true
        
        
        addSubview(controlView)
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -margin).isActive = true
        controlView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor).isActive = true
        controlView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    var contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "No content"
        lbl.textColor = UIColor.black
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.regular)
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    var posterLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "annonymous"
        lbl.textColor = #colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.regular)
        lbl.textAlignment = .left
        return lbl
    }()
    var controlView: UIView = {
        let v = UIView()
        let actionBtn = UIButton(type: UIButton.ButtonType.infoDark)
        actionBtn.setTitle("Like", for: .normal)
        
        v.addSubview(actionBtn)
        
        actionBtn.translatesAutoresizingMaskIntoConstraints = false
        
        actionBtn.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -10).isActive = true
        actionBtn.bottomAnchor.constraint(equalTo: v.bottomAnchor).isActive = true
        actionBtn.topAnchor.constraint(equalTo: v.topAnchor).isActive = true
        actionBtn.leadingAnchor.constraint(equalTo: v.leadingAnchor).isActive = true
        
        return v
    }()
}
