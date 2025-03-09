//
//  HomeView.swift
//  ListIt
//
//  Created by melina behzadi on 2025-03-08.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var dataManager: DataManager // Use DataManager for persistence

    @State private var selectedCategory: String = "" // Default selection
    @State private var animateAddButton = false
    @State private var isAddingList = false
    @State private var isAddingCategory = false
    @State private var isShowingAbout = false // State to show AboutView

    var body: some View {
        NavigationView {
            ZStack {
                // Background color
                Color("BackgroundColor").edgesIgnoringSafeArea(.all)

                VStack {
                    // Title
                    Text("Shopping Lists")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextColor"))
                        .padding(.top, 40)
                        .opacity(animateAddButton ? 1 : 0)
                        .animation(.easeInOut(duration: 1.2), value: animateAddButton)

                    // Category Selector with + Button
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            // Add Category Button
                            Button(action: {
                                isAddingCategory = true
                            }) {
                                Circle()
                                    .fill(Color("AccentColor"))
                                    .frame(width: 35, height: 35)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                    .shadow(radius: 3)
                            }

                            // Category List
                            ForEach(dataManager.allShoppingLists.keys.sorted(), id: \.self) { category in
                                Text(category)
                                    .foregroundColor(selectedCategory == category ? .white : Color("TextColor"))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .background(selectedCategory == category ? Color("AccentColor") : Color("CardColor"))
                                    .cornerRadius(20)
                                    .shadow(radius: 3)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedCategory = category
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 10)

                    // List of Shopping Lists with Swipe-to-Delete
                    List {
                        if let lists = dataManager.allShoppingLists[selectedCategory] {
                            ForEach(lists) { list in
                                NavigationLink(destination: ListDetailsView(dataManager: dataManager, category: selectedCategory, list: list)) {
                                    Text(list.name)
                                        .font(.headline)
                                        .foregroundColor(Color("TextColor"))
                                        .padding()
                                }
                                .listRowBackground(Color("CardColor"))
                            }
                            .onDelete { indexSet in
                                deleteList(at: indexSet)
                            }
                        }
                    }
                    .background(Color("BackgroundColor"))
                    .scrollContentBackground(.hidden)

                    Spacer()

                    // Floating Buttons (Add List & About)
                    HStack {
                        Button(action: {
                            isShowingAbout = true
                        }) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "questionmark")
                                        .font(.system(size: 26, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .shadow(radius: 6)
                        }
                        .padding(.leading, 20)
                        .padding(.bottom, 20)

                        Spacer()

                        Button(action: {
                            isAddingList = true
                        }) {
                            Circle()
                                .fill(Color("AccentColor"))
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Image(systemName: "plus")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .shadow(radius: 6)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .onAppear {
                animateAddButton = true
                loadDefaultCategory()
            }
            .sheet(isPresented: $isAddingList) {
                AddListView(dataManager: dataManager, selectedCategory: $selectedCategory)
            }
            .sheet(isPresented: $isAddingCategory) {
                AddCategoryView(dataManager: dataManager)
            }
            .sheet(isPresented: $isShowingAbout) {
                AboutView() // Shows the About View
            }
        }
    }

    // Load a default category if available
    private func loadDefaultCategory() {
        if selectedCategory.isEmpty, let firstCategory = dataManager.allShoppingLists.keys.sorted().first {
            selectedCategory = firstCategory
        }
    }

    // Swipe-to-Delete List
    private func deleteList(at indexSet: IndexSet) {
        if let lists = dataManager.allShoppingLists[selectedCategory] {
            let indices = Array(indexSet)
            for index in indices {
                dataManager.allShoppingLists[selectedCategory]?.remove(at: index)
            }
            dataManager.saveLists()
        }
    }
}
