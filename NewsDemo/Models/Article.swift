//
//  Article.swift
//  NewsDemo
//
//  Created by Chris Blay on 10/27/21.
//

import Foundation

struct ArticleList: Decodable {
    let articles: [Article]    
}


//struct Article2: Decodable {
//
//    let title: String
//    let description: String
////    let author: String
////    let publishedAt: String
//
//}

struct Article: Codable {
    var title: String!
    var description: String!
    var author: String!
    var publishedAt: String!
    
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case title = "title"
        case description = "description"

        case publishedAt = "publishedAt"
    }
    
    // The Initializer function from Decodable
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do{
            title = try values.decode(String.self, forKey: .title)
        } catch DecodingError.valueNotFound(let type, let context) {
            title = " "
        }
        do{
            description = try values.decode(String.self, forKey: .description)
        }  catch DecodingError.valueNotFound(let type, let context) {
            description = " "
        }
        
        do{
            author = try values.decode(String.self, forKey: .author)
        }  catch DecodingError.valueNotFound(let type, let context) {
            author = " "
        }
        
        do{
            let isoDate = try values.decode(String.self, forKey: .publishedAt)

            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from:isoDate)!
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "MMM dd, yyyy hh:mma"

            publishedAt = dateFormatter2.string(from: date)
        }  catch DecodingError.valueNotFound(let type, let context) {
            publishedAt = " "
        }
      
    }
}
