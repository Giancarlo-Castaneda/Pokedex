//
//  EvolutionChainModel.swift
//  Pokedex
//
//  Created by Giancarlo Castañeda Garcia on 13/02/24.
//

import Foundation

protocol EvolutionChainModelProtocol {

    var evolutionChains: [EvolutionChainModel.EvolutionChain] { get }
    var chainType: EvolutionChainModel.ChainType { get }
}

struct EvolutionChainModel: EvolutionChainModelProtocol {
    
    var evolutionChains: [EvolutionChain] {
        var species = [[NamedURLResource]]()
        let firstChain = response.chain
        firstChain.evolvesTo.forEach { secondChain in
            if secondChain.evolvesTo.isEmpty {
                species.append([firstChain.species, secondChain.species])
            } else {
                secondChain.evolvesTo.forEach { thirdChain in
                    species.append([firstChain.species, secondChain.species, thirdChain.species])
                }
            }
        }

        return species.map { EvolutionChain($0) }
    }

    var chainType: ChainType {
        ChainType(evolutionChains)
    }

    private let response: EvolutionChainResponse

    init(_ evolutionChainResponse: EvolutionChainResponse) {
        response = evolutionChainResponse
    }
}

extension EvolutionChainModel {

    struct EvolutionChain {
        let id = UUID()

        let pokemons: [PokemonModel]

        init(_ species: [NamedURLResource]) {
            self.pokemons = species.map { PokemonModel($0) }
        }
    }
}

extension EvolutionChainModel {

    public enum ChainType {
        case single
        case dual
        case none

        init(_ evolutionChains: [EvolutionChain]) {
            let max = evolutionChains.map { $0.pokemons.count }.max() ?? 0
            switch max {
            case 2:
                self = .single
            case 3:
                self = .dual
            default:
                self = .none
            }
        }
    }
}

extension EvolutionChainModel.ChainType {

    var actionSheetHeight: CGFloat {
        switch self {
        case .single:
            return 250
        case .dual:
            return 400
        case .none:
            return 0
        }
    }
}