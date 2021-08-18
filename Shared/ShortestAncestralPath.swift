//
//  ShortestAncestralPath.swift
//  WordNet
//
//  Created by Joshua Stephenson on 8/16/21.
//

import Foundation

class ShortestAncestralPath {
    private var pathLoader: PathLoader
    
    init(graph: DirectedGraph) {
        self.pathLoader = PathLoader(graph: graph)
    }
    
    public func length(origin: Int, destination: Int) -> Int {
        if (origin == destination) {
            return 0
        }
        if let solution = pathLoader.findSolution(origin: origin, destination: destination) {
            return solution.length
        }
        return -1
    }
}
