//
//  PathSolution.swift
//  WordNet
//
//  Created by Joshua Stephenson on 8/16/21.
//

import Foundation

struct PathSolution {
    public var ancestor = -1
    public var length = 0
    
    init(ancestor: Int, length: Int) {
        self.ancestor = ancestor
        self.length = length
    }
}
