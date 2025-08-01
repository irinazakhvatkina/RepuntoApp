//
//  ViewController.swift
//  RepuntoApp
//
//  Created by Irina Zakhvatkina on 28/07/25.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    var isDarkMode: Bool {
        return traitCollection.userInterfaceStyle == .dark
    }

    var burgerButton: UIButton!
    var themeToggleButton: UIButton!

    var cleanEarthImageView: UIImageView!
    var dirtyEarthImageView: UIImageView!
    var playButton: UIButton!
    var isCleanState = false

    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var factLabel1: UILabel!
    var factLabel2: UILabel!
    var factLabel3: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        setupNavigationBar()
        updateTheme()
        setupUI()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateTheme()
        }
    }

    func setupNavigationBar() {
        let logoButton = UIButton(type: .system)
        let logoImage = UIImage(named: "logo")?.withRenderingMode(.alwaysOriginal)
        logoButton.setImage(logoImage, for: .normal)
        logoButton.imageView?.contentMode = .scaleAspectFit
        logoButton.addTarget(self, action: #selector(logoTapped), for: .touchUpInside)
        logoButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        navigationItem.titleView = logoButton

        burgerButton = UIButton(type: .system)
        let burgerImage = UIImage(systemName: "line.3.horizontal")
        burgerButton.setImage(burgerImage, for: .normal)
        burgerButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        burgerButton.addTarget(self, action: #selector(burgerTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: burgerButton)

        themeToggleButton = UIButton(type: .system)
        themeToggleButton.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        themeToggleButton.addTarget(self, action: #selector(toggleTheme), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: themeToggleButton)
    }

    @objc func toggleTheme() {
        let newStyle: UIUserInterfaceStyle = isDarkMode ? .light : .dark
        view.window?.overrideUserInterfaceStyle = newStyle
    }

    func updateTheme() {
        let iconColor = UIColor(named: "primaryText")
        burgerButton.tintColor = iconColor
        themeToggleButton.tintColor = iconColor
        let newIconName = isDarkMode ? "sun.max" : "moon.stars"
        let newImage = UIImage(systemName: newIconName)
        themeToggleButton.setImage(newImage, for: .normal)
        navigationController?.navigationBar.tintColor = UIColor(named: "primaryText")
    }

    @objc func burgerTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Карта", style: .default, handler: { _ in
            let mapVC = MapViewController()
            self.navigationController?.pushViewController(mapVC, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Блог", style: .default, handler: { _ in
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = navigationItem.leftBarButtonItem
        }
        present(alert, animated: true)
    }


    @objc func logoTapped() {
        navigationController?.popToRootViewController(animated: true)
    }

    func setupUI() {
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor(named: "primaryText")

        subtitleLabel = UILabel()
        subtitleLabel.textAlignment = .center
        subtitleLabel.font = UIFont.systemFont(ofSize: 24)
        subtitleLabel.textColor = UIColor(named: "primaryText")

        factLabel1 = UILabel()
        factLabel1.textAlignment = .center
        factLabel1.font = UIFont.italicSystemFont(ofSize: 14)
        factLabel1.textColor = UIColor(named: "primaryText")
        factLabel1.numberOfLines = 0
        
        factLabel2 = UILabel()
        factLabel2.textAlignment = .center
        factLabel2.font = UIFont.italicSystemFont(ofSize: 14)
        factLabel2.textColor = UIColor(named: "primaryText")
        factLabel2.numberOfLines = 0
        
        factLabel3 = UILabel()
        factLabel3.textAlignment = .center
        factLabel3.font = UIFont.italicSystemFont(ofSize: 14)
        factLabel3.textColor = UIColor(named: "primaryText")
        factLabel3.numberOfLines = 0

        dirtyEarthImageView = UIImageView(image: UIImage(named: "dirty_earth"))
        cleanEarthImageView = UIImageView(image: UIImage(named: "clean_earth"))
        cleanEarthImageView.alpha = 0

        playButton = UIButton(type: .custom)
        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        playButton.tintColor = .white
        playButton.addTarget(self, action: #selector(playPressed), for: .touchUpInside)

        [titleLabel, subtitleLabel, dirtyEarthImageView, cleanEarthImageView, playButton, factLabel1, factLabel2, factLabel3].forEach { view.addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(20)
        }

        dirtyEarthImageView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }

        cleanEarthImageView.snp.makeConstraints { make in
            make.edges.equalTo(dirtyEarthImageView)
        }

        playButton.snp.makeConstraints { make in
            make.center.equalTo(dirtyEarthImageView)
            make.width.height.equalTo(60)
        }

        factLabel1.snp.makeConstraints { make in
            make.top.equalTo(dirtyEarthImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }

        factLabel2.snp.makeConstraints { make in
            make.top.equalTo(factLabel1.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
        
        factLabel3.snp.makeConstraints { make in
            make.top.equalTo(factLabel2.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(20)
        }
        
        updateContent()
    }

    func updateContent() {
        if isCleanState {
            titleLabel.text = "Создавать решение — твой шанс!"
            subtitleLabel.text = "ДЕЙСТВОВАТЬ!"
            factLabel1.text = "Факт1: Переработка 1 кг бумаги экономит 0,7 кг CO₂"
            factLabel2.text = "Факт2: Запретили одноразовый пластик более 70 стран"
            factLabel3.text = "Факт3: Каждое дерево поглощает CO₂ 21 кг в год"


        } else {
            titleLabel.text = "Если ничего не делать!"
            subtitleLabel.text = "ИГНОРИРОВАТЬ!"
            factLabel1.text = "Факт1: В океане ежегодно пластика 8 млн тонн"
            factLabel2.text = "Факт2: Каждую минуту вырубается 36 тыс деревьев"
            factLabel3.text = "Факт3: Из-за транспорта загрязняется 70% воздуха"
        }
    }

    @objc func playPressed() {
        isCleanState.toggle()

        let fromImageView = isCleanState ? dirtyEarthImageView : cleanEarthImageView
        let toImageView = isCleanState ? cleanEarthImageView : dirtyEarthImageView

        toImageView?.alpha = 0
        UIView.transition(with: toImageView!, duration: 1.2, options: [.transitionCrossDissolve]) {
            toImageView?.alpha = 1
            fromImageView?.alpha = 0
        }

        toImageView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 1.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5) {
            toImageView?.transform = .identity
        }

        updateContent()
    }
}
