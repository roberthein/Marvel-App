import Foundation
import UIKit

struct CharactersResponse: Codable {
    let data: CharactersData
}

struct CharactersData: Codable {
    @LossyCodableList var results: [Character]
}
