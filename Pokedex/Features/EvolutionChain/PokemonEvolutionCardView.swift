//
//  PokemonEvolutionCardView.swift
//  Pokedex
//
//  Created by Giancarlo Castañeda Garcia on 14/02/24.
//

import SwiftUI

struct PokemonEvolutionCardView: View {
    let pokemon: PokemonModel

    var body: some View {
        HStack {
            if let image = pokemon.image {
                PokemonImageView(imageURL: image, backColor: .constant(nil))
                    .frame(width: 100)
            }
            VStack(alignment: .leading) {
                Text(pokemon.name)
                    .font(.title3)
                    .fontWeight(.bold)
                Text("NUM_POKEDEX \(pokemon.id)")
                    .font(.caption)
            }
        }
        .frame(width: 280, height: 100)
        .background {
            RoundedRectangle(cornerRadius: 70, style: .continuous)
                .fill(Color.lightConstrast)
        }
        .shadow(color: .darkConstrast.opacity(0.25), radius: 25)
    }
}

#Preview {
    PokemonEvolutionCardView(pokemon: .init(.init(name: "rattata-alola", url: URL(string: "https://pokeapi.co/api/v2/pokemon/10091/"))))
}
