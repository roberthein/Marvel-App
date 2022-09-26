import Foundation
import UIKit

struct DSM {

    struct Color {
        static let background = UIColor(named: "background") ?? .red
        static let softPink = UIColor(named: "softPink") ?? .red
        static let hazyYellow = UIColor(named: "hazyYellow") ?? .red
        static let hotRed = UIColor(named: "hotRed") ?? .red
        static let newBlack = UIColor(named: "newBlack") ?? .red
        static let babyBlue = UIColor(named: "babyBlue") ?? .red
    }

    struct Font {
        static let title = UIFont(name: "BentonSansExtraComp-Black", size: 100)
        static let subtitle = UIFont(name: "BentonSansExtraComp-Black", size: 35)
        static let name = UIFont(name: "BentonSansExtraComp-Black", size: 50)
        static let comic = UIFont(name: "BentonSansExtraComp-Black", size: 20)
        static let summary: UIFont = .systemFont(ofSize: 12, weight: .bold)
        static let search = UIFont(name: "BentonSansExtraComp-Black", size: 35)!
    }

    struct Spacing {
        static let _10: CGFloat = 10
        static let _20: CGFloat = 20
        static let _30: CGFloat = 30
        static let _40: CGFloat = 40
        static let _60: CGFloat = 60
        static let _80: CGFloat = 80
        static let _100: CGFloat = 100
    }

    struct GridSize {
        static let _40: CGFloat = 40
        static let _80: CGFloat = 80
        static let _200: CGFloat = 200
    }

    struct CornerRadius {
        static let small: CGFloat = 8
        static let large: CGFloat = 12
    }

    struct BorderWidth {
        static let hairline: CGFloat = 2
        static let small: CGFloat = 4
        static let large: CGFloat = 6
    }

    struct Opacity {
        static let _20: CGFloat = 0.2
        static let _80: CGFloat = 0.8
    }

    struct AspectRatio {
        static let characterImage: CGFloat = 555/348
    }
}
