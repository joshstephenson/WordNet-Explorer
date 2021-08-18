//
//  WordNetApp.swift
//  Shared
//
//  Created by Joshua Stephenson on 8/15/21.
//

import SwiftUI

@main
struct WordNetApp: App {
    @StateObject private var searchData = SearchData()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(searchData)
        }
    }
}
