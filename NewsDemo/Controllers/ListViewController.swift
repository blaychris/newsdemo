//
//  ListViewController.swift
//  NewsDemo
//
//  Created by Chris Blay on 10/26/21.
//

import Foundation
import FirebaseDatabase
import UIKit

class ListViewController: UITableViewController {
    
    private var leftNavigationLabel: UILabel!
    private var articleListVM: ArticleListViewModel!
    private var activeURL: URL!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        setup()

    }
    
    private func setup() {
        
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refreshControl)
        self.refreshControl = refreshControl


        var isUS: Bool
        if  (UserDefaults.standard.object(forKey: Constants.isUSSource) != nil){
            isUS = UserDefaults.standard.bool(forKey: Constants.isUSSource)
        }else{
            isUS = true
            UserDefaults.standard.set(true, forKey: Constants.isUSSource)
        }
        
        //Add country toggle button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: isUS ? Constants.NavIconAmerica : Constants.NavIconCanada, style: .plain, target: self, action: #selector(toggleNewsSource))
        leftNavigationLabel = UILabel()
        let fontSize = leftNavigationLabel.font.pointSize;
        leftNavigationLabel.font = .boldSystemFont(ofSize:fontSize)
        leftNavigationLabel.text = isUS ? Constants.NavCaptionAmerica : Constants.NavCaptionCanada
        leftNavigationLabel.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftNavigationLabel)
        
        activeURL = URL(string: isUS ? Constants.URLAmerica : Constants.URLCanada)!
        
        self.refreshData()
    }
    
    @objc private func refreshData(){
        self.refreshControl?.beginRefreshing()
        self.articleListVM = nil
        self.tableView.reloadData()
        WebService().getArticles(url: activeURL!) { articles in
            if let articles = articles {
                self.articleListVM = ArticleListViewModel(articles: articles)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
        
    }
    
    @objc private func toggleNewsSource(){
        
        activeURL = URL(string: "")
        
        if (navigationItem.rightBarButtonItem?.title == Constants.NavIconAmerica){
            navigationItem.rightBarButtonItem?.title = Constants.NavIconCanada
            leftNavigationLabel.text = Constants.NavCaptionCanada
            activeURL = URL(string: Constants.URLCanada)!
        } else{
            navigationItem.rightBarButtonItem?.title = Constants.NavIconAmerica
            leftNavigationLabel.text = Constants.NavCaptionAmerica
            activeURL = URL(string: Constants.URLAmerica)!
        }
        leftNavigationLabel.sizeToFit()
        
        UserDefaults.standard.set((navigationItem.rightBarButtonItem?.title == Constants.NavIconAmerica), forKey: Constants.isUSSource)
        
        self.refreshData()
            
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.articleListVM == nil ? 0 : self.articleListVM.numberOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM.numberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell", for: indexPath) as? ArticleTableViewCell
        else{
            fatalError("ArticleTableViewCell not found")
        }
        
      
        
        let articleVM = self.articleListVM.articleAtIndex(indexPath.row)
        
        let ref = Database.database().reference()
        ref.child("favorites").observeSingleEvent(of: .value, with: { (snapshot) in

            if snapshot.hasChild(articleVM.publishedAt){

                cell.labelFavorite.isHidden = false

             }else{

                 cell.labelFavorite.isHidden = true
             }


         })
        
        cell.titleLabel.text = articleVM.title
        cell.descriptionLabel.text = articleVM.description

//        articleVM.isFavorite
//        cell.descriptionLabel.text = articleVM.author
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = storyboard!.instantiateViewController(withIdentifier: "ArticleDetailViewController") as! ArticleDetailViewController
        let _ = detailViewController.view
        let articleVM = self.articleListVM.articleAtIndex(indexPath.row)
        detailViewController.titleLabel.text = articleVM.title
        detailViewController.descriptionLabel.text = articleVM.description
        detailViewController.authorLabel.text = articleVM.author
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:articleVM.publishedAt)!
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "MMM dd, yyyy hh:mma"
        detailViewController.publishedLabel.text = dateFormatter2.string(from: date)
        detailViewController.datemark = articleVM.publishedAt
        detailViewController.sourcemark = navigationItem.rightBarButtonItem?.title
        self.navigationController?.pushViewController(detailViewController, animated:true)
    }
    
}
