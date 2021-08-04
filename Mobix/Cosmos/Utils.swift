// 

import Foundation
import BigInt

struct Utils {
    public static func parseToBigUInt(_ amount: String, decimals: Int = 18) -> BigUInt? {
        let separators = CharacterSet(charactersIn: ".,")
        let components = amount.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: separators)
        guard components.count == 1 || components.count == 2 else {return nil}
        let unitDecimals = decimals
        guard let beforeDecPoint = BigUInt(components[0], radix: 10) else {return nil}
        var mainPart = beforeDecPoint*BigUInt(10).power(unitDecimals)
        if (components.count == 2) {
            let numDigits = components[1].count
            guard numDigits <= unitDecimals else {return nil}
            guard let afterDecPoint = BigUInt(components[1], radix: 10) else {return nil}
            let extraPart = afterDecPoint*BigUInt(10).power(unitDecimals-numDigits)
            mainPart = mainPart + extraPart
        }
        return mainPart
    }
    
    static func isValidateBech32(_ address:String) -> Bool {
        let bech32 = Bech32()
        guard let _ = try? bech32.decode(address) else {
            return false
        }
        return true
    }
    
    /// Returns nil of formatting is not possible to satisfy.
    public static func formatToEthereumUnits(_ bigNumber: BigInt, toUnits: Utils.Units = .eth, decimals: Int = 4, decimalSeparator: String = ".") -> String? {
        let magnitude = bigNumber.magnitude
        guard let formatted = formatToEthereumUnits(magnitude, toUnits: toUnits, decimals: decimals, decimalSeparator: decimalSeparator) else {return nil}
        switch bigNumber.sign {
        case .plus:
            return formatted
        case .minus:
            return "-" + formatted
        }
    }
    
    public static func formatToEthereumUnits(_ bigNumber: BigUInt, toUnits: Utils.Units = .eth, decimals: Int = 4, decimalSeparator: String = ".", fallbackToScientific: Bool = false) -> String? {
        return formatToPrecision(bigNumber, numberDecimals: toUnits.decimals, formattingDecimals: decimals, decimalSeparator: decimalSeparator, fallbackToScientific: fallbackToScientific);
    }
    
    
    /// Formats a BigUInt object to String. The supplied number is first divided into integer and decimal part based on "numberDecimals",
    /// then limits the decimal part to "formattingDecimals" symbols and uses a "decimalSeparator" as a separator.
    /// Fallbacks to scientific format if higher precision is required.
    ///
    /// Returns nil of formatting is not possible to satisfy.
    public static func formatToPrecision(_ bigNumber: BigUInt, numberDecimals: Int = 18, formattingDecimals: Int = 4, decimalSeparator: String = ".", fallbackToScientific: Bool = false) -> String? {
        if bigNumber == 0 {
            return "0"
        }
        let unitDecimals = numberDecimals
        var toDecimals = formattingDecimals
        if unitDecimals < toDecimals {
            toDecimals = unitDecimals
        }
        let divisor = BigUInt(10).power(unitDecimals)
        let (quotient, remainder) = bigNumber.quotientAndRemainder(dividingBy: divisor)
        var fullRemainder = String(remainder);
        let fullPaddedRemainder = fullRemainder.leftPadding(toLength: unitDecimals, withPad: "0")
        let remainderPadded = fullPaddedRemainder[0..<toDecimals]
        if remainderPadded == String(repeating: "0", count: toDecimals) {
            if quotient != 0 {
                return String(quotient)
            } else if fallbackToScientific {
                var firstDigit = 0
                for char in fullPaddedRemainder {
                    if (char == "0") {
                        firstDigit = firstDigit + 1;
                    } else {
                        let firstDecimalUnit = String(fullPaddedRemainder[firstDigit ..< firstDigit+1])
                        var remainingDigits = ""
                        let numOfRemainingDecimals = fullPaddedRemainder.count - firstDigit - 1
                        if numOfRemainingDecimals <= 0 {
                            remainingDigits = ""
                        } else if numOfRemainingDecimals > formattingDecimals {
                            let end = firstDigit+1+formattingDecimals > fullPaddedRemainder.count ? fullPaddedRemainder.count : firstDigit+1+formattingDecimals
                            remainingDigits = String(fullPaddedRemainder[firstDigit+1 ..< end])
                        } else {
                            remainingDigits = String(fullPaddedRemainder[firstDigit+1 ..< fullPaddedRemainder.count])
                        }
                        if remainingDigits != "" {
                            fullRemainder = firstDecimalUnit + decimalSeparator + remainingDigits
                        } else {
                            fullRemainder = firstDecimalUnit
                        }
                        firstDigit = firstDigit + 1;
                        break
                    }
                }
                return fullRemainder + "e-" + String(firstDigit)
            }
        }
        if (toDecimals == 0) {
            return String(quotient)
        }
        return String(quotient) + decimalSeparator + remainderPadded
    }
    
    /// Various units used in Ethereum ecosystem
    public enum Units {
        case eth
        case wei
        case Kwei
        case Mwei
        case Gwei
        case Microether
        case Finney
        
        var decimals:Int {
            get {
                switch self {
                case .eth:
                    return 18
                case .wei:
                    return 0
                case .Kwei:
                    return 3
                case .Mwei:
                    return 6
                case .Gwei:
                    return 9
                case .Microether:
                    return 12
                case .Finney:
                    return 15
                }
            }
        }
    }
    
}




extension String {
    var fullRange: Range<Index> {
        return startIndex..<endIndex
    }
    
    var fullNSRange: NSRange {
        return NSRange(fullRange, in: self)
    }
    
