import SwiftUI

struct DisplayImageFromNetwork: View {
  @State private var uiImage: UIImage? = nil
  var imageUrl: URL
  
  init(imageUrl: URL) {
    self.imageUrl = imageUrl
  }
  
  var body: some View {
    VStack {
      if let uiImage = uiImage {
        Image(uiImage: uiImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
      else {
        ProgressView()
      }
    }
    .onAppear {
      Task {
        do {
          if let cachedImage = ImageCache.shared.getImage(url: imageUrl) {
            uiImage = cachedImage
          } else {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            if let image = UIImage(data: data) {
              uiImage = image
              ImageCache.shared.setImage(url: imageUrl, image: image)
            }
          }
        } catch {
          uiImage = UIImage(systemName: "photo")
        }
      }
    }
  }
}
