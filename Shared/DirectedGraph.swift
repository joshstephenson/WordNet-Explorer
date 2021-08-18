//
//  DirectedGraph.swift
//  WordNet
//
//  Created by Joshua Stephenson on 8/15/21.
//

import Foundation

//class Vertex<Element: Equatable> {
//    var value: Element
//    private var adjascentEdges: [DirectedEdge<Element>] = []
//
//    init(_ value: Element) {
//        self.value = value
//    }
//
//    func addEdge(_ edge: DirectedEdge<Element>) {
//        self.adjascentEdges.append(edge)
//    }
//
//    func edgeForDestination(_ destination: Vertex<Element>) -> DirectedEdge<Element>? {
//        return adjascentEdges.filter { $0.destination == destination }.first
//    }
//}
//
//extension Vertex: Equatable {
//    static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
//        return lhs.value == rhs.value && lhs.adjascentEdges == rhs.adjascentEdges
//    }
//}
//
//class DirectedEdge<Element: Equatable>{
//    var source: Int
//    var destination: Int
//
//    init(source: Int, destination: Int) {
//        self.source = source
//        self.destination = destination
//    }
//}
//
//extension DirectedEdge: Equatable {
//    static func ==(lhs: DirectedEdge, rhs: DirectedEdge) -> Bool {
//        return lhs.source == rhs.source &&
//            lhs.destination == rhs.destination
//    }
//}

class DirectedGraph {
    private var vertices: [Array<Int>]
    private var inDegree: [Int]
    public var edgeCount: Int = 0
    public var size: Int
    
    init(_ synsetCount: Int) {
        self.size = synsetCount
        self.vertices = Array(repeating: [], count: synsetCount)
        self.inDegree = Array(repeating: 0, count: synsetCount)
    }
    
    func addEdge(v: Int, w: Int) {
        vertices[v].append(w)
        inDegree[w] += 1
        edgeCount += 1
    }
    
    public func outDegree(v: Int) -> Int {
        return vertices[v].count
    }
    
    public func inDegree(v: Int) -> Int {
        return inDegree[v]
    }
    
    public func adjascent(v: Int) -> IndexingIterator<Array<Int>>{
        print(vertices[v])
        return vertices[v].makeIterator()
    }
    
    public func reverse() -> DirectedGraph {
        let reversed = DirectedGraph(size)
        for i in 0..<vertices.count {
            adjascent(v: i).forEach { w in
                reversed.addEdge(v: w, w: i)
            }
        }
        return reversed
    }
}
