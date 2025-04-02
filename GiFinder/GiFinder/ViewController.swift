//
//  ViewController.swift
//  GiFinder
//
//  Created by Pierrick Dennemont on 24/03/2025.
//

import UIKit
import Foundation

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var currentTitle: String?
    var images: [String] = []
    var isLoading = false
    var isTotalContent = false
    
    @IBOutlet weak var queryField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clic(_ sender: Any) {
        tableView.setContentOffset(.zero, animated: false)
        currentTitle = queryField.text
        isTotalContent = false
        images = []
        self.tableView.reloadData()
        self.loadGifs()
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            tableView.delegate = self
        }
    
    // TableView load functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
            let imageUrl = images[indexPath.row]
        cell.loadGif(from: imageUrl)
        return cell
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollTrueOffset = scrollView.contentOffset.y + tableView.frame.size.height
        if (scrollView.contentSize.height <= scrollTrueOffset && !isLoading){
            if !isTotalContent{
                self.loadGifs(waitTimeMS: 500)
            }else{
                showAlert(title: "Recherche finie", msg: "Vous avez trouvé tous les résultats pour cette recherche")
            }
        }
    }
    
    // Function to load the gids and append it to the images array
    private func loadGifs(waitTimeMS: Int = 0){
        if(!isLoading){
            // Pour empêcher  qu'il y ait d'autres plusieurs requêtes déclenchées en même temps
            isLoading = true
            print("test")
            Task {
                if  (currentTitle != nil && currentTitle != "") {
                    let tempImage: [String]
                    (tempImage, self.isTotalContent) = await GiphyAPIHandle.shared.call(queryStr: currentTitle!, offset: images.count)
                    self.images.append(contentsOf: tempImage)
                    if(self.images == []){
                        showAlert(title: "Aucun résultat", msg: "Nous n'avons trouvé aucun résultat pour cette recherche")
                    }
                    // Wait Time to have a better experience during the layout reload
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(waitTimeMS)) {
                        self.tableView.reloadData()
                    }
                }else{
                    self.showAlert(title: "Champs vide", msg: "Le champs de texte est vide, veuillez renseigner le style de gif que vous recherchez")
                }
                self.isLoading = false
            }
        }
        
    }
    
    private func showAlert(title: String, msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alertController, animated: true)
    }
}
