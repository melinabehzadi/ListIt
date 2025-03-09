//
//  ContentView.swift
//  ListIt
//
//  Created by melina behzadi on 2025-02-25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager() // Initialize DataManager

    var body: some View {
        HomeView(dataManager: dataManager) // Inject DataManager into HomeView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
