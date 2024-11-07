import SwiftUI

struct PokemonDetailView: View {

    private let id: Int

    @State private var orientation = UIDeviceOrientation.portrait
    @State private var showingEvolutionsSheet = false
    @StateObject var detailViewModel: PokemonDetailViewModel = .init()

    init(id: Int) {
        self.id = id
    }

    var body: some View {
        ScrollView {
            VStack {
                ZStack(alignment: .top) {
                    Rectangle()
                        .fill(
                            LinearGradient(colors: detailViewModel.headerColor, startPoint: .top, endPoint: .bottom)
                        )
                        .roundedCorner(.infinity, corners: [.bottomLeft, .bottomRight])
                        .frame(height: 200)

                    if let image = detailViewModel.pokemonDetail.image {
                        PokemonDetailHeader(image: image,
                                            showEvolutions: $showingEvolutionsSheet,
                                            showEvolutionButton: detailViewModel.isEvolutionAvailable)
                        .padding(.top, orientation.isPortrait ? 80 : 10)
                    }
                }

                HStack {
                    Text(detailViewModel.pokemonDetail.name)
                        .font(.largeTitle)
                    Text(detailViewModel.pokemonDetail.pokedexNumber)
                        .foregroundStyle(Color.gray)
                        .font(.largeTitle)
                }

                VStack {
                    PokemonTypeView(viewModel: detailViewModel)

                    PokemonStatsView(viewModel: detailViewModel)

                    PokemonInGamePreviewView(viewModel: detailViewModel)
                }
            }
            .onAppear {
                detailViewModel.fetch(id: id)
                detailViewModel.fetchEvolutionChain(id: id)
            }
        }
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        .scrollBounceBehavior(.basedOnSize)
        .ignoresSafeArea(edges: orientation.isPortrait ? .vertical : .top)
        .background(Color.lightConstrast.opacity(0.3))
        .scrollIndicators(.hidden)
        .sheet(isPresented: $showingEvolutionsSheet) {
            if let chain = detailViewModel.evolutionChain {
                PokemonEvolutionView(evolutionChain: chain)
                    .presentationDetents([.height(chain.chainType.actionSheetHeight)])
            }
        }
    }
}

#Preview {
    PokemonDetailView(id: 133)
}

private struct PokemonDetailHeader: View {
    let image: URL
    @Binding var showEvolutions: Bool
    var showEvolutionButton: Bool

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if showEvolutionButton {
                        Button(action: {
                            showEvolutions = true
                        }, label: {
                            Image(.dna)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color.darkConstrast)
                        })
                        .frame(width: 40, height: 40)
                        .shadow(color: .darkConstrast.opacity(0.9), radius: 10)
                        .padding(20)
            }
            HStack {
                Spacer()
                PokemonImageView(imageURL: image, backColor: .constant(nil))
                    .frame(height: 250)
                Spacer()
            }
        }
    }
}

private struct PokemonStatsView: View {

    @StateObject var viewModel: PokemonDetailViewModel

    var body: some View {
        Group {
            Text("DATA")
                .font(.title)
                .padding(.top, 10)
            HStack {
                Text(viewModel.pokemonDetail.weight)
                    .font(.body)
                Spacer()
                Text(viewModel.pokemonDetail.height)
                    .font(.body)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)

            BarChartView(data: viewModel.pokemonDetail.chartData)
                .padding(.horizontal, 15)
        }
    }
}

private struct PokemonTypeView: View {
    @StateObject var viewModel: PokemonDetailViewModel

    var body: some View {
        Group {
            Text("TYPE")
                .font(.title)
                .padding(.top, 10)
            HStack {
                Spacer()
                ForEach(viewModel.pokemonDetail.types, id: \.id) { element in
                    ChipView(titleKey: element.name, textColor: element.nameColor, colors: element.color)
                }
                Spacer()
            }
            .padding(.bottom, 20)
        }
    }
}

private struct PokemonInGamePreviewView: View {
    @StateObject var viewModel: PokemonDetailViewModel

    var body: some View {
        Group {
            Text("INGAME_PREVIEW")
                .font(.title)
                .padding(.top, 10)
            ScrollView(.horizontal) {
                HStack {
                    ForEach(viewModel.pokemonDetail.inGameImages, id: \.id) { inGame in
                        Spacer()
                        VStack {
                            ImageView(urlString: inGame.image.absoluteString)
                                .aspectRatio(contentMode: .fit)
                                .background(
                                    RoundedRectangle(cornerRadius: 45)
                                        .fill(Color.gray.opacity(0.3))
                                )
                            Text(inGame.name)
                                .lineLimit(2)
                                .font(.title2)
                        }
                        .frame(height: 180)
                        Spacer()
                    }
                }
            }
            .padding(.top)
            .padding(.bottom, 50)
        }
    }
}
