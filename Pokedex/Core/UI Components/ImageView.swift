import SwiftUI

struct ImageView: View {

    @ObservedObject var imageDownloader: ImageDownloader
    private var imageColor: Binding<Color?>?

    init(urlString: String, imageColor: Binding<Color?>? = nil) {
        self.imageDownloader = ImageDownloader(urlString: urlString)
        self.imageColor = imageColor
    }

    var body: some View {
        Group {
            if let image = imageDownloader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onAppear {
                        imageColor?.wrappedValue = imageDownloader.imageColor
                    }
            } else {
                ProgressView()
                    .frame(width: 200, height: 300)
            }
        }
        .padding()
    }
}
