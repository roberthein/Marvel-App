import Foundation
import UIKit

struct Theme {
    let titleColor: UIColor
    let backgroundColorPrimary: UIColor
    let backgroundColorSecondary: UIColor
    let summaryBackgroundColor: UIColor
    let summaryTextColor: UIColor
    let comicBackgroundColor: UIColor
    let comicTextColor: UIColor
    let texture: TextureType = [.squiglyShapes, .danger, .beans, .marvel].shuffled().randomElement() ?? .marvel
}

class ThemeFactory {

    func random() -> Theme {
        [pinkBlue, bluePink, yellowRed, redYellow].shuffled().randomElement() ?? pinkBlue
    }

    var pinkBlue: Theme {
        Theme(
            titleColor: DSM.Color.babyBlue,
            backgroundColorPrimary: DSM.Color.softPink,
            backgroundColorSecondary: DSM.Color.hazyYellow,
            summaryBackgroundColor: DSM.Color.babyBlue,
            summaryTextColor: DSM.Color.newBlack,
            comicBackgroundColor: DSM.Color.hazyYellow,
            comicTextColor: DSM.Color.softPink
        )
    }

    var bluePink: Theme {
        Theme(
            titleColor: DSM.Color.softPink,
            backgroundColorPrimary: DSM.Color.babyBlue,
            backgroundColorSecondary: DSM.Color.hazyYellow,
            summaryBackgroundColor: DSM.Color.softPink,
            summaryTextColor: DSM.Color.newBlack,
            comicBackgroundColor: DSM.Color.hazyYellow,
            comicTextColor: DSM.Color.babyBlue
        )
    }

    var yellowRed: Theme {
        Theme(
            titleColor: DSM.Color.hotRed,
            backgroundColorPrimary: DSM.Color.hazyYellow,
            backgroundColorSecondary: DSM.Color.hotRed,
            summaryBackgroundColor: DSM.Color.hotRed,
            summaryTextColor: DSM.Color.hazyYellow,
            comicBackgroundColor: DSM.Color.hotRed,
            comicTextColor: DSM.Color.hazyYellow
        )
    }

    var redYellow: Theme {
        Theme(
            titleColor: DSM.Color.hazyYellow,
            backgroundColorPrimary: DSM.Color.hotRed,
            backgroundColorSecondary: DSM.Color.hazyYellow,
            summaryBackgroundColor: DSM.Color.hazyYellow,
            summaryTextColor: DSM.Color.hotRed,
            comicBackgroundColor: DSM.Color.softPink,
            comicTextColor: DSM.Color.hotRed
        )
    }
}

