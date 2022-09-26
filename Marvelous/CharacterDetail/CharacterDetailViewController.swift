import Foundation
import UIKit

class CharacterDetailViewController: UIViewController {

    private let character: Character
    private let theme: Theme = ThemeFactory().random()

    private lazy var viewModel = CharacterDetailViewModel(character: character)

    private weak var header: CharacterDetailHeader?

    private struct Config {
        static let imageAspectRatio = DSM.AspectRatio.characterImage
        static let imageWidth = UIScreen.main.bounds.width / 2
        static let imageHeight = imageWidth * imageAspectRatio
        static let imageSize = CGSize(width: imageWidth, height: imageHeight)
    }

    // MARK: Subviews

    private lazy var tableView = UITableView(frame: .zero, style: .grouped)..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = nil
        $0.isOpaque = false
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none

        $0.register(
            CharacterDetailTableViewCell.self,
            forCellReuseIdentifier: CharacterDetailTableViewCell.reuseIdentifier
        )

        $0.register(
            CharacterDetailHeader.self,
            forHeaderFooterViewReuseIdentifier: CharacterDetailHeader.reuseIdentifier
        )
    }

    // MARK: Initialization

    init(character: Character) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.clipsToBounds = true
        view.backgroundColor = DSM.Color.background
        view.setTexture(.pinStripes)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        view.textureView?.startAnimation()
    }
}

// MARK: - UITableViewDataSource

extension CharacterDetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterDetailTableViewCell.reuseIdentifier, for: indexPath)

        if let cell = cell as? CharacterDetailTableViewCell {
            cell.viewModel = viewModel.cellViewModel(at: indexPath)
            cell.theme = theme
            cell.isLastItem = indexPath.row == viewModel.numberOfRows - 1
        }

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: CharacterDetailHeader.reuseIdentifier)

        if let header = header as? CharacterDetailHeader {
            header.character = character
            header.theme = theme
            self.header = header
        }

        return header
    }
}

// MARK: - UITableViewDelegate

extension CharacterDetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        DSM.GridSize._80
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let summaryHeight = character.description?.size(
            font: DSM.Font.summary,
            maxWidth: CharacterDetailHeader.Summary.maxWidth
        ).height ?? 0

        return CharacterDetailHeader.Config.totalHeight + (summaryHeight / 2)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isDragging, !scrollView.isDecelerating, scrollView.contentOffset.y < -DSM.GridSize._40 {
            dismiss(animated: true)
        }
    }
}

// MARK: - Transition

extension CharacterDetailViewController: CharacterPresentable {

    var sharedView: UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: CharacterDetailHeader.reuseIdentifier
        ) as? CharacterDetailHeader

        return header?.characterImageView
    }

    func animateAlongPresentation(animator: UIViewPropertyAnimator, origin: CGRect, destination: CGRect) {

    }

    func animateAlongDismissal(animator: UIViewPropertyAnimator, destination: CGRect) {
        view.textureView?.alpha = 0
        view.backgroundColor = .clear

        header?.background.alpha = 0
        header?.nameLabel.alpha = 0

        animator.addAnimations { [weak self] in
            self?.header?.characterImageView.alpha = 0
        }
    }
}
