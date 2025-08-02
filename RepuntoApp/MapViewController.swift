//
//  MapViewController.swift
//  RepuntoApp
//
//  Created by Irina Zakhvatkina on 01/08/25.
//

import UIKit
import SnapKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!

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
        setupMapView()
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

        alert.addAction(UIAlertAction(title: "Главная", style: .default, handler: { _ in
            let mapVC = MainViewController()
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

    func setupMapView() {
        mapView = MKMapView()
        view.addSubview(mapView)

        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }

        mapView.layer.cornerRadius = 20
        mapView.layer.masksToBounds = true
        mapView.layer.borderColor = UIColor(named: "background")?.cgColor
        mapView.layer.borderWidth = 2

        mapView.delegate = self
        mapView.showsUserLocation = true

        let center = CLLocationCoordinate2D(latitude: 38.5598, longitude: 68.7870)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: false)
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polygon = overlay as? MKPolygon {
            let renderer = MKPolygonRenderer(polygon: polygon)
            renderer.fillColor = isDarkMode ? UIColor.systemGreen.withAlphaComponent(0.3) : UIColor.systemBlue.withAlphaComponent(0.3)
            renderer.strokeColor = UIColor.systemGreen
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

}
