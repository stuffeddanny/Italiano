//
//  ContentView.swift
//  Italiano
//
//  Created by Daniel on 10/5/23.
//

import SwiftUI

struct ContentView: View {
        
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies

    var body: some View {
        @Bindable var routeManager = dependencies.routeManager
        @Bindable var cartManager = dependencies.cartManager
        NavigationStack(path: $routeManager.routes) {
            TabView(selection: $routeManager.tabSelection) {
                HomeView()
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag(RouteManager.Tab.home)
                MapView()
                    .tabItem { Label("Map", systemImage: "map") }
                    .tag(RouteManager.Tab.map)
                MenuView()
                    .tabItem { Label("Menu", systemImage: "list.clipboard") }
                    .tag(RouteManager.Tab.menu)
            }
            .navigationDestination(for: Route.self) { $0 }
            .navigationTitle(routeManager.tabSelection.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Italiano")
                        .font(.asset.heading2)
                        .fontWeight(.regular)
                        .foregroundStyle(Color.palette.tomatoRed)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: Route.cart) {
                        Image(systemName: "basket")
                    }
                }
            }
        }
        .fullScreenCover(item: $cartManager.addedToCartItem) {
            ItemAddedView(item: $0)
        }
        .fullScreenCover(isPresented: $cartManager.showOrderComplete) {
            OrderCompleteView()
        }
        .sensoryFeedback(.success, trigger: cartManager.addedToCartItem) { _, newValue in
            newValue != nil
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self),
                            items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self) + (try! JSONDecoder.decode(from: "Locations", type: [Location].self)) + (try! JSONDecoder.decode(from: "Menu", type: [MenuSection].self)) + [Order.dummy] + [FavoriteItem.dummy]) {
        ContentView()
            .environment(dependencies)
        //            .onAppear {
        //                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        //                    dependencies.routeManager.push(to: .cart)
        //                }
        //            }
    }
}
