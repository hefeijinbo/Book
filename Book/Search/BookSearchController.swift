//
//  BookSearchController.swift
//  Book
//
//  Created by 金波 on 15/12/27.
//  Copyright © 2015年 jikexueyuan. All rights reserved.
//

import UIKit

class BookSearchController: UIViewController,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate {
    
    weak var bookController:BookViewController!
    let SearchPlaceholder = "搜索图书"
    var searchController = UISearchController()
    var searchTitles = [String]()

    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        searchController = UISearchController(searchResultsController: self)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = SearchPlaceholder
        searchController.searchBar.tintColor = UIColor.whiteColor()
        searchController.searchBar.subviews[0].subviews[0].removeFromSuperview()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let tag = searchController.searchBar.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) where !tag.isEmpty {
            
            NetManager.getBookTitles(tag, page: 0, resultClosure: { (titles) -> Void in
                self.searchTitles = titles
                self.tableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchController.active = false
        bookController.tag = searchTitles[indexPath.row]
        bookController.tableView.headerBeginRefresh()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = searchTitles[indexPath.row]
        return cell
    }
    
}
