//
//  ArticleViewModel.swift
//  NewsDemo
//
//  Created by Chris Blay on 10/27/21.
//

import Foundation
import FirebaseDatabase

struct ArticleListViewModel{
    let articles: [Article]
}

extension ArticleListViewModel {
    
    var articleListURL: String{
        return "https://newsapi.org/v2/top-headlines?country=us&apiKey=4da62994633543e1ad025275d19c9d48"
    }
    
    var numberOfSections: Int{
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int{
        return self.articles.count
    }
    
    func articleAtIndex(_ index: Int) -> ArticleViewModel {
        let article = self.articles[index]
        return ArticleViewModel(article)
    }
    
    func didSelectRowAt (_ index: Int){
        
      
        
        
        
    }
    
}

struct ArticleViewModel {
    private let article: Article
}

extension ArticleViewModel {
    init(_ article: Article){
        self.article = article
    }
}

extension ArticleViewModel {
    var title: String {
        
        return self.article.title!
    }
    var description: String {
        return self.article.description!
    }
    
    var author: String {
        
        return self.article.author!
    }
    var publishedAt: String {
        return self.article.publishedAt!
    }
    
    var isFavorite: Bool{
        var isFav: Bool = true
        
        return isFav
    }
    
//    var author: String {
//        if self.article.author == nil {
//            return ""
//        }
//        return self.article.author
//    }
//    var publishedAt: String{
//        return self.article.publishedAt
//    }
}
