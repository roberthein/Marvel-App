import Foundation
import UIKit

// MARK: - Request

struct Request<T> {
    let endpoint: Endpoint
    var parse: (Data) -> Result<T, Error>

    init(endpoint: Endpoint, parse: @escaping (Data) -> Result<T, Error>) {
        self.endpoint = endpoint
        self.parse = parse
    }
}

extension Request {

    // MARK: Characters request

    static func characters(offset: Int = 0, limit: Int = 10) -> Request<CharactersResponse> {
        Request<CharactersResponse>(
            endpoint: .characters(offset: offset, limit: limit),
            parse: Parse.data()
        )
    }

    // MARK: Image request

    static func image(character: Character) -> Request<UIImage> {
        Request<UIImage>(
            endpoint: .image(character: character),
            parse: Parse.image()
        )
    }
}

extension Request {

    var queryItems: [URLQueryItem] {
        switch endpoint {
        case let .characters(offset, limit):
            return [
                URLQueryItem(name: "apikey", value: Config.publicKey),
                URLQueryItem(name: "hash", value: Config.hash),
                URLQueryItem(name: "ts", value: Config.timeStamp),
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        case .image:
            return []
        }
    }

    var path: String {
        switch endpoint {
        case .characters:
            return "/characters"
        case .image:
            return ""
        }
    }

    var url: String {
        switch endpoint {
        case .characters:
            return Config.baseUrl + path
        case let .image(character):
            return character.imageURL
        }
    }
}

extension Request {

    struct Config {

        private static var privateKey: String {
            "a89f138c676051b2e89a605be766fa85b6414f03"
        }

        static var publicKey: String {
            "c87841b30c120206462d01302fd68c67"
        }

        static var timeStamp: String {
            let formatter = DateFormatter()..{
                $0.dateFormat = "yyyyMMddHHmmss"
            }

            return formatter.string(from: Date())
        }

        static var baseUrl: String {
            "https://gateway.marvel.com/v1/public"
        }

        static var hash: String {
            "\(timeStamp)\(privateKey)\(publicKey)".md5
        }
    }
}
