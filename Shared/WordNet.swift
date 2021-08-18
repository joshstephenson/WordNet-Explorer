//
//  WordNet.swift
//  WordNet
//
//  Created by Joshua Stephenson on 8/15/21.
//

import Foundation

class WordNet {
    /**
     nounLookup is a simple dictionary with IDs as the key and a string of nouns separated by whitespace as the value
     Nouns are the unique concepts which may be represented by many words
     */
    private var nounLookup:[Int:String] = [:]
    
    /**
     idLookup is a more complicated dictionary with a single noun as the key and an array of IDs of synonyms as the value
     */
    private var idLookup: [String:[Int]] = [:]
    
    private var synsetCount:Int = 0
    
    private var digraph: DirectedGraph
    
    init(synsets: String, hypernyms: String) {
        self.idLookup = [:]
        self.nounLookup = [:]
        self.digraph = DirectedGraph(0)
        processNouns(synsets)
        buildDirectedGraph(hypernyms)
    }
    
    public func isNoun(word: String) -> Bool {
        return idLookup[word] != nil
    }
    
    public func ancestors(word: String) -> [Int:String] {
        var words:[Int:String] = [:]
        if let id = idLookup[word.lowercased()], let first = id.first {
            digraph.adjascent(v: first).forEach { nounId in
                if let noun = nounLookup[nounId] {
                    noun.components(separatedBy: .whitespaces).forEach { n in
                        if let thisIds = idLookup[n], let first = thisIds.first {
                            words[first] = n
                        }
                    }
                }
            }
        }
        return words
    }
    
    public func descendants(word: String) -> [Int:String] {
        var words:[Int:String] = [:]
        if let id = idLookup[word.lowercased()], let first = id.first {
            digraph.reverse().adjascent(v: first).forEach { nounId in
                if let noun = nounLookup[nounId] {
                    noun.components(separatedBy: .whitespaces).forEach { n in
                        if let thisIds = idLookup[n], let first = thisIds.first {
                            words[first] = n
                        }
                    }
                }
            }
        }
        return words
    }
    
    private func processNouns(_ synsets: String) {
        if let path = Bundle.main.path(forResource: synsets, ofType: nil) {
            do {
                let data = try String(contentsOfFile: path)
                let lines = data.components(separatedBy: .newlines)
                lines.forEach { line in
                    let parts = line.components(separatedBy: ",")
                    if let first = parts.first, let id = Int(first) {
                        let nounString = parts[1]
                        
                        nounLookup[id] = nounString
                        
                        // nouns have synonyms that need to be accounted for in idLookup
                        // Split them and add them to the array values of idLookup
                        let nouns = nounString.components(separatedBy: .whitespaces)
                        nouns.forEach { noun in
                            if var nounIds = idLookup[noun] {
                                nounIds.append(id)
                            }else {
                                idLookup[noun] = [id]
                            }
                        }
                    }
                    synsetCount += 1
                }
            }catch {
                print("error parsing synsets file \(path)")
            }
        }
    }
    
    private func buildDirectedGraph(_ hypernyms: String) {
        if let path = Bundle.main.path(forResource: hypernyms, ofType: nil) {
            do {
                let data = try String(contentsOfFile: path)
                let lines = data.components(separatedBy: .newlines)
                self.digraph = DirectedGraph(synsetCount)
                lines.forEach { line in
                    // Need a way to validate the graph here to see if it's topological
                    let parts = line.components(separatedBy: ",")
                    if let first = parts.first, let synset = Int(first) {
                        for i in 1..<parts.count {
                            if let hypernym = Int(parts[i]) {
                                digraph.addEdge(v: synset, w: hypernym)
                            }
                        }
                    }
                }
                var rootCount = 0
                nounLookup.forEach { noun in
                    let outdegree = digraph.outDegree(v: noun.key)
                    let indegree = digraph.inDegree(v: noun.key)
                    if outdegree == 0 && indegree > 0 {
                        rootCount += 1
                    }
                }
                if rootCount != 1 {
                    print("Data doesn't look like a rooted DAG")
                }
            }catch {
                print("error parsing hypernyms file \(path)")
            }
        }
    }
}
