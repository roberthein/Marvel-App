import Foundation
import UIKit
import CryptoKit

infix operator .. : MultiplicationPrecedence

@discardableResult public func .. <T>(object: T, block: (inout T) -> Void) -> T {
    var object = object
    block(&object)
    return object
}

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {

    static var reuseIdentifier: String {
        String(describing: self)
    }
}

extension String {

    var md5: String {
        let hash = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())

        return hash.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}

@propertyWrapper public struct LossyCodableList<Element> {

    public var elements: [Element]

    public var wrappedValue: [Element] {
        get { elements }
        set { elements = newValue }
    }
}

extension LossyCodableList: Decodable where Element: Decodable {

    private struct ElementWrapper: Decodable {
        var element: Element?

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            element = try? container.decode(Element.self)
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let wrappers = try container.decode([ElementWrapper].self)
        elements = wrappers.compactMap(\.element)
    }
}

extension LossyCodableList: Encodable where Element: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        for element in elements {
            try? container.encode(element)
        }
    }
}

extension Collection {

    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension UIApplication {

    var keyWindow: UIWindow? {
        connectedScenes
            .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
            .first { $0.isKeyWindow }
    }

    var statusBarFrame: CGRect {
        keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? .zero
    }
}

public extension FloatingPoint {

    var deg2rad: Self {
        self * .pi / 180
    }

    func map(from: ClosedRange<Self>, to: ClosedRange<Self>) -> Self {
        guard from.upperBound - from.lowerBound != 0 else { return self }

        return ((self - from.lowerBound) / (from.upperBound - from.lowerBound)) * (to.upperBound - to.lowerBound) + to.lowerBound
    }
}

public extension Comparable {

    func clamped(within range: ClosedRange<Self>) -> Self {
        guard !range.contains(self) else { return self }

        return min(max(self, range.lowerBound), range.upperBound)
    }
}

public extension CGSize {

    static func square(size: CGFloat) -> CGSize {
        CGSize(width: size, height: size)
    }
}

extension String {

    func size(font: UIFont, maxWidth: CGFloat) -> CGSize {
        let attributedString = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font])
        let boundingRect = attributedString.boundingRect(with: CGSize(width: maxWidth, height: .greatestFiniteMagnitude), options: [.usesDeviceMetrics, .usesLineFragmentOrigin], context: nil)
        let stringSize = CGSize(width: boundingRect.width, height: boundingRect.height)

        return stringSize
    }
}
