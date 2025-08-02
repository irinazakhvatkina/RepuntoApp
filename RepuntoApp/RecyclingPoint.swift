//
//  RecyclingPoint.swift
//  RepuntoApp
//
//  Created by Irina Zakhvatkina on 02/08/25.
//
import CoreLocation
import UIKit

struct RecyclingPoint {
    let coordinate: CLLocationCoordinate2D
    let materialType: String
    let title: String
    let address: String
    let description: String
    let photos: [UIImage]
    let contacts: [String]
}
