import Foundation
import UIKit

struct Service: API {

    func fetchCharacters(offset: Int, limit: Int) async throws -> Result<CharactersResponse, Error> {
        try await fetch(
            request: Request<CharactersResponse>.characters(
                offset: offset,
                limit: limit
            )
        )
    }
}
