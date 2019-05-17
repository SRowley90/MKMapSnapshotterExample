//
//  TestCell.swift
//  MKSnapshotExample
//
//  Created by Sam Rowley on 17/05/2019.
//  Copyright © 2019 Travel Counsellors. All rights reserved.
//

import UIKit
import MapKit

class TestCell: UITableViewCell {
    
    @IBOutlet weak var mapViewContainer: UIView!
    @IBOutlet weak var mapLoadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var mapSnapshotImageView: UIImageView!
    
    var mapImage: UIImage?

    func setup() {
        mapViewContainer.isHidden = true
        mapLoadingIndicatorView.isHidden = true
        
        mapViewContainer.isHidden = false
        if let mapImage = self.mapImage {
            mapSnapshotImageView.image = mapImage
        } else {
            self.mapLoadingIndicatorView.isHidden = false
            mapLoadingIndicatorView.startAnimating()
            let centerCoordinate = CLLocationCoordinate2D(latitude: 25.131283, longitude: 55.117745)
            let distanceInMeters: Double = 500
            
            let options = MKMapSnapshotter.Options()
            options.region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: distanceInMeters, longitudinalMeters: distanceInMeters)
            options.size = self.mapSnapshotImageView.bounds.size
            
            let bgQueue = DispatchQueue.global(qos: .background)
            let snapShotter = MKMapSnapshotter(options: options)
            snapShotter.start(with: bgQueue, completionHandler: { [weak self] (snapshot, error) in
                guard error == nil else {
                    return
                }
                
                if let snapShotImage = snapshot?.image {
                    UIGraphicsBeginImageContextWithOptions(snapShotImage.size, true, snapShotImage.scale)
                    snapShotImage.draw(at: CGPoint.zero)
                    let mapImage = UIGraphicsGetImageFromCurrentImageContext()
                    DispatchQueue.main.async {
                        self?.mapSnapshotImageView.image = mapImage
                        self?.mapLoadingIndicatorView.stopAnimating()
                        self?.mapLoadingIndicatorView.isHidden = true
                        self?.mapImage = mapImage
                    }
                    UIGraphicsEndImageContext()
                }
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mapSnapshotImageView.layer.borderColor = UIColor.lightGray.cgColor
        self.mapSnapshotImageView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
