import UIKit
import Foundation

typealias ImageCompletion = (Character, UIImage?) -> Void

let Images = ImageCache()

class ImageCache {

    private let service = ImageService()
    private let cache = NSCache<NSURL, UIImage>()
    private var prefetches: Set<Character> = []
    private var completions: [Int: [ImageCompletion]] = [:]

    // MARK: Prefetch

    func prefetchImage(for character: Character) {
        guard let imageURL = URL(string: character.imageURL) else {
            assert(false, "Invalid image URL.")
            return
        }

        let url = imageURL as NSURL

        guard cachedImage(for: url) == nil, !prefetches.contains(character) else { return }

        prefetches.insert(character)

        Task { [weak self] in
            guard let self = self else { return }
            let response = try await self.service.fetchImage(character: character)

            switch response {
            case let .success(image):
                self.cache.setObject(image, forKey: url)
                DispatchQueue.main.async {
                    self.prefetches.remove(character)
                }
            case let .failure(error):
                assert(false, "ERROR:\(error)")
            }
        }
    }

    // MARK: Cache

    private func cachedImage(for url: NSURL) -> UIImage? {
        cache.object(forKey: url)
    }

    // MARK: Load

    func loadImage(for character: Character, completion: @escaping ImageCompletion) {
        guard let imageURL = URL(string: character.imageURL) else {
            assert(false, "Invalid image URL.")
            return
        }

        let url = imageURL as NSURL

        if let image = cachedImage(for: url) {
            completion(character, image)
            return
        }

        if completions[character.id] != nil {
            completions[character.id]?.append(completion)
            return
        } else {
            completions[character.id] = [completion]
        }

        Task { [weak self] in
            guard let self = self else { return }
            let response = try await self.service.fetchImage(character: character)

            switch response {
            case let .success(image):
                guard let completions = self.completions[character.id] else {
                    completion(character, nil)
                    return
                }

                self.cache.setObject(image, forKey: url)

                completions.forEach { completion in
                    completion(character, image)
                }
            case let .failure(error):
                assert(false, "ERROR:\(error)")
                completion(character, nil)
            }

            DispatchQueue.main.async {
                self.completions.removeValue(forKey: character.id)
            }
        }
    }
}
