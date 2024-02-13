//
//  PokedexListRepository.swift
//  Pokedex
//
//  Created by Giancarlo Castañeda Garcia on 12/02/24.
//

import Combine
import Foundation

protocol PokedexListRepositoryProtocol {
    func fetch(offset: Int, resultLimit: Int) -> AnyPublisher<PokedexData, APIError>
}

final class PokedexListRepository: NetworkClientManager<HttpRequest>, PokedexListRepositoryProtocol {
    
    func fetch(offset: Int, resultLimit: Int) -> AnyPublisher<PokedexData, APIError> {
        let httpRequest = HttpRequest(request: PokedexListRequest(offset: offset, limit: resultLimit))

        return request(request:  httpRequest,
                       scheduler: RunLoop.main,
                       responseObject: PokedexData.self)
    }
}
