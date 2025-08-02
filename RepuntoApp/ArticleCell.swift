//
//  ArticleCell.swift
//  RepuntoApp
//
//  Created by Irina Zakhvatkina on 02/08/25.
//

import UIKit
import SnapKit

class ArticleCell: UITableViewCell {

    let titleLabel = UILabel()
    let articleImageView = UIImageView()
    let summaryLabel = UILabel()
    let dateLabel = UILabel()
    let readButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(articleImageView)
        contentView.addSubview(summaryLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(readButton)

        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0

        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 8

        summaryLabel.font = UIFont.systemFont(ofSize: 14)
        summaryLabel.numberOfLines = 3
        summaryLabel.textColor = .darkGray

        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray

        readButton.setTitle("Читать", for: .normal)

        let margin: CGFloat = 12

        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(margin)
        }

        articleImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(margin)
            make.height.equalTo(180)
        }

        summaryLabel.snp.makeConstraints { make in
            make.top.equalTo(articleImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(margin)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(summaryLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(margin)
            make.bottom.equalToSuperview().inset(margin)
        }

        readButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalToSuperview().inset(margin)
        }
    }

    func configure(with article: Article) {
        titleLabel.text = article.title
        articleImageView.image = article.image
        summaryLabel.text = article.summary

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "ru_RU")
        dateLabel.text = formatter.string(from: article.date)
    }
}
