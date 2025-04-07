//
//  CustomTableViewCell.swift
//  GiFinder
//
//  Created by Pierrick Dennemont on 24/03/2025.
//

import UIKit
import Photos

//Inclut un délégué qui permet de notifier le viewController lors de 'appui de la cellule
protocol CustomTableViewCellDelegate: AnyObject {
    func didTapDownloadButton(in cell: CustomTableViewCell)
}



class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    weak var delegate: CustomTableViewCellDelegate?  // Référence au délégué
    var url: String = ""
    
    //Au clic -> appelle la fonction pour télécharher et change la couleur de la cellule pour une meilleure expérience utilisateur
    @IBAction func click(_ sender: UIButton) {
        self.contentView.backgroundColor = UIColor.lightGray
        
        //Télécharge le GIF
        GiphyAPIHandle.shared.downloadAndSavePhotoGIF(from: url)
        
        //Informer le délégué que le bouton a été tapé -> appel de showDownloadAlert() dans le viewController
        
        delegate?.didTapDownloadButton(in: self)
        
        // Réinitialiser la couleur du bouton après un court délai
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.contentView.backgroundColor = UIColor.clear
        }
    }
    
    
    func loadGif(from url: String) {
        if let gifImage = UIImage.gifImageWithURL(url) {    //On vérifie que l'url n'est pas nil
            DispatchQueue.main.async {
                self.gifImageView.image = gifImage
                self.url = url
            }
        }
    }

    
}
