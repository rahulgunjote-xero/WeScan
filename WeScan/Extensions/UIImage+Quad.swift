import Foundation
import UIKit

public extension UIImage {
  static func detect(image: UIImage, completion: @escaping (Quadrilateral?) -> Void) {
      // Whether or not we detect a quad, present the edit view controller after attempting to detect a quad.
      // *** Vision *requires* a completion block to detect rectangles, but it's instant.
      // *** When using Vision, we'll present the normal edit view controller first, then present the updated edit view controller later.

      guard let ciImage = CIImage(image: image) else { return }
      let orientation = CGImagePropertyOrientation(image.imageOrientation)
      let orientedImage = ciImage.oriented(forExifOrientation: Int32(orientation.rawValue))

      if #available(iOS 11.0, *) {
          // Use the VisionRectangleDetector on iOS 11 to attempt to find a rectangle from the initial image.
          VisionRectangleDetector.rectangle(forImage: ciImage, orientation: orientation) { (quad) in
              let detectedQuad = quad?.toCartesian(withHeight: orientedImage.extent.height)
              completion(detectedQuad)
          }
      } else {
          // Use the CIRectangleDetector on iOS 10 to attempt to find a rectangle from the initial image.
          let detectedQuad = CIRectangleDetector.rectangle(forImage: ciImage)?.toCartesian(withHeight: orientedImage.extent.height)
          completion(detectedQuad)
      }
  }
}
