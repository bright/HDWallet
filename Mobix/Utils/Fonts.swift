// 
import UIKit
import Foundation

// Open the OS X Font Book application,
//navigate to your font then press Command+i.
//Note the PostScript name and use that name in your Swift code

enum Fonts {
    static var quicksandMedium: UIFont {
        return try! getFont("Barlow-Bold")
    }
    
    static var barlowBold: UIFont {
        return try! getFont("Barlow-Bold")
    }
    
    static var barlowRegular: UIFont {
        return try! getFont("Barlow-Regular")
    }
    
    static var robotoCondensedBold: UIFont {
        return try! getFont("Barlow-Bold")
    }
}


private func getFont(_ fontName: String, with size: CGFloat = 16) throws -> UIFont {
    guard let font = UIFont(name: fontName, size: size) else {
        fatalError("""
            Failed to load the \(fontName) font.
            Make sure the font file is included in the project and the font name is spelled correctly.
            """
        )
    }
    return font
}
