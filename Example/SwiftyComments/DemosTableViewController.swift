//
//  DemosTableViewController.swift
//  Commenting
//
//  Created by Stéphane Sercu on 1/10/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit

class DemosTableViewController: UITableViewController {
    private let demoNames = ["Basic", "Imgur", "Reddit", "Hackernews", "Imgur - Full expanded"]
    
    private let controllerClasses = [SimpleCommentsViewController.self, ImgurCommentsViewController.self, RedditCommentsViewController.self, HNCommentsViewController.self, FullyExpandedImgurVC.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        UIApplication.shared.statusBarStyle = .default
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
