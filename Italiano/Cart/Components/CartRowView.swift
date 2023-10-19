//
//  CartRowView.swift
//  Italiano
//
//  Created by Daniel on 10/18/23.
//

import SwiftUI

struct CartRowView: View {
    let item: CartItem
    @State var showOptions: Bool = false
    
    var body: some View {
        HStack(alignment: .center) {
            CachedImage(url: item.item.image)
                .scaledToFill()
                .frame(width: 90, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 7)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .top) {
                    Text(item.item.name)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text(item.totalPrice.formatPrice())
                }
                .font(.asset.extra)
                
                HStack(alignment: .top) {
                    Text(item.item.info)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Text("Qty: \(item.quantity)")
                    
                }
                .font(.asset.menuItem)
                
                let selectedOptions = item.item.options.filter({ $0.value })
                if !selectedOptions.isEmpty {
                    Button {
                        showOptions.toggle()
                    } label: {
                        HStack {
                            Text("Options")
                            
                            Image(systemName: "chevron.right")
                                .rotationEffect(.degrees(showOptions ? 90 : 0))
                        }
                        .font(.asset.menuItem)
                    }
                    .buttonStyle(.plain)
                    
                    if showOptions {
                        Text(selectedOptions.map({ $0.name }).joined(separator: ", "))
                            .font(.asset.menuItem)
                            .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
                    }
                }
            }
            .animation(.interactiveSpring, value: showOptions)
        }
    }
}

#Preview {
    @State var cacheManager = CacheManager()
    
    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        CartRowView(item: .dummy)
    }
    .environment(cacheManager)
}
