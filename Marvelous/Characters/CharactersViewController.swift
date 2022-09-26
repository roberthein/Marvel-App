import UIKit

class CharactersViewController: UIViewController {

    private lazy var viewModel = CharactersViewModel()
    private lazy var transition = CharacterTransition(from: self)
    private var selectedCell: CharacterViewCell?

    private let feedback = UIImpactFeedbackGenerator(style: .heavy)

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CharactersLayout(
            configuration: .init(
                minimumInteritemSpacing: DSM.Spacing._10,
                minimumLineSpacing: DSM.Spacing._10,
                numberOfColumns: 3,
                itemAspectRatio: DSM.AspectRatio.characterImage
            )
        )
    )..{
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentInset = UIEdgeInsets(
            top: UIApplication.shared.statusBarFrame.height,
            left: DSM.Spacing._30,
            bottom: 100,
            right: DSM.Spacing._30
        )
        $0.isPrefetchingEnabled = true
        $0.prefetchDataSource = self
        $0.alwaysBounceVertical = true
        $0.backgroundColor = nil
        $0.keyboardDismissMode = .onDragWithAccessory
        $0.delegate = self

        $0.register(
            CharacterViewCell.self,
            forCellWithReuseIdentifier: CharacterViewCell.reuseIdentifier
        )

        $0.register(
            CharactersSupplementaryView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CharactersSupplementaryView.reuseIdentifier
        )
    }

    private lazy var accessoryView = SearchAccessoryView(
        frame: CGRect(
            origin: .zero,
            size: CGSize(width: view.bounds.width, height: DSM.GridSize._80)
        )
    )..{
        $0.textField.delegate = self
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DSM.Color.background
        view.setTexture(.pinStripes)

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        bindDataSource()

        viewModel.loadData()
        collectionView.reloadData()
    }

    override var inputAccessoryView: UIView? {
        accessoryView
    }

    override var canBecomeFirstResponder: Bool {
        true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
        view.textureView?.startAnimation()

        becomeFirstResponder()
    }

    // MARK: Bindings

    private func bindDataSource() {
        viewModel.dataSource = UICollectionViewDiffableDataSource<Section, Character>(collectionView: collectionView) { [weak self] collectionView, indexPath, character -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterViewCell.reuseIdentifier, for: indexPath)

            self?.viewModel.loadImage(for: character)
            (cell as? CharacterViewCell)?.character = character

            return cell
        }

        viewModel.dataSource?.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: CharactersSupplementaryView.reuseIdentifier,
                for: indexPath
            )

            supplementaryView.transform = .identity

            return supplementaryView
        }
    }

    // MARK: Presentation

    func present(viewController: UIViewController) {
        feedback.impactOccurred()

        viewController.transitioningDelegate = transition
        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate

extension CharactersViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.verticalScrollIndicatorInsets.top = abs(min(-1, view.safeAreaInsets.top + scrollView.contentOffset.y))

        let bottomPosition = scrollView.bounds.maxY
        let totalHeight = scrollView.contentSize.height
        let maxDistanceFromBottom = scrollView.bounds.height * 5
        let shouldLoadMore = bottomPosition > totalHeight - maxDistanceFromBottom

        guard viewModel.state != .isLoading, shouldLoadMore else { return }
        viewModel.loadData()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? CharacterViewCell

        guard let character = viewModel.dataSource.itemIdentifier(for: indexPath) else { return }
        let detailViewController = CharacterDetailViewController(character: character)

        accessoryView.textField.resignFirstResponder()
        present(viewController: detailViewController)
    }
}

// MARK: - Data Source Prefetching

extension CharactersViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            viewModel.prefetchImage(at: indexPath)
        }
    }
}

// MARK: - Transition

extension CharactersViewController: CharacterPresenting {

    var sharedView: UIView? {
        selectedCell
    }

    var containingView: UIView? {
        collectionView
    }
}

// MARK: - UISearchBarDelegate

extension CharactersViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let query = currentText.replacingCharacters(in: stringRange, with: string)

        viewModel.search(query: query)

        let hasQuery = !query.isEmpty
        accessoryView.searchLabel.text = hasQuery ? query : accessoryView.textField.attributedPlaceholder?.string
        accessoryView.searchLabel.textColor = hasQuery ? DSM.Color.babyBlue : DSM.Color.softPink
        accessoryView.didChangeQuery()

        return true
    }
}
