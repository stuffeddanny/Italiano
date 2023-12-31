//
//  MenuItemView.swift
//  Italiano
//
//  Created by Daniel on 10/16/23.
//

import SwiftUI
import SwiftData

/// View of menu item
struct MenuItemView: View {
    
    /// Dependency injection
    @Environment(Dependencies.self) private var dependencies
    
    /// Model context
    @Environment(\.modelContext) private var context
    
    /// Cart items to modify when adding item to cart
    @Query private var cartItems: [CartItemSwiftData]
    
    /// Favorite items
    @Query private let favorites: [FavoriteItem]

    /// Item to be added to the cart that can be modified
    @State private var item: MenuItem
    
    init(item: MenuItem) {
        self._item = .init(wrappedValue: item)
    }
    
    var body: some View {
        ScrollView {
            VStack() {
                CachedImage(url: item.image)
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.bottom)
                
                Group {
                    Text(item.name)
                        .font(.asset.heading1)
                        .accessibilityIdentifier("name")
                    
                    Text(item.info)
                        .font(.asset.menuItem)
                }
                .foregroundStyle(Color.palette.oliveGreen)
                
                Text(item.price.formatPrice())
                    .font(.asset.heading2)
                    .foregroundStyle(Color.palette.tomatoRed)
                    .padding(.vertical, 10)
                
                IngredientsAndOptions
                
                AddToCartButton
                    .padding(.vertical)
            }
            .padding()
        }
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                let favorite = favorites.first(where: { $0.item == item })
                Button {
                    if let favorite { context.delete(favorite) } else { context.insert(FavoriteItem(item: item)) }
                } label: {
                    Image(systemName: "star")
                        .foregroundStyle(Color.yellow)
                        .symbolVariant(favorite != nil ? .fill : .none)
                }
            }
        }
    }
    
    private var AddToCartButton: some View {
        Button {
            dependencies.cartManager.addToCart(item: item, cart: cartItems, context: context)
        } label: {
            Text("Add to cart")
                .font(.asset.buttonText)
                .padding(.horizontal)
        }
        .buttonStyle(.borderedProminent)
        .tint(.palette.tomatoRed)
        .accessibilityIdentifier("AddToCart")
    }
    
    /// Ingredients and options section
    private var IngredientsAndOptions: some View {
        Group {
            if !item.ingredients.isEmpty {
                GroupBox {
                    Text("Ingredients:")
                        .foregroundStyle(Color.palette.oliveGreen)
                        .font(.asset.extra)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(item.ingredients.map({ $0.name }).joined(separator: ", "))
                        .font(.asset.menuItem)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            if !item.options.isEmpty {
                GroupBox {
                    Text("Options:")
                        .foregroundStyle(Color.palette.oliveGreen)
                        .font(.asset.extra)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(item.options) { option in
                        let binding = Binding<Option> { option } set: {
                            guard let index = item.options.firstIndex(of: option) else { return }
                            item.options[index] = $0
                        }
                        VStack {
                            OptionView(option: binding)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .multilineTextAlignment(.leading)
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        NavigationStack {
            MenuItemView(item: .dummy)
        }
            .environment(dependencies)
    }
}
