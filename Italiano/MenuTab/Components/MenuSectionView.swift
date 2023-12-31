//
//  MenuSectionView.swift
//  Italiano
//
//  Created by Daniel on 10/14/23.
//

import SwiftUI

/// View displaying items of a menu section
struct MenuSectionView: View {
    
    /// Menu section passed in
    let section: MenuSection
    
    var body: some View {
        ScrollView {
            VStack {                
                Button {
                    
                } label: {
                    Image("build_your_own")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                }
                
                Divider()
                    .frame(height: 1.5)
                    .overlay(Color.palette.lightGreen)
                
                Text("Select from menu")
                    .font(.asset.heading1)
                    .fontWeight(.regular)
                    .foregroundStyle(Color.palette.oliveGreen)
                
                let sortedByPrice = section.items.sorted(by: { $0.price < $1.price })
                ForEach(sortedByPrice) { item in
                    NavigationLink(value: Route.menuItem(item)) {
                        MenuItemRowView(item: item)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("MenuItem \(sortedByPrice.lastIndex(of: item) ?? 0)")
                }
                .padding(.horizontal)
                
            }
            .padding(.horizontal)
        }
        .navigationTitle(section.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        NavigationStack {
            MenuSectionView(section: .dummy)
                .navigationDestination(for: Route.self) { $0 }
        }
        .environment(dependencies)
        .navigationBarTitleDisplayMode(.inline)
    }
}
