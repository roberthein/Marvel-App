import Foundation
import UIKit

protocol CharacterPresenting {
    var sharedView: UIView? { get }
    var containingView: UIView? { get }
}
