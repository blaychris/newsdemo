//
//  ArticleDetailViewController.swift
//  NewsDemo
//
//  Created by Chris Blay on 10/27/21.
//

import Foundation
import FirebaseDatabase

import UIKit

class ArticleDetailViewController: UIViewController {
    var datemark:String!
    var sourcemark:String!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var publishedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        ref.child("favorites").observeSingleEvent(of: .value, with: { (snapshot) in

            if (snapshot.hasChild(self.datemark)){

                self.navigationItem.rightBarButtonItem?.title = Constants.NavIconNewsFavorite

             }else{

                 self.navigationItem.rightBarButtonItem?.title = Constants.NavIconNewsNormal
             }


         })
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.NavIconNewsNormal , style: .plain, target: self, action: #selector(toggleNewsFavorite))

    }
    
    @objc private func toggleNewsFavorite(){
        let ref = Database.database().reference().child("favorites")
        if (navigationItem.rightBarButtonItem?.title == Constants.NavIconNewsNormal){
            navigationItem.rightBarButtonItem?.title = Constants.NavIconNewsFavorite
            Task {
                ref.child(datemark).setValue(sourcemark)
            }
        } else{
            navigationItem.rightBarButtonItem?.title = Constants.NavIconNewsNormal
            Task {
                ref.child(datemark).removeValue()
            }
        }



    }

}
