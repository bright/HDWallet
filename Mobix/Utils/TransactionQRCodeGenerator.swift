// 

import Foundation
import UIKit

public class TransactionQRCodeGenerator {
    public static func generateQRCode(for transaction: TransactionInfo, scale: CGFloat = 4) -> UIImage? {
        guard let data = try? JSONEncoder().encode(transaction) else {return nil}
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: scale, y: scale)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}


