import Foundation
import UIKit

class CharacterDetailViewModel {

    private let character: Character
    private let cellViewModels: [CharacterDetailCellViewModel]

    // MARK: Initialization

    init(character: Character) {
        self.character = character

        cellViewModels = character.comics.items.map {
            CharacterDetailCellViewModel(summary: $0)
        }
    }

    // MARK: Row items

    var numberOfRows: Int {
        cellViewModels.count
    }

    func cellViewModel(at indexPath: IndexPath) -> CharacterDetailCellViewModel? {
        cellViewModels[safe: indexPath.row]
    }
}
