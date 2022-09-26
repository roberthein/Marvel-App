import Foundation
import UIKit

struct Parse {

    // MARK: Data

    static func data<T: Codable>() -> ((Data) -> Result<T, Error>) {
        return { data in
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                return .success(decoded)
            } catch {
                return .failure(APIError.noData)
            }
        }
    }

    // MARK: Image

    static func image() -> ((Data) -> Result<UIImage, Error>) {
        return { data in
            guard let image = UIImage(data: data) else {
                return .failure(APIError.notImageData)
            }

            return .success(image)
        }
    }
}
