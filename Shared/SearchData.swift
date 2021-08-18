//
//  SearchData.swift
//  WordNet
//
//  Created by Joshua Stephenson on 8/17/21.
//

import Foundation

class SearchData: ObservableObject {
    @Published var searchString: String = ""
    @Published var wordNet = WordNet(synsets: "synsets.txt", hypernyms: "hypernyms.txt")
    
    init() {
        
    }
    init(_ string: String) {
        self.searchString = string
    }
}
