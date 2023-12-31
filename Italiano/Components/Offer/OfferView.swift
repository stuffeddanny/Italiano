//
//  OfferView.swift
//  Italiano
//
//  Created by Daniel on 10/7/23.
//

import SwiftUI

/// Full offer page view
struct OfferView: View {
    
    /// Offer passed in
    let offer: Offer
    
    /// Triggers when user copied promo code to the clipboard
    @State private var isCopied: Bool = false

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    CachedImage(url: offer.image)
                        .scaledToFill()
                    .frame(width: 300, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top)
                    
                    Text(offer.offerDescription)
                        .font(.asset.heading2)
                        .foregroundStyle(Color.palette.oliveGreen)
                        .padding(.vertical)
                    
                    Text(offer.text)
                        .font(.asset.offerText)
                    
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.horizontal)
            }
            
            PromoSection
            
        }
        .navigationTitle(offer.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    /// Promo code section
    private var PromoSection: some View {
        Group {
            let promoCode = offer.promoCode.uppercased()
            Text("Promo Code")
                .font(.asset.extra)
                .fontWeight(.semibold)
            
            Text(promoCode)
                .monospaced()
                .font(.largeTitle)
                .fontWeight(.bold)
            
                .padding()
                .background(Color.palette.tomatoRed.opacity(0.5))
                .overlay {
                    if isCopied {
                        ZStack {
                            Color.palette.neutralDark
                            
                            Text("Copied")
                                .font(.asset.custom(size: 30))
                        }
                    }
                }
            
                .clipShape(RoundedRectangle(cornerRadius: 15))
            
                .animation(.interactiveSpring, value: isCopied)
                .sensoryFeedback(.selection, trigger: isCopied) { $1 }
                .accessibilityIdentifier("promo")
                .onTapGesture {
                    if !isCopied {
                        UIPasteboard.general.string = promoCode
                        isCopied = true
                        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
                            isCopied = false
                        }
                    }
                }
            
            Text("Click to copy")
                .font(.asset.menuItem)
                .foregroundStyle(.secondary)   
        }
    }
}

#Preview {
    @State var dependencies = Dependencies()

    return SwiftDataPreview(preview: PreviewContainer(schema: SchemaV1.self)) {
        NavigationStack {
            OfferView(offer: .dummy)
        }
        .environment(dependencies)
        .navigationBarTitleDisplayMode(.inline)
    }
}
