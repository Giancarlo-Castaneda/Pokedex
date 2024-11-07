import SwiftUI

struct PokedexView: View {

    @StateObject var viewModel: PokedexListViewModel = .init()

    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var columns: Int {
        (isPad || isLandscape) ? 3 : 2
    }

    var itemWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - CGFloat((columns + 1) * 10)) / CGFloat(columns)
    }

    var cardHeigth: CGFloat {
        itemWidth * ((isPad || isLandscape) ? 1.2 : 1.6)
    }

    // MARK: - Private Properties

    @State private var isLoading = true
    @State private var isLandscape = UIDevice.current.orientation.isLandscape
    private let cancelable = Cancelable()
    private var orientationDidChange = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)


    var body: some View {

        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(itemWidth), spacing: 10), count: columns)
                ) {
                    ForEach(viewModel.pokemonList, id: \.self) { pokemon in
                        NavigationLink {
                            PokemonDetailView(id: pokemon.id)
                        } label: {
                            PokemonCardView(pokemon: pokemon)
                                .frame(height: cardHeigth)
                                .onAppear() {
                                    if viewModel.shouldLoadNewPokemons(for: pokemon) {
                                        viewModel.getPokemonData()
                                    }
                                }
                        }
                    }
                    if isLoading {
                        Text("LOADING")
                    } else {
                        Color.clear
                            .onAppear {
                                if !viewModel.pokemonList.isEmpty {
                                    viewModel.getPokemonData()
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 5)
            .navigationTitle("POKEDEX")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                handleState()
                viewModel.getPokemonData()
            }
            .onRotate { newOrientation in
                isLandscape = newOrientation.isLandscape
            }
        }
    }
}

#Preview {
    PokedexView()
}

extension PokedexView {

    private func handleState() {
        viewModel.loadingState
            .receive(on: WorkScheduler.mainThread)
            .sink { state in
                switch state {
                case .loadStart:
                    isLoading = true

                case .dismissAlert:
                    isLoading = false

                case .emptyStateHandler:
                    isLoading = false
                }
            }
            .store(in: cancelable)
    }
}
