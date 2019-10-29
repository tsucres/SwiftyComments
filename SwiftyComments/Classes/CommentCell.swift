//
//  CommentCell.swift
//  Commenting
//
//  Created by Stéphane Sercu on 24/04/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit
import SwipeCellKit

struct DefaultValues {
    static let rootCommentMarginColor = UIColor(red: 247/255, green: 247/255, blue: 245/255, alpha: 1)
    static let rootCommentMargin: CGFloat = 10
    static let commentMarginColor = UIColor.black
    static let commentMargin: CGFloat = 1
    static let identationColor = UIColor.black
    static let commentBackgroundColor = UIColor.red
    static let indentationIndicatorColor = UIColor.gray
    static let indentationIndicatorThickness: CGFloat = 1
}


/**
 This class manages everything relating to the level of the
 comment: identations, background colors, spacings, etc...
 */
open class CommentCell: SwipeTableViewCell {
    /// Color of the separation between 2 root comments
    open var rootCommentMarginColor: UIColor! = DefaultValues.rootCommentMarginColor {
        didSet {
            updateCommentMargin()
        }
    }
    /// Space between 2 root comments
    open var rootCommentMargin: CGFloat! = DefaultValues.rootCommentMargin {
        didSet {
            updateCommentMargin()
        }
    }
    /// Color of the separation between 2 indented comments
    open var commentMarginColor: UIColor! = DefaultValues.commentMarginColor {
        didSet {
            updateCommentMargin()
        }
    }
    /// Space between 2 indented comments
    open var commentMargin: CGFloat! = DefaultValues.commentMargin {
        didSet {
            updateCommentMargin()
        }
    }
    /// Color of the space above an indented comment
    open var indentationColor: UIColor! {//= DefaultValues.identationColor {
        get {
            return backgroundColor
        } set(value) {
            backgroundColor = value
        }
    }
    
    /// Color of the vertical indentation indicators
    open var indentationIndicatorColor: UIColor! = DefaultValues.indentationIndicatorColor {
        didSet {
            updateIndentationIndicators()
        }
    }
    
    /// Thickness of the vertical indentation indicators
    open var indentationIndicatorThickness: CGFloat! = CGFloat(DefaultValues.indentationIndicatorThickness) {
        didSet {
            updateIndentationIndicators()
        }
    }
    
    /// Indicates weither the vertical indentation indicators extends to the replies
    open var isIndentationIndicatorsExtended: Bool! = false {
        didSet {
            updateIndentationIndicators()
        }
    }
    
    /// Defines the identation per level
    open var indentationUnit = 10 {
        didSet {
            indentationConstraint?.constant = CGFloat(self.level*indentationUnit)
            updateIndentationIndicators()
            updateCommentMargin()
        }
    }
    
    open var level = 0 {
        didSet {
            contentView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight // solves a warning (http://stackoverflow.com/questions/26100053/uitableviewcells-contentview-gets-unwanted-height-44-constraint)
            indentationConstraint?.constant = CGFloat(self.level*indentationUnit)
            updateIndentationIndicators()
            updateCommentMargin()
        }
    }
    
    
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        indentationColor = DefaultValues.identationColor
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupView() {
        updateIndentationIndicators()
        setupCommentMargin()
        
        contentView.addSubview(commentView)
        commentView.translatesAutoresizingMaskIntoConstraints = false
        commentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        indentationConstraint = commentView.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: CGFloat(self.level*indentationUnit))
        indentationConstraint?.isActive = true
        commentView.topAnchor.constraint(equalTo: hSeparator.bottomAnchor).isActive = true
        commentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    
    private let commentView:UIView! = UIView()
    
    
    /// This is the key element of the class. It's the actual view of a comment.
    open var commentViewContent: UIView? {
        get {
            if self.commentView.subviews.count > 0 {
                return self.commentView.subviews[0]
            }
            return nil
        } set(v) {
            commentView.subviews.forEach({ $0.removeFromSuperview() })
            if v != nil {
                commentView.addSubview(v!)
                v!.translatesAutoresizingMaskIntoConstraints = false
                v!.trailingAnchor.constraint(equalTo: commentView.trailingAnchor).isActive = true
                v!.leadingAnchor.constraint(equalTo: commentView.leadingAnchor).isActive = true
                v!.topAnchor.constraint(equalTo: commentView.topAnchor).isActive = true
                v!.bottomAnchor.constraint(equalTo: commentView.bottomAnchor).isActive = true
            }
        }
    }
    
    // Indentation
    private var indentationConstraint: NSLayoutConstraint?
    
    // Vertical indentation indicators
    private var vSeparators: [UIView] = []
    private func updateIndentationIndicators() {
        // Remove the eventual existing ones
        vSeparators.forEach({(body) in
            body.removeFromSuperview()
        })
        if self.level > 0 { // No indicators for root comments
            let n = self.isIndentationIndicatorsExtended! ? self.level : 1 // number of indicators to draw
            for i in 1...n {
                let sep = UIView()
                vSeparators.append(sep)
                contentView.addSubview(sep)
                sep.translatesAutoresizingMaskIntoConstraints = false
                sep.topAnchor.constraint(equalTo: contentView.topAnchor, constant:commentMargin).isActive = true
                sep.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
                sep.widthAnchor.constraint(equalToConstant: indentationIndicatorThickness).isActive = true
                sep.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: CGFloat((self.level-i+1)*indentationUnit)).isActive = true
                sep.backgroundColor = indentationIndicatorColor
            }
        }
    }
    
    // Horizontal separator
    private var hSeparator = UIView()
    private var hSepHeightConstraint: NSLayoutConstraint?
    private var hSepLeadingConstraint: NSLayoutConstraint?
    private func setupCommentMargin() {
        contentView.addSubview(hSeparator)
        hSeparator.translatesAutoresizingMaskIntoConstraints = false
        hSeparator.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        hSepHeightConstraint = hSeparator.leadingAnchor.constraint(
            equalTo: contentView.leadingAnchor,
            constant: CGFloat(self.level*indentationUnit))
        hSepHeightConstraint?.isActive = true
        hSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        if self.level == 0 {
            hSeparator.backgroundColor = self.rootCommentMarginColor
            hSepHeightConstraint = hSeparator.heightAnchor.constraint(equalToConstant: self.rootCommentMargin)
            
        } else {
            hSeparator.backgroundColor = self.commentMarginColor
            hSepHeightConstraint = hSeparator.heightAnchor.constraint(equalToConstant: self.commentMargin)
        }
        hSepHeightConstraint?.isActive = true
    }
    private func updateCommentMargin() {
        hSepHeightConstraint?.constant = CGFloat(self.level*indentationUnit)
        if self.level == 0 {
            hSeparator.backgroundColor = self.rootCommentMarginColor
            hSepHeightConstraint?.constant = self.rootCommentMargin
            
        } else {
            hSeparator.backgroundColor = self.commentMarginColor
            hSepHeightConstraint?.constant = self.commentMargin
        }
    }
    
}

