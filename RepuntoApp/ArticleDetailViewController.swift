//
//  ArticleDetailViewController.swift
//  RepuntoApp
//
//  Created by Irina Zakhvatkina on 02/08/25.
//

import UIKit
import SnapKit

class ArticleDetailViewController: UIViewController {

    let article: Article

    let scrollView = UIScrollView()
    let contentView = UIView()

    let titleLabel = UILabel()
    let imageView = UIImageView()
    let contentLabel = UILabel()

    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        configure()
    }

    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(contentLabel)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12

        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.numberOfLines = 0

        let margin: CGFloat = 16

        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(margin)
        }

        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(220)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.trailing.bottom.equalToSuperview().inset(margin)
        }
    }

    func configure() {
        titleLabel.text = article.title
        imageView.image = article.image
        contentLabel.text = article.content
    }
}