    func index(of char: Character) -> Index? {
        guard let range = range(of: String(char)) else {
            return nil
        }
        return range.lowerBound
    }

    func split(intoChunksOf chunkSize: Int) -> [String] {
        var output = [String]()
        let splittedString = self
            .map { $0 }
            .split(intoChunksOf: chunkSize)
        splittedString.forEach {
            output.append($0.map { String($0) }.joined(separator: ""))
        }
        return output
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = index(self.startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(self.startIndex, offsetBy: bounds.lowerBound)
        let end = self.endIndex
        return String(self[start..<end])
    }
    
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        let stringLength = self.count
        if stringLength < toLength {
            return String(repeatElement(character, count: toLength - stringLength)) + self
        } else {
            return String(self.suffix(toLength))
        }
    }
    
    func interpretAsBinaryData() -> Data? {
        let padded = self.padding(toLength: ((self.count + 7) / 8) * 8, withPad: "0", startingAt: 0)
        let byteArray = padded.split(intoChunksOf: 8).map { UInt8(strtoul($0, nil, 2)) }
        return Data(byteArray)
    }
    
    func hasHexPrefix() -> Bool {
        return self.hasPrefix("0x")
    }
    
    func stripLeadingZeroes() -> String? {
        let hex = self.addHexPrefix()
        guard let matcher = try? NSRegularExpression(pattern: "^(?<prefix>0x)0*(?<end>[0-9a-fA-F]*)$", options: NSRegularExpression.Options.dotMatchesLineSeparators) else {return nil}
        let match = matcher.captureGroups(string: hex, options: NSRegularExpression.MatchingOptions.anchored)
        guard let prefix = match["prefix"] else {return nil}
        guard let end = match["end"] else {return nil}
        if (end != "") {
            return prefix + end
        }
        return "0x0"
    }
    
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map { result.range(at: $0).location != NSNotFound
                ? nsString.substring(with: result.range(at: $0))
                : ""
            }
        }
    }
    
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
    
    var asciiValue: Int {
        get {
            let s = self.unicodeScalars
            return Int(s[s.startIndex].value)
        }
    }
}

extension Character {
    var asciiValue: Int {
        get {
            let s = String(self).unicodeScalars
            return Int(s[s.startIndex].value)
        }
    }
}









extension NSRegularExpression {
    typealias GroupNamesSearchResult = (NSTextCheckingResult, NSTextCheckingResult, Int)
    
    private func textCheckingResultsOfNamedCaptureGroups() -> [String:GroupNamesSearchResult] {
        var groupnames = [String:GroupNamesSearchResult]()
        
        guard let greg = try? NSRegularExpression(pattern: "^\\(\\?<([\\w\\a_-]*)>$", options: NSRegularExpression.Options.dotMatchesLineSeparators) else {
            // This never happens but the alternative is to make this method throwing
            return groupnames
        }
        guard let reg = try? NSRegularExpression(pattern: "\\(.*?>", options: NSRegularExpression.Options.dotMatchesLineSeparators) else {
            // This never happens but the alternative is to make this method throwing
            return groupnames
        }
        let m = reg.matches(in: self.pattern, options: NSRegularExpression.MatchingOptions.withTransparentBounds, range: NSRange(location: 0, length: self.pattern.utf16.count))
        for (n,g) in m.enumerated() {
            let r = self.pattern.range(from: g.range(at: 0))
            let gstring = String(self.pattern[r!])
            let gmatch = greg.matches(in: gstring, options: NSRegularExpression.MatchingOptions.anchored, range: NSRange(location: 0, length: gstring.utf16.count))
            if gmatch.count > 0{
                let r2 = gstring.range(from: gmatch[0].range(at: 1))!
                groupnames[String(gstring[r2])] = (g, gmatch[0],n)
            }
            
        }
        return groupnames
    }
    
    func indexOfNamedCaptureGroups() throws -> [String:Int] {
        var groupnames = [String:Int]()
        for (name,(_,_,n)) in self.textCheckingResultsOfNamedCaptureGroups() {
            groupnames[name] = n + 1
        }
        return groupnames
    }
    
    func rangesOfNamedCaptureGroups(match:NSTextCheckingResult) throws -> [String:Range<Int>] {
        var ranges = [String:Range<Int>]()
        for (name,(_,_,n)) in self.textCheckingResultsOfNamedCaptureGroups() {
            ranges[name] = Range(match.range(at: n+1))
        }
        return ranges
    }
    
    private func nameForIndex(_ index: Int, from: [String:GroupNamesSearchResult]) -> String? {
        for (name,(_,_,n)) in from {
            if (n + 1) == index {
                return name
            }
        }
        return nil
    }
    
    func captureGroups(string: String, options: NSRegularExpression.MatchingOptions = []) -> [String:String] {
        return captureGroups(string: string, options: options, range: NSRange(location: 0, length: string.utf16.count))
    }
    
    func captureGroups(string: String, options: NSRegularExpression.MatchingOptions = [], range: NSRange) -> [String:String] {
        var dict = [String:String]()
        let matchResult = matches(in: string, options: options, range: range)
        let names = self.textCheckingResultsOfNamedCaptureGroups()
        for (_,m) in matchResult.enumerated() {
            for i in (0..<m.numberOfRanges) {
                guard let r2 = string.range(from: m.range(at: i)) else {continue}
                let g = String(string[r2])
                if let name = nameForIndex(i, from: names) {
                    dict[name] = g
                }
            }
        }
        return dict
    }
}


extension Array {
    public func split(intoChunksOf chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            let endIndex = ($0.advanced(by: chunkSize) > self.count) ? self.count - $0 : chunkSize
            return Array(self[$0..<$0.advanced(by: endIndex)])
        }
    }
}
