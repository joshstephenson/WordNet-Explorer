//
//  PathLoader.swift
//  WordNet
//
//  Created by Joshua Stephenson on 8/16/21.
//

import Foundation

class PathLoader {
    private var directedGraph: DirectedGraph
    private var marked: [Bool]
    private var solutions: [String:PathSolution]
    
    init(graph: DirectedGraph) {
        directedGraph = graph
        marked = []
        solutions = [:]
    }
    
    public func findSolution(origin: Int, destination: Int) -> PathSolution? {
        let path = Path(origin: origin, destination: destination)
        return path.best
    }
}
