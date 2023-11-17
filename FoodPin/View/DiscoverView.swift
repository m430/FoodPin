//
//  DiscoverView.swift
//  FoodPin
//
//  Created by 郑敏 on 2023/11/17.
//

import SwiftUI
import CloudKit

struct DiscoverView: View {
    @State private var showLoadingIndicator = false
    @StateObject private var cloudStore: RestaurantCloudStore = RestaurantCloudStore()
    
    private func getImageURL(restaurant: CKRecord) -> URL? {
        guard let image = restaurant.object(forKey: "image"),
              let imageAsset = image as? CKAsset else {
            return nil
        }
        
        return imageAsset.fileURL
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List(cloudStore.restaurants, id: \.recordID) { restaurant in
                    VStack(alignment: .leading, spacing: 10) {
                        AsyncImage(url: getImageURL(restaurant: restaurant)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            Color.purple.opacity(0.1)
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                        
                        Text(restaurant.object(forKey: "name") as! String)
                            .font(.title2)
                        
                        Text(restaurant.object(forKey: "location") as! String)
                            .font(.headline)
                        
                        Text(restaurant.object(forKey: "type") as! String)
                            .font(.subheadline)
                        
                        Text(restaurant.object(forKey: "description") as! String)
                            .font(.subheadline)
                        
                    }
                }
                .listStyle(PlainListStyle())
                .task {
                    cloudStore.fetchRestaurantsWithOperational {
                        showLoadingIndicator.toggle()
                    }
                }
                .onAppear {
                    showLoadingIndicator.toggle()
                }
                .refreshable {
                    cloudStore.fetchRestaurantsWithOperational {
                        showLoadingIndicator.toggle()
                    }
                }
                
                if showLoadingIndicator {
                    ProgressView()
                }
            }
            .navigationTitle("Discover")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
