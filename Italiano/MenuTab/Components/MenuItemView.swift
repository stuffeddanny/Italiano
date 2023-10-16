//
//  MenuItemView.swift
//  Italiano
//
//  Created by Daniel on 10/16/23.
//

import SwiftUI

struct MenuItemView: View {
    
    @State private var item: MenuItem
    
    init(item: MenuItem) {
        self.item = item
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
                    
                    Text(item.text)
                        .font(.asset.menuItem)
                }
                .foregroundStyle(Color.palette.oliveGreen)
                
                Text(item.price.formatPrice())
                    .font(.asset.heading2)
                    .foregroundStyle(Color.palette.tomatoRed)
                    .padding(.vertical, 10)
                
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
                    
                    GroupBox {
                        Text("Options:")
                            .foregroundStyle(Color.palette.oliveGreen)
                            .font(.asset.extra)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.palette.lightGreen)
                                .frame(width: 25, height: 25)
                                
                            Text("Gluten free base")
                                .font(.asset.menuItem)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                    }
                }
                .multilineTextAlignment(.leading)

                Button {
                    
                } label: {
                    Text("Add to cart")
                        .font(.asset.buttonText)
                        .padding(.horizontal)
                }
                .buttonStyle(.borderedProminent)
                .tint(.palette.tomatoRed)
                .padding(.vertical)
            }
            .padding()
        }
    }
}

#Preview {
    @State var cacheManager: CacheManager = CacheManager()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        MenuItemView(item: .dummy)
            .environment(cacheManager)
    }
}
