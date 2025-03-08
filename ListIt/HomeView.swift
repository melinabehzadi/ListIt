import SwiftUI

struct HomeView: View {
    @State private var allShoppingLists: [String: [String]] = [
        "Groceries": ["Weekly Grocery List", "Vegan Essentials"],
        "Tech": ["Work Tech Accessories", "Gaming Setup"],
        "Clothes": ["Summer Wardrobe", "Winter Essentials"],
        "Cleaning Supplies": ["Bathroom Cleaning Supplies", "Kitchen Cleaning Kit"]
    ]
    
    @State private var selectedCategory: String = "Groceries" // Default selection
    @State private var animateAddButton = false
    @State private var isAddingList = false
    @State private var isAddingCategory = false
    @State private var newCategoryName: String = ""

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
                            ForEach(allShoppingLists.keys.sorted(), id: \.self) { category in
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
                        if let filteredLists = allShoppingLists[selectedCategory] {
                            ForEach(filteredLists, id: \.self) { list in
                                NavigationLink(destination: ListDetailsView(listName: list)) {
                                    Text(list)
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

                    // Floating Add List Button
                    HStack {
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
            }
            .sheet(isPresented: $isAddingList) {
                AddListView(allShoppingLists: $allShoppingLists, selectedCategory: $selectedCategory)
            }
            .sheet(isPresented: $isAddingCategory) {
                AddCategoryView(allShoppingLists: $allShoppingLists)
            }
        }
    }
    
    // Swipe-to-Delete List
    private func deleteList(at indexSet: IndexSet) {
        allShoppingLists[selectedCategory]?.remove(atOffsets: indexSet)
    }
}
