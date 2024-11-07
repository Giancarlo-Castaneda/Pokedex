import Foundation
import SwiftUI

struct PokemonImageView: View {
    let imageURL: URL
    @Binding var backColor: Color?

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.pokemonBg)
                    .renderingMode(colorScheme == .light ? .original : .template)
                    .resizable()
                    .foregroundStyle(.white)
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.4)
                    .frame(width: geometry.size.width, height: geometry.size.height)

                ImageView(urlString: imageURL.absoluteString, imageColor: $backColor)
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    PokemonImageView(imageURL: PokemonImageURLGenerator.generatePosterURL(for: 5)!, backColor: .constant(nil))
}
