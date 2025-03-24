//
//  CustomTableViewCell.swift
//  GiFinder
//
//  Created by Pierrick Dennemont on 24/03/2025.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var gifImageView: UIImageView!
    func loadGif(from url: String) {
        if let gifImage = UIImage.gifImageWithURL(url) {    //On vérifie que l'url n'est pas nil
            DispatchQueue.main.async {
                self.gifImageView.image = gifImage
            }
        }
    }
}
