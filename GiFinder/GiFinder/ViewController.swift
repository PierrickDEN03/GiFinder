//
//  ViewController.swift
//  GiFinder
//
//  Created by Pierrick Dennemont on 24/03/2025.
//

import UIKit
import Foundation

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, CustomTableViewCellDelegate {
    //Initialisation des variables du controlleur
    var boolShowAlert = true
    var largeLoadingView = UIActivityIndicatorView(style: .large)
    var mediumLoadingView = UIActivityIndicatorView(style: .medium)
    var currentTitle: String? //Mots-clés renseignés
    var images: [String] = []
    var isLoading = false
    var isTotalContent = false
    
    @IBOutlet weak var queryField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //Au clic du bouton, charge les gifs par mots-clés et actualise le tableau
    @IBAction func clic(_ sender: Any) {
        tableView.setContentOffset(.zero, animated: false)
        currentTitle = queryField.text
        isTotalContent = false
        images = []
        self.tableView.reloadData()
        self.loadGifs(loader:largeLoadingView)
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            tableView.delegate = self
            //Initialisation des images de chargement
            largeLoadingView.center = self.view.center
            self.view.addSubview(largeLoadingView)
            mediumLoadingView.center = CGPoint(x: self.view.center.x, y: self.view.frame.size.height - mediumLoadingView.frame.size.height - 20 / 2)
            self.view.addSubview(mediumLoadingView)
        }
    
    // TableView fonctions au chargement
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
            let imageUrl = images[indexPath.row]
        cell.loadGif(from: imageUrl)
        
        //Affecter le délégué de la cellule à "self"
        cell.delegate = self
        return cell
    }
    
    //Fonctions qui recharge des gifs à la fin du scroll dans le tableau
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Calcul du scroll de l'utilisateur
        let scrollTrueOffset = scrollView.contentOffset.y + tableView.frame.size.height
        
        //Charge les GIF ou un message d'erreur si scroll atteint
        if (scrollView.contentSize.height <= scrollTrueOffset && !isLoading){
            if !isTotalContent{
                self.loadGifs(loader:mediumLoadingView,waitTimeMS: 500)
            }else{
                showAlert(title: "Recherche finie", msg: "Vous avez trouvé tous les résultats pour cette recherche")
            }
        }
    }
    

    
    
    //Fonction qui charge les GIF et les rajoute dans le tableau
    //Prend en paramètre un "loader" -> Icone de chargement
    private func loadGifs(loader:UIActivityIndicatorView, waitTimeMS: Int = 0){
        if(!isLoading){
            // Pour empêcher  qu'il y ait d'autres plusieurs requêtes déclenchées en même temps
            self.isLoading = true
            loader.startAnimating()
            Task {
                //Vérification des mots clés
                if  (currentTitle != nil && currentTitle != "") {
                    let tempImage: [String]
                    (tempImage, self.isTotalContent) = await
                    
                    //Appel API
                    //Offset défini en fonction du nb d'images dans le tableau
                    GiphyAPIHandle.shared.call(queryStr: currentTitle!, offset: images.count)
                    self.images.append(contentsOf: tempImage)
                    if(self.images == []){
                        showAlert(title: "Aucun résultat", msg: "Nous n'avons trouvé aucun résultat pour cette recherche")
                    }
                    
                    //Temps d'attente pour une meilleure expérience utilisateur
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(waitTimeMS)) {
                        self.tableView.reloadData()
                        self.isLoading = false
                        loader.stopAnimating()
                    }
                }else{
                    self.showAlert(title: "Champs vide", msg: "Le champs de texte est vide, veuillez renseigner le style de gif que vous recherchez")
                    self.isLoading = false
                    loader.stopAnimating()
                }
            }
        }
        
    }
    
    
    //Implémentation du protocole CustomTableViewCellDelegate
    func didTapDownloadButton(in cell: CustomTableViewCell) {
        if self.boolShowAlert {
            //Lancer l'alerte depuis le contrôleur de vue
            showDownloadAlert()
        }
            
    }
    
    private func showDownloadAlert() {
        let alertController = UIAlertController(title: "Téléchargement réussi !", message: "", preferredStyle: .alert)
        
        // Bouton "OK"
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        // Bouton "Ne plus me demander"
        alertController.addAction(UIAlertAction(title: "Ne plus me demander", style: .default, handler: { _ in
            // Enregistre la préférence de l'utilisateur
            self.boolShowAlert = false
        }))
        
        // Affiche l'alerte depuis le contrôleur de vue
        present(alertController, animated: true)
    }
     
    
    //Fonction permettant la création d'une alerte avec un titre et message personnalisé
    private func showAlert(title: String, msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}




