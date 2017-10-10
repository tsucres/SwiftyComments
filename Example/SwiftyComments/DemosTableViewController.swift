//
//  DemosTableViewController.swift
//  Commenting
//
//  Created by Stéphane Sercu on 1/10/17.
//  Copyright © 2017 Stéphane Sercu. All rights reserved.
//

import UIKit

class DemosTableViewController: UITableViewController {
    private let demoNames = ["Basic", "Imgur", "Reddit", "Hackernews"]
    private let controllers = [SimpleCommentsViewController(), ImgurCommentsViewController(), RedditCommentsViewController(), HNCommentsViewController()]
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
        self.navigationController!.pushViewController(controllers[indexPath.row], animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllers.count
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
