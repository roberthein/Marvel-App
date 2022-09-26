import Foundation

enum Endpoint {
    case characters(offset: Int = 0, limit: Int = 10)
    case image(character: Character)
}
