import UIKit

class SearchAccessoryView: UIView {

    // MARK: Subviews

    private(set) lazy var searchLabel = TitleLabel(
        strokeColor: DSM.Color.newBlack,
        strokeWidth: DSM.BorderWidth.large
    )..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = DSM.Font.search
        $0.numberOfLines = 1
        $0.textColor = DSM.Color.softPink
        $0.textAlignment = .center
        $0.isUserInteractionEnabled = false
        $0.text = textField.attributedPlaceholder?.string
    }

    private(set) lazy var textField = UITextField()..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alpha = 0.05
        $0.attributedPlaceholder = NSAttributedString(
            string: "search".uppercased(),
            attributes: [
                .font: DSM.Font.search,
                .foregroundColor: UIColor.clear,
                .paragraphStyle: NSMutableParagraphStyle()..{
                    $0.alignment = .center
                }
            ])
    }

    // MARK: Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = nil
        isOpaque = false

        addSubview(textField)
        addSubview(searchLabel)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: DSM.Spacing._20),
            textField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -DSM.Spacing._20),

            searchLabel.topAnchor.constraint(equalTo: textField.topAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            searchLabel.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            searchLabel.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Actions

    func didChangeQuery() {
        let rotationAngle = CGFloat.random(in: -4 ... 4).deg2rad
        searchLabel.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
}
