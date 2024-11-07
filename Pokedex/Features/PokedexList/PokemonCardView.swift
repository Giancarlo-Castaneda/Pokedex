import SwiftUI

struct PokemonCardView: View {

    var pokemon: PokemonModel
    @State var imageColor: Color? = Color.mint.opacity(0.4)

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                if let image = pokemon.image {
                    PokemonImageView(imageURL: image, backColor: $imageColor)
                }

                Group {
                    Text("NUM_POKEDEX \(pokemon.id)")
                        .foregroundStyle(Color.primary)
                        .font(.body)
                    Text(pokemon.name)
                        .lineLimit(1)
                        .font(.title2)
                        .minimumScaleFactor(0.5)
                        .foregroundStyle(Color.primary)
                        .padding(.bottom, 10)
                }
                .padding(.horizontal, 10)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill((imageColor ?? .mint).opacity(0.9))
            )
        }
        //        .frame(maxWidth: .infinity, maxHeight: 300)
    }
}

#Preview {
    let pokemon = PokemonModel(NamedURLResource(name: "poke", url: PokemonImageURLGenerator.generatePosterURL(for: 5)))

    return PokemonCardView(pokemon: pokemon)
}
