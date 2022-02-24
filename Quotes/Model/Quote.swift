//
//  Quote.swift
//  Quotes
//
//  Created by Lillian Yang on 2022-02-22.
//

import Foundation

struct Quote: Decodable, Hashable {
    let quoteText: String
    let quoteAuthor: String
    let sendername: String
    let senderlink: String
    let quoteLink: String
    
}
