//
//  Entry.swift
//  exercicio
//
//  Created by User on 20/06/15.
//  Copyright (c) 2015 lucas. All rights reserved.
//

import Foundation
import Argo
import Runes

struct Entry {
    let title : String
    let link : NSURL
    let author : String
    let publishedDate : String
    let contentSnippet : String
    let content : String
    let categories : [String]
}

extension Entry : Decodable {
    static func create(title: String)(link: String)(author: String)(publishedDate: String)(contentSnippet: String)(content: String)(categories : [String]) -> Entry {
        return Entry(title: title, link: NSURL(string: link)!, author: author, publishedDate: publishedDate, contentSnippet: contentSnippet, content: content, categories: categories)
    }
    
    static func decode(j: JSON) -> Decoded<Entry> {
        return Entry.create
            <^> j <|  "title"
            <*> j <|  "link"
            <*> j <|  "author"
            <*> j <|  "publishedDate"
            <*> j <|  "contentSnippet"
            <*> j <|  "content"
            <*> j <|| "categories"
    }
}