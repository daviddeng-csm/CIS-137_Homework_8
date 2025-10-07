//  CIS137 Assignment #8
//  Added idine files to the project. The only changes I made was to the Menu.swift file, rest are all done in the ContentView dealing with the views and layout.
//  David Deng
//  October 7, 2025
//
//  ContentView.swift
//  Homework8
//
//  Created by David Deng on 10/7/25.
//

import SwiftUI

struct ContentView: View {
    // Load the menu data from JSON
    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    
    var body: some View {
        NavigationView{
            List{
                // Original categories section
                Section(header: Text("Categories")) {
                    HStack {
                        Image(systemName: "book")
                        Text("Books")
                    }
                    HStack {
                        Image(systemName: "gamecontroller.fill")
                        Text("Games")
                    }
                    HStack {
                        Image(systemName: "movieclapper")
                        Text("Movies")
                    }
                    
                    // Food category with navigation to food menu
                    NavigationLink(destination: FoodMenuView()) {
                        HStack {
                            Image(systemName: "fork.knife")
                            Text("Food")
                        }
                    }
                }
            }.navigationTitle(Text("Menu"))
        }
    }
}

// New view for displaying food categories from JSON
struct FoodMenuView: View {
    let menu = Bundle.main.decode([MenuSection].self, from: "menu.json")
    
    var body: some View {
        List {
            ForEach(menu) { section in
                NavigationLink(destination: FoodItemsView(section: section)) {
                    Text(section.name)
                        .font(.headline)
                }
            }
        }
        .navigationTitle("Food Categories")
    }
}

// View for displaying items in a specific food category
struct FoodItemsView: View {
    let section: MenuSection
    
    var body: some View {
        List(section.items) { item in
            NavigationLink(destination: ItemDetailView(item: item)) {
                HStack {
                    Image(item.thumbnailImage)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                        .shadow(color: .gray, radius: 2, x: 1, y: 1)
                    
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text("$\(item.price)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle(section.name)
    }
}

// Food item view for displaying full info of the food
struct ItemDetailView: View {
    let item: MenuItem
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Main image
                Image(item.mainImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.3), radius: 4, x: 2, y: 2)
                
                // Item name and price
                VStack(alignment: .leading, spacing: 8) {
                    Text(item.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("$\(item.price)")
                        .font(.title2)
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
                
                // Restrictions
                if !item.restrictions.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dietary Info:")
                            .font(.headline)
                        
                        HStack {
                            ForEach(item.restrictions, id: \.self) { restriction in
                                Text(restriction)
                                    .font(.caption)
                                    .padding(6)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Description:")
                        .font(.headline)
                    
                    Text(item.description)
                        .font(.body)
                        .lineSpacing(4)
                }
                .padding(.horizontal)
                
                // Photo credit
                HStack {
                    Spacer()
                    Text("Photo by: \(item.photoCredit)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ContentView()
}
