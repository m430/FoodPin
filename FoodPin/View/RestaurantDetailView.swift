//
//  RestaurantDetailView.swift
//  FoodPin
//
//  Created by 郑敏 on 2023/11/13.
//

import SwiftUI

struct RestaurantDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) var context

    @State private var showReview = false
    @ObservedObject var restaurant: Restaurant
    
    var body: some View {
        ScrollView {
            VStack {
                Image(uiImage: UIImage(data: restaurant.image)!)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 445)
                    .overlay {
                        HStack(alignment: .bottom) {
                            VStack {
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(restaurant.name)
                                        .font(.custom("Nunito-Regular", size: 35, relativeTo: .largeTitle))
                                        .bold()
                                        
                                    Text(restaurant.type)
                                        .font(.system(.headline, design: .rounded))
                                        .padding(.all, 5)
                                        .background(.black)
                                }
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomLeading)
                                .foregroundColor(.white)
                                .padding()
                            }
                            
                            if let rating = restaurant.rating, !showReview {
                                Image(rating.image)
                                    .resizable()
                                    .frame(width:  60, height: 60)
                                    .padding([.bottom, .trailing])
                                    .transition(.scale)
                            }
                        }
                    }
                
                Text(restaurant.summary)
                    .padding()
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("ADDRESS")
                            .font(.system(.headline, design: .rounded))
                        
                        Text(restaurant.location)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        Text("PHONE")
                            .font(.system(.headline, design: .rounded))
                        
                        Text(restaurant.phone)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                
                NavigationLink(
                    destination:
                        MapView(location: restaurant.location)
                            .edgesIgnoringSafeArea(.all)
                ) {
                    MapView(location: restaurant.location)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 200)
                        .cornerRadius(20)
                    .padding()
                }
                
                Button {
                    self.showReview.toggle()
                } label: {
                    Text("Rate it")
                        .font(.system(.headline, design: .rounded))
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
                .tint(Color("NavigationBarTitle"))
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 25))
                .controlSize(.large)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Text("\(Image(systemName: "chevron.left"))")
                }
//                MARK: - iOS 15 bug
                .opacity(showReview ? 0 : 1)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    restaurant.isFavorite.toggle()
                }) {
                    Image(systemName: restaurant.isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 30))
                        .foregroundColor(restaurant.isFavorite ? .yellow : .white)
                }
            }
        }
        .ignoresSafeArea()
        .overlay(
            self.showReview ?
                ZStack {
                    ReviewView(isDisplayed: $showReview, restaurant: restaurant)
                }
            : nil
        )
        .onChange(of: restaurant) { _ in
            if self.context.hasChanges {
                try? self.context.save()
            }
        }
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RestaurantDetailView(restaurant: (PersistenceController.testData?.first)!)
        }
        .accentColor(.white)
    }
}
