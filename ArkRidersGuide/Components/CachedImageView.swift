import SwiftUI

final class ImageCacheService: Sendable {
    static let shared = ImageCacheService()

    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 200
    }

    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: NSString(string: key))
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

struct CachedImageView: View {
    let relativePath: String?
    let cacheKey: String
    var placeholderSymbol: String = "photo"

    @State private var uiImage: UIImage?
    @State private var isLoading = false

    var body: some View {
        Group {
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if isLoading {
                ProgressView()
                    .tint(TriadColor.tertiary)
            } else {
                Image(systemName: placeholderSymbol)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(TriadColor.textSecondary)
            }
        }
        .task {
            await loadImage()
        }
    }

    private func loadImage() async {
        if let cached = ImageCacheService.shared.image(forKey: cacheKey) {
            uiImage = cached
            return
        }

        guard let relativePath,
              let url = APIConstants.imageURL(for: relativePath) else { return }

        isLoading = true
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let downloaded = UIImage(data: data) {
                ImageCacheService.shared.setImage(downloaded, forKey: cacheKey)
                uiImage = downloaded
            }
        } catch {
            // Silently fail — placeholder remains visible
        }
        isLoading = false
    }
}
