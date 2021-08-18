//
//  Path.swift
//  WordNet
//
//  Created by Joshua Stephenson on 8/16/21.
//

import Foundation

struct Path {
    public var origin: Int
    public var destination: Int
    public let key: String
    public var best: PathSolution?
    
    init(origin: Int, destination: Int) {
        self.origin = origin
        self.destination = destination
        self.key = "\(origin)->\(destination)"
    }
}
