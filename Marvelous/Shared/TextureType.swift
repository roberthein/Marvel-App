import UIKit

enum TextureType: CaseIterable {
    case squiglyShapes
    case pinStripes
    case dots
    case danger
    case blinds
    case beans
    case marvel
}

extension TextureType {
    
    var image: UIImage? {
        switch self {
        case .squiglyShapes:
            return UIImage(named: "pattern_0")
        case .pinStripes:
            return UIImage(named: "pattern_1")
        case .dots:
            return UIImage(named: "pattern_2")
        case .danger:
            return UIImage(named: "pattern_3")
        case .blinds:
            return UIImage(named: "pattern_4")
        case .beans:
            return UIImage(named: "pattern_5")
        case .marvel:
            return UIImage(named: "pattern_6")
        }
    }
}
