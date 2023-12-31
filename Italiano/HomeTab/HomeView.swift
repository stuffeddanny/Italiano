//
//  HomeView.swift
//  Italiano
//
//  Created by Daniel on 10/7/23.
//

import SwiftUI
import SwiftData

/// Home view page displaying relevant information
struct HomeView: View {
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies
    @Environment(\.verticalSizeClass) var verticalSizeClass

    /// Offers available for user
    @Query private let offers: [Offer]
    
    /// Orders placed by the user
    @Query(sort: \Order.date, order: .reverse) private let orders: [Order]
    
    /// User's favorite items
    @Query private let favorites: [FavoriteItem]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                OffersSection
                
                RecentOrdersSection
                
                FavoriteSection
            }
            .padding(.top)
        }
    }
    
    /// Section displaying favorite items
    private var FavoriteSection: some View {
        VStack {
            if !favorites.isEmpty {
                Text("Favorites")
                    .foregroundStyle(Color.palette.oliveGreen)
                    .font(.asset.heading2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                ScrollView(.horizontal) {
                    let spacing: CGFloat = 15
                    HStack(spacing: spacing) {
                        ForEach(favorites) { favorite in
                            NavigationLink(value: Route.menuItem(favorite.item)) {
                                if UIDevice.current.userInterfaceIdiom == .phone {
                                    FavoriteItemCellView(item: favorite)
                                        .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 4 : 7, spacing: spacing)
                                } else {
                                    FavoriteItemCellView(item: favorite)
                                        .frame(width: 100)
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("FavoriteItem \(favorites.lastIndex(of: favorite) ?? 0)")
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(.horizontal, 20, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            }
        }
    }

    /// Section displaying recent orders
    private var RecentOrdersSection: some View {
        VStack {
            Text("Recent orders")
                .foregroundStyle(Color.palette.oliveGreen)
                .font(.asset.heading2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            if orders.isEmpty {
                Text("There are no recent orders")
                    .font(.asset.extra)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ScrollView(.horizontal) {
                    let spacing: CGFloat = 15
                    HStack(spacing: spacing) {
                        ForEach(orders) { order in
                            NavigationLink(value: Route.recentOrder(order: order)) {
                                if UIDevice.current.userInterfaceIdiom == .phone {
                                    RecentOrderCellView(order: order)
                                        .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 3 : 6, spacing: spacing)
                                } else {
                                    RecentOrderCellView(order: order)
                                        .frame(width: 150)
                                }
                            }
                            .buttonStyle(.plain)
                            .accessibilityIdentifier("RecentOrder \(orders.lastIndex(of: order) ?? 0)")
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(.horizontal, 20, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            }
        }
    }
    
    /// Section displaying offers
    private var OffersSection: some View {
        VStack {
            Text("Special offers")
                .foregroundStyle(Color.palette.oliveGreen)
                .font(.asset.heading2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            if offers.isEmpty {
                Text("There are no special offers at the moment")
                    .font(.asset.extra)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ScrollView(.horizontal) {
                    let spacing: CGFloat = 15
                    HStack(spacing: spacing) {
                        ForEach(offers) { offer in
                            NavigationLink(value: Route.offer(offer)) {
                                if UIDevice.current.userInterfaceIdiom == .phone {
                                    OfferCellView(offer: offer)
                                        .containerRelativeFrame(.horizontal, count: verticalSizeClass == .regular ? 3 : 6, spacing: spacing)
                                } else {
                                    OfferCellView(offer: offer)
                                        .frame(width: 150)
                                }
                            }
                            .accessibilityIdentifier("Offer \(offers.lastIndex(of: offer) ?? 0)")
                            .buttonStyle(.plain)
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(.horizontal, 20, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.hidden)
            }
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()
    @Bindable var routeManager = dependencies.routeManager
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self), items: try! JSONDecoder.decode(from: "Offers", type: [Offer].self) + [Order.dummy, Order(items: [.dummy], deliveryInfo: .dummy, date: .distantFuture)] + [FavoriteItem.dummy]) {
        NavigationStack(path: $routeManager.routes) {
            HomeView()
                .navigationDestination(for: Route.self) { $0 }
                .navigationTitle("Italiano")
                .navigationBarTitleDisplayMode(.inline)
        }
        .environment(dependencies)
    }
}
