import Foundation
import UIKit

class Character: Codable {
    let id: Int
    let name: String
    let description: String?
    let resourceURI: String?
    let urls: [Character.Url]?
    let thumbnail: Character.Image
    let comics: Character.ComicList
    let stories: Character.StoryList?
    let events: Character.EventList?
    let series: Character.SeriesList?

    var image: UIImage?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case resourceURI
        case urls
        case thumbnail
        case comics
        case stories
        case events
        case series
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        resourceURI = try container.decode(String.self, forKey: .resourceURI)
        urls = try container.decode([Character.Url].self, forKey: .urls)
        thumbnail = try container.decode(Character.Image.self, forKey: .thumbnail)
        comics = try container.decode(Character.ComicList.self, forKey: .comics)
        stories = try container.decode(Character.StoryList.self, forKey: .stories)
        events = try container.decode(Character.EventList.self, forKey: .events)
        series = try container.decode(Character.SeriesList.self, forKey: .series)
        image = nil
    }
}

extension Character {

    struct Url: Codable {
        let type: String?
        let url: String?
    }

    struct Image: Codable {
        let path: String
        let `extension`: String
    }

    struct ComicList: Codable {
        let available: Int?
        let returned: Int?
        let collectionURI: String?
        let items: [ComicSummary]
    }

    struct ComicSummary: Codable {
        let resourceURI: String?
        let name: String?
    }

    struct StoryList: Codable {
        let available: Int?
        let returned: Int?
        let collectionURI: String?
        let items: [StorySummary]?
    }

    struct StorySummary: Codable {
        let resourceURI: String?
        let name: String?
        let type: String?
    }

    struct EventList: Codable {
        let available: Int?
        let returned: Int?
        let collectionURI: String?
        let items: [EventSummary]?
    }

    struct EventSummary: Codable {
        let resourceURI: String?
        let name: String?
    }

    struct SeriesList: Codable {
        let available: Int?
        let returned: Int?
        let collectionURI: String?
        let items: [SeriesSummary]?
    }

    struct SeriesSummary: Codable {
        let resourceURI: String?
        let name: String?
    }
}

// MARK: - Equatable

extension Character: Equatable {

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension Character: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(imageURL)
        hasher.combine(image)
    }
}

// MARK: - Image URL

extension Character {

    var imageURL: String {
        thumbnail.path + "." + thumbnail.extension
    }
}

// MARK: - Placeholder

extension Character {

    var shouldShowPlaceholder: Bool {
        thumbnail.path.contains("image_not_available") || thumbnail.extension == "gif"
    }
}
