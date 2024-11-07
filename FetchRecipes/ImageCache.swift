import Foundation
import UIKit

class ImageCache: NSObject , NSDiscardableContent {

    static let shared = ImageCache()
    private let cache = NSCache<NSURL, ImageCache>()
    public var image: UIImage!

    func beginContentAccess() -> Bool {
        return true
    }

    func endContentAccess() {}
    func discardContentIfPossible() {}

    func isContentDiscarded() -> Bool {
        return false
    }
  
    func getImage(url: URL) -> UIImage? {
      if let cachedVersion = cache.object(forKey: url as NSURL) {
        return cachedVersion.image
      } else {
        return nil
      }
    }
  
    func setImage(url: URL, image: UIImage) {
      let cacheImage = ImageCache()
      cacheImage.image = image
      self.cache.setObject(cacheImage, forKey: url as NSURL)
    }
}
