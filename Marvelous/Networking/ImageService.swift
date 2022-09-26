import Foundation
import UIKit

struct ImageService: API {

    func fetchImage(character: Character) async throws -> Result<UIImage, Error> {
        try await fetch(
            request: Request<UIImage>.image(
                character: character
            )
        )
    }
}
