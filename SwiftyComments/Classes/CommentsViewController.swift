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
    open var currentlyDisplayed: [AbstractComment] = []
    
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
        let selectedCom: AbstractComment = currentlyDisplayed[indexPath.row]
        let selectedIndex = indexPath.row
        
        if selectedCom.replies.count > 0 { // if expandable
            if currentlyDisplayed.count > selectedIndex+1 &&  // if not last cell
                currentlyDisplayed[selectedIndex+1].level > selectedCom.level { // if replies are displayed
                // collapse
                var nCellsToDelete = 0
                repeat {
                    nCellsToDelete += 1
                } while (currentlyDisplayed.count > selectedIndex+nCellsToDelete+1 && currentlyDisplayed[selectedIndex+nCellsToDelete+1].level > selectedCom.level)
                
                currentlyDisplayed.removeSubrange(Range(uncheckedBounds: (lower: selectedIndex+1 , upper: selectedIndex+nCellsToDelete+1)))
                var indexPaths: [IndexPath] = []
                for i in 0..<nCellsToDelete {
                    indexPaths.append(IndexPath(row: selectedIndex+i+1, section: indexPath.section))
                }
                tableView.deleteRows(at: indexPaths, with: .top)
            } else {
                // expand
                currentlyDisplayed.insert(contentsOf: selectedCom.replies, at: selectedIndex+1)
                var indexPaths: [IndexPath] = []
                for i in 0..<selectedCom.replies.count {
                    indexPaths.append(IndexPath(row: selectedIndex+i+1, section: indexPath.section))
                }
                tableView.insertRows(at: indexPaths, with: .top)
            }
        }
    }
}
