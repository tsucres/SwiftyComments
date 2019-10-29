//
//  DemosTableViewController.swift
//  Commenting
//
//  Created by Stéphane Sercu on 1/10/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit

class DemosTableViewController: UITableViewController {
    private let demoNames = ["Basic", "Imgur", "Reddit", "Hackernews", "Hackernews - foldable", "Imgur - Full expanded", "Reddit - foldable"]
    
    private let controllerClasses = [SimpleCommentsViewController.self,
                                     ImgurCommentsViewController.self,
                                     RedditCommentsViewController.self,
                                     HNCommentsViewController.self,
                                     FoldableHNCommentsViewController.self,
                                     FullyExpandedImgurVC.self,
                                     FoldableRedditCommentsViewController.self]
    
    private var defaultNavBarTintColor: UIColor?
    private var defaultNavTintColor: UIColor?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaultNavBarTintColor = self.navigationController?.navigationBar.barTintColor
        self.defaultNavTintColor = self.navigationController?.navigationBar.tintColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.barTintColor = .systemBackground
            self.navigationController?.navigationBar.tintColor = .label
        } else {
            self.navigationController?.navigationBar.barTintColor = self.defaultNavBarTintColor ?? .white
            self.navigationController?.navigationBar.tintColor = self.defaultNavTintColor ?? .black
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController!.pushViewController(controllerClasses[indexPath.row].init(), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllerClasses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellId)
        }
        cell!.textLabel?.text = demoNames[indexPath.row]
        return cell!
    }
}
