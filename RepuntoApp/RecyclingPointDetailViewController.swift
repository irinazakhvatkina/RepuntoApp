import UIKit
import SnapKit
import CoreLocation

class RecyclingPointDetailViewController: UIViewController {
    let point: RecyclingPoint

    let segmentedControl = UISegmentedControl(items: ["Информация", "Фото", "Контакты"])
    let cardView = UIView()

    let infoView = UIStackView()
    let photosCollectionView: UICollectionView
    let contactsView = UIStackView()

    // MARK: - Init
    init(point: RecyclingPoint) {
        self.point = point

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.photosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        setupSegmentedControl()
        setupCardView()
        setupInfoView()
        setupPhotosCollectionView()
        setupContactsView()
        addCloseButton()
        addBackgroundTapGesture()

        segmentedControl.selectedSegmentIndex = 0
        segmentedControlValueChanged(segmentedControl)
    }

    // MARK: - Setup UI
    func setupCardView() {
        view.addSubview(cardView)
        cardView.backgroundColor = .systemBackground
        cardView.layer.cornerRadius = 20
        cardView.clipsToBounds = true

        cardView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }

    func setupSegmentedControl() {
        cardView.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)

        segmentedControl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    func setupInfoView() {
        infoView.axis = .vertical
        infoView.spacing = 10
        infoView.alignment = .fill

        if !point.address.isEmpty {
            let label = createLabel("📍 Адрес: \(point.address)")
            infoView.addArrangedSubview(label)
        }

        if !point.materialType.isEmpty {
            let label = createLabel("♻️ Тип: \(point.materialType)")
            infoView.addArrangedSubview(label)
        }

        if !point.description.isEmpty {
            let label = createLabel("📝 \(point.description)")
            label.numberOfLines = 0
            infoView.addArrangedSubview(label)
        }

        cardView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }

    func setupPhotosCollectionView() {
        photosCollectionView.isHidden = true
        photosCollectionView.dataSource = self
        photosCollectionView.delegate = self
        photosCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        photosCollectionView.backgroundColor = .clear
        photosCollectionView.showsHorizontalScrollIndicator = false
        photosCollectionView.isPagingEnabled = true
        photosCollectionView.decelerationRate = .fast

        cardView.addSubview(photosCollectionView)
        photosCollectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    func setupContactsView() {
        contactsView.axis = .vertical
        contactsView.spacing = 10
        contactsView.alignment = .fill

        for contact in point.contacts {
            let label = createLabel(contact)
            contactsView.addArrangedSubview(label)
        }

        cardView.addSubview(contactsView)
        contactsView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
        contactsView.isHidden = true
    }

    func createLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }

    // MARK: - Close & Tap Gesture
    func addCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .gray
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.width.height.equalTo(30)
        }
    }

    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }

    func addBackgroundTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !cardView.frame.contains(location) {
            dismiss(animated: true, completion: nil)
        }
    }

    // MARK: - Segmented Control Handler
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        infoView.isHidden = true
        photosCollectionView.isHidden = true
        contactsView.isHidden = true

        switch sender.selectedSegmentIndex {
        case 0:
            infoView.isHidden = false
        case 1:
            photosCollectionView.isHidden = false
        case 2:
            contactsView.isHidden = false
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDataSource & DelegateFlowLayout
extension RecyclingPointDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return point.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
            return UICollectionViewCell()
        }
        cell.imageView.image = point.photos[indexPath.item]
        return cell
    }

    // Адаптивный размер ячейки = вся ширина collectionView
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

// MARK: - Custom UICollectionViewCell
class PhotoCell: UICollectionViewCell {
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.layer.cornerRadius = 8
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 3
        contentView.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
