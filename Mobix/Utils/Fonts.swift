// 
import UIKit
import Foundation

// Open the OS X Font Book application,
//navigate to your font then press Command+i.
//Note the PostScript name and use that name in your Swift code

enum Fonts {
    static var quicksandMedium: UIFont {
        return try! getFont("Quicksand-Medium")
    }
    
    static var quicksandRegular: UIFont {
        return try! getFont("Quicksand-Regular")
    }
    
    static var robotoCondensedRegular: UIFont {
        return try! getFont("RobotoCondensed-Regular")
    }
    
    static var robotoCondensedBold: UIFont {
        return try! getFont("RobotoCondensed-Bold")
    }
}


private func getFont(_ fontName: String, with size: CGFloat = 16) throws -> UIFont {
//    guard let font = UIFont(name: fontName, size: size) else {
//        fatalError("""
//            Failed to load the \(fontName) font.
//            Make sure the font file is included in the project and the font name is spelled correctly.
//            """
//        )
//    }
    let font = UIFont.systemFont(ofSize: 16)
    return font
}
