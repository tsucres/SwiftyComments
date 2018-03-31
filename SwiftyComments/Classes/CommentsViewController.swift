//
//  CommentsViewController.swift
//  Commenting
//
//  Created by Stéphane Sercu on 26/06/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//
import UIKit


/// ViewController displaying expandable comments.
open class CommentsViewController: UITableViewController {
    
    /// The list of comments correctly displayed in the tableView (in linearized form)
    var _currentlyDisplayed: [AbstractComment] = []
    open var currentlyDisplayed: [AbstractComment] {
        get {
            return _currentlyDisplayed
        } set(value) {
            if fullyExpanded {
                linearizeComments(comments: value, linearizedComments: &_currentlyDisplayed)
            } else {
                _currentlyDisplayed = value
            }
        }
    }
    
    /// If true, when a cell is expanded, the tableView will scroll to make the new cells visible
    open var makeExpandedCellsVisible: Bool = true
    
    
    open var swipeToHide: Bool = true
    
    
    open var fullyExpanded: Bool = false {
        didSet {
            if fullyExpanded {
                self.linearizeCurrentlyDisplayedComs()
            }
        }
    }
    
    open weak var delegate: CommentsViewDelegate? = nil
    
    deinit {
        //print("CommentsVC deinited!")
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // Tableview stye
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        if #available(iOS 11.0, *) {
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
        } else {
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.estimatedRowHeight = 400.0
        }
    }
    
    /**
     Helper function that takes a list of root comments and turn it in
     a linearized list of all the root + children comments.
     - Parameters:
         - comments: The input, nested, list of comments
         - linearizedComments: a reference to the list that will contain the comments
         - sort: a function that is applied recursively on each sub-list of comments
     */
    public func linearizeComments(comments: [AbstractComment], linearizedComments: inout [AbstractComment], sort: ((inout [AbstractComment])->Void)? = nil) {
        var coms = comments
        if sort != nil {
            sort!(&coms)
        }
        for c in coms {
            linearizedComments.append(c)
            linearizeComments(comments: c.replies, linearizedComments: &linearizedComments, sort: sort)
        }
    }
    
    public func linearizeCurrentlyDisplayedComs() {
        var linearizedComs: [AbstractComment] = []
        linearizeComments(comments: _currentlyDisplayed, linearizedComments: &linearizedComs)
        _currentlyDisplayed = linearizedComs
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentlyDisplayed.count
    }
    
    override open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCom: AbstractComment = _currentlyDisplayed[indexPath.row]
        let selectedIndex = indexPath.row
        
        if selectedCom.replies.count > 0 { // if expandable
            if isCellExpanded(indexPath: indexPath) {
                // collapse
                var nCellsToDelete = 0
                repeat {
                    nCellsToDelete += 1
                } while (_currentlyDisplayed.count > selectedIndex+nCellsToDelete+1 && _currentlyDisplayed[selectedIndex+nCellsToDelete+1].level > selectedCom.level)
                
                _currentlyDisplayed.removeSubrange(Range(uncheckedBounds: (lower: selectedIndex+1 , upper: selectedIndex+nCellsToDelete+1)))
                var indexPaths: [IndexPath] = []
                for i in 0..<nCellsToDelete {
                    indexPaths.append(IndexPath(row: selectedIndex+i+1, section: indexPath.section))
                }
                tableView.deleteRows(at: indexPaths, with: .bottom)
                delegate?.commentCellFolded(atIndex: selectedIndex)
            } else {
                // expand
                var toShow: [AbstractComment] = []
                if fullyExpanded {
                    linearizeComments(comments: selectedCom.replies, linearizedComments: &toShow)
                } else {
                    toShow = selectedCom.replies
                }
                _currentlyDisplayed.insert(contentsOf: toShow, at: selectedIndex+1)
                var indexPaths: [IndexPath] = []
                for i in 0..<toShow.count {
                    indexPaths.append(IndexPath(row: selectedIndex+i+1, section: indexPath.section))
                }
                tableView.insertRows(at: indexPaths, with: .bottom)
                
                if makeExpandedCellsVisible {
                    tableView.scrollToRow(at: IndexPath(row: selectedIndex+1, section: indexPath.section), at: UITableViewScrollPosition.middle, animated: false)
                }
                delegate?.commentCellExpanded(atIndex: selectedIndex)
            }
        }
    }
    
    open func isCellExpanded(indexPath: IndexPath) -> Bool {
        let com: AbstractComment = _currentlyDisplayed[indexPath.row]
        return _currentlyDisplayed.count > indexPath.row+1 &&  // if not last cell
            _currentlyDisplayed[indexPath.row+1].level > com.level // if replies are displayed
    }
    
    
    open override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return swipeToHide && isCellExpanded(indexPath: indexPath)
    }
    
    open override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let foldAction = UITableViewRowAction(style: .destructive, title: "Hide") { [weak self](action, indexPath) in
            if self != nil {
                self!.tableView(self!.tableView, didSelectRowAt: indexPath)
            }
        }
        foldAction.backgroundColor = #colorLiteral(red: 0.4147516489, green: 0.8618777394, blue: 0.8051461577, alpha: 1)
        
        return [foldAction]
    }
}
