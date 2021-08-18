//
//  ContentView.swift
//  Shared
//
//  Created by Joshua Stephenson on 8/15/21.
//

import SwiftUI

struct Result:Hashable, Codable, Identifiable {
    public var noun: String
    public var id: Int
    
    init(id: Int, noun: String) {
        self.id = id
        self.noun = noun
    }
    
    static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.id == rhs.id && lhs.noun == rhs.noun
    }
}

struct ResultView: View {
    @EnvironmentObject var searchData: SearchData
    var result: Result
    var contentView: ContentView
    
    init(_ result: Result, contentView: ContentView) {
        self.result = result
        self.contentView = contentView
    }
    
    var body: some View {
        let noun = result.noun.replacingOccurrences(of: "_", with: " ")
        Button(noun) {
            searchData.searchString = noun
            contentView.search()
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var searchData: SearchData
    @State private var ancestors:[Result] = []
    @State private var descendants:[Result] = []
    
    init() {
        
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Search Term: ")
                TextField(
                        "Enter a noun",
                        text: $searchData.searchString
                    ) { isEditing in
                    } onCommit: {
                        self.search()
                    }.disableAutocorrection(true)
                Button(LocalizedStringKey("Search")) {
                    self.search()
                }
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            
            HStack {
                VStack {
                    Text("Ancestors (\(ancestors.count))").fontWeight(.bold)
                    List{
                        ForEach(ancestors, id: \.self) { result in
                            ResultView(result, contentView: self)
                        }
                    }
                }
                VStack {
                    Text("Children (\(descendants.count))").fontWeight(.bold)
                    List {
                        ForEach(descendants, id: \.self) { result in
                            ResultView(result, contentView: self)
                        }
                    }
                }
            }.padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        }
        .frame(width: 600, height: 400, alignment: .leading)
        
    }
    
    internal func search() {
        ancestors = searchData.wordNet.ancestors(word: searchData.searchString.components(separatedBy: .whitespaces).joined(separator: "_")).map { (key: Int, value: String) in
            return Result(id: key, noun: value)
        }
        descendants = searchData.wordNet.descendants(word: searchData.searchString.components(separatedBy: .whitespaces).joined(separator: "_")).map { (key: Int, value: String) in
            return Result(id: key, noun: value)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SearchData("flower"))
    }
}
