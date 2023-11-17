//
//  ContentView.swift
//  FoodPin
//
//  Created by 郑敏 on 2023/11/13.
//

import SwiftUI

struct RestaurantListView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: Restaurant.entity(),
        sortDescriptors: []
    )
    var restaurants: FetchedResults<Restaurant>
    
    @State private var showNewRestaurant = false
    @State private var searchText = ""
    @State private var showWalkthrough = false
    @AppStorage("hasViewedWalkthrough") var hasViewedWalkthrough: Bool = false
    
    private func deleteRecord(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = restaurants[index]
            context.delete(itemToDelete)
        }
        
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                if restaurants.count == 0 {
                    Image("emptydata")
                        .resizable()
                        .scaledToFit()
                } else {
                    ForEach(restaurants.indices, id: \.self) { index in  
                        ZStack(alignment: .leading) {
                            NavigationLink(destination: RestaurantDetailView(restaurant: restaurants[index])) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            BasicTextImageRow(restaurant: restaurants[index])
                        }
                    }
                    .onDelete(perform: deleteRecord)
                    .listRowSeparator(.hidden)
                    
                }
            }
            .listStyle(.plain)
            .navigationBarTitle("FoodPin")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                Button(action: {
                    self.showNewRestaurant.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showNewRestaurant) {
            NewRestaurantView()
        }
        .accentColor(.primary)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: String(localized: "Search restaurants...", comment: "Search restaurants...")
        ) {
            let searchText1 = String(localized: "Luckin", comment: "Luckin")
            let searchText2 = String(localized: "Thai", comment: "Thai")
            let searchText3 = String(localized: "Cafe", comment: "Cafe")
            Text(searchText1).searchCompletion(searchText1)
            Text(searchText2).searchCompletion(searchText2)
            Text(searchText3).searchCompletion(searchText3)
        }
        .onChange(of: searchText) { searchText in
            let predicate = searchText.isEmpty
            ? NSPredicate(value: true)
            : NSPredicate(format: "name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
            
            restaurants.nsPredicate = predicate
        }
        .sheet(isPresented: $showWalkthrough) {
            TutorialView()
        }
        .onAppear() {
            showWalkthrough = hasViewedWalkthrough ? false : true
        }
    }
}

struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        RestaurantListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
        
        BasicTextImageRow(restaurant: (PersistenceController.testData?.first)!)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("BasicTextImageRow")
                
        FullImageRow(restaurant: (PersistenceController.testData?.first)!)
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FullImageRow")
        
    }
}

struct BasicTextImageRow: View {
    @ObservedObject var restaurant: Restaurant
    
    // MARK: - State variables
    @State private var showOptions = false
    @State private var showError = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(uiImage: UIImage(data: restaurant.image) ?? UIImage())
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(20)
            
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.system(.title2, design: .rounded))
                
                Text(restaurant.type)
                    .font(.system(.body, design: .rounded))
                
                Text(restaurant.location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
            }
            
            if restaurant.isFavorite {
                Spacer()
                
                Image(systemName: "heart.fill")
                    .foregroundColor(.yellow)
            }
        }
        .contextMenu {
            Button(action: {
                self.showError.toggle()
            }) {
                HStack {
                    Text(String(localized: "Reserve a table", comment: "Reserve a table"))
                    Image(systemName: "phone")
                }
            }
            
            Button(action: {
                
            }) {
                HStack {
                    Text(restaurant.isFavorite
                         ? String(localized: "Remove from favorites", comment: "Remove from favorites")
                         : String(localized: "Mark as favorite", comment: "Mark as favorite"))
                    Image(systemName: "heart")
                }
            }
            
            Button(action: {
                self.showOptions.toggle()
            }) {
                HStack {
                    Text(String(localized: "Share", comment: "Share"))
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .alert(String(localized: "Not yet available", comment: "Not yet available"), isPresented: $showError) {
            Button(String(localized: "OK", comment: "OK")) {}
        } message: {
            Text(String(
                localized: "Sorry, this feature is not available yet. Please retry later.",
                comment: "Sorry, this feature is not available yet. Please retry later."
            ))
        }
        .sheet(isPresented: $showOptions) {
            let defaultText = String(localized: "Just checking in at \(restaurant.name)")
            
            if let imageToShare = UIImage(data: restaurant.image) {
                ActivityView(activityItems: [defaultText, imageToShare])
            } else {
                ActivityView(activityItems: [defaultText])
            }
        }
    }
}

struct FullImageRow: View {
    @ObservedObject var restaurant: Restaurant
    @State private var showOptions = false
    @State private var showError = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(uiImage: UIImage(data: restaurant.image) ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(20)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(restaurant.name)
                        .font(.system(.title2, design: .rounded))
                    
                    Text(restaurant.type)
                        .font(.system(.body, design: .rounded))
                    
                    Text(restaurant.location)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.gray)
                }
                
                if restaurant.isFavorite {
                    Spacer()
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.yellow)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom)
        }
        .onTapGesture {
            showOptions.toggle()
        }
        .confirmationDialog(String(localized: "What do you want to do?", comment: "What do you want to do?"), isPresented: $showOptions, titleVisibility: .visible) {
            Button(String(localized: "Reserve a table", comment: "Reserve a table")) {
                self.showError.toggle()
            }
            
            Button(restaurant.isFavorite
                   ? String(localized: "Remove from favorites", comment: "Remove from favorites")
                   : String(localized: "Mark as favorite", comment: "Mark as favorite")) {
                restaurant.isFavorite.toggle()
            }
        }
        .alert(String(localized: "Not yet available", comment: "Not yet available"), isPresented: $showError) {
            Button(String(localized: "OK", comment: "OK")) {}
        } message: {
            Text(String(
                localized: "Sorry, this feature is not available yet. Please retry later.",
                comment: "Sorry, this feature is not available yet. Please retry later."
            ))
        }
    }
}
