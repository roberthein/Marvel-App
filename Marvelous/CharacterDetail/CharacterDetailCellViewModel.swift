import Foundation
import UIKit

class CharacterDetailCellViewModel {

    private let summary: Character.ComicSummary

    // MARK: Initialization

    init(summary: Character.ComicSummary) {
        self.summary = summary
    }

    // MARK: Items

    var title: String? {
        summary.name
    }
}
