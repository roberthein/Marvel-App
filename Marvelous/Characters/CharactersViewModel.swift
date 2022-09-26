import Foundation
import UIKit

enum ViewState {
    case idle
    case isLoading
}

enum Section: Int, CaseIterable {
    case main
}

class CharactersViewModel {

    private let service = Service()
    private var characters: [Character] = []

    private var pageIndex: Int = -1
    private let perPage = 50
    private(set) var state: ViewState = .idle
    var dataSource: UICollectionViewDiffableDataSource<Section, Character>!

    // MARK: Load Data

    func loadData() {
        guard state != .isLoading else { return }

        pageIndex += 1
        state = .isLoading

        Task { [weak self] in
            guard let self = self else { return }

            let response = try await self.service.fetchCharacters(
                offset: pageIndex * perPage,
                limit: perPage
            )

            self.state = .idle
            
            switch response {
            case let .success(response):
                var snapshot = self.dataSource.snapshot()

                if snapshot.sectionIdentifiers.isEmpty {
                    snapshot.appendSections([.main])
                }

                let newCharacters = response.data.results
                snapshot.appendItems(newCharacters)
                self.characters.append(contentsOf: newCharacters)

                await self.dataSource.apply(snapshot, animatingDifferences: false)
            case let .failure(error):
                assert(false, "ERROR:\(error)")
            }
        }
    }

    // MARK: Prefetch Image

    func prefetchImage(at indexPath: IndexPath) {
        guard let character = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        Images.prefetchImage(for: character)
    }

    // MARK: Load Image

    func loadImage(for character: Character) {
        Images.loadImage(for: character) { [weak self] character, image in
            guard let self = self else { return }
            guard let image = image, image != character.image else { return }
            character.image = image

            var snapshot = self.dataSource.snapshot()
            guard snapshot.indexOfItem(character) != nil else { return }

            snapshot.reloadItems([character])

            DispatchQueue.global(qos: .background).async {
                self.dataSource.apply(snapshot, animatingDifferences: false)
            }
        }
    }

    // MARK: Load Image

    func search(query: String?) {
        let filter: [Character]

        if let query = query, !query.isEmpty {
            filter = characters.filter { $0.name.contains(query) }
        } else {
            filter = characters
        }

        let snapshot = NSDiffableDataSourceSnapshot<Section, Character>()..{
            $0.appendSections([.main])
            $0.appendItems(filter, toSection: .main)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
