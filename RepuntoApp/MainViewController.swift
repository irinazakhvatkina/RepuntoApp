//
//  ViewController.swift
//  RepuntoApp
//
//  Created by Irina Zakhvatkina on 28/07/25.
//

import UIKit

class MainViewController: UIViewController {

    var isDarkMode: Bool {
        return traitCollection.userInterfaceStyle == .dark
    }

    var burgerButton: UIButton!
    var themeToggleButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "background")
        setupNavigationBar()
        updateTheme()
    }

    // This function is called whenever the theme changes
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

    // MARK: - Theme Management
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

    // MARK: - Actions
    @objc func burgerTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Карта", style: .default, handler: { _ in
            print("Открыта Карта")
        }))
        alert.addAction(UIAlertAction(title: "Блог", style: .default, handler: { _ in
            print("Открыт Блог")
        }))
        alert.addAction(UIAlertAction(title: "О нас", style: .default, handler: { _ in
            print("Открыт экран 'О нас'")
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = navigationItem.leftBarButtonItem
        }

        present(alert, animated: true)
    }

    @objc func logoTapped() {
        navigationController?.popToRootViewController(animated: true)
        print("Возврат на главный экран")
    }
}
