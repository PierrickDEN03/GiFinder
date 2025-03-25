//
//  ViewController.swift
//  GiFinder
//
//  Created by Pierrick Dennemont on 24/03/2025.
//

import UIKit
import Foundation

class ViewController: UIViewController,UITableViewDataSource {
    let cle_api = "2f5FBLcJV7y3LhnqWcg97Sd67UtwhSie"
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func clic(_ sender: Any) {

        var components = URLComponents(string: "https://api.giphy.com/v1/gifs/trending")
            components?.queryItems = [
                URLQueryItem(name: "api_key", value: cle_api),
                URLQueryItem(name: "limit", value: "10")
            ]

                guard let url = components?.url else {
                print("URL invalide")
                return
            }
        
        
        let task = URLSession.shared.dataTask(with: url) { data,response,error in
            //Vérification des erreurs
            if let error = error {
                print("Erreur de la requete : \(error)")
                return
            }
            //Vérification du statut de la reqûete
            if let httpResponse = response as? HTTPURLResponse {
                print ("Code de statut : \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200  {
                    print ("Erreur : Statut de réponse inattendu")
                    return
                }
            }
            //Stockage des données
            if let data = data {
                //let responseString = String(data: data, encoding: .utf8)
                //print("Réponse: \(responseString ?? "Rien")")
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let dataObject = json["data"] as? [Any] {
                            if let firstData = dataObject[0] as? [String: [String: Any]]{
                                if let url = firstData["images"]!["url"] as? String {
                                    print("Données JSON : \(url)")
                                }
                            }
                        }else{
                            print("error images")
                        }
                    } else {
                        print("Le format JSON est incorrect")
                    }
                } catch {
                    print("Erreur de parsing JSON : \(error.localizedDescription)")
                }
            }
        }
        //Appel de la requête
        task.resume()
        
    }
    
    let images = [
                  "https://media1.giphy.com/media/cZ7rmKfFYOvYI/200_d.gif",
                  "https://media.giphy.com/media/5xtDarmOIekHPQSZEpq/giphy.gif",
                  "3.gif",
                  "https://media.giphy.com/media/3oEjHM2xehrp0lv6bC/giphy.gif",
                  "5.gif",
                  "https://media.giphy.com/media/l1J9qg0MqSZcQTuGk/giphy.gif",
                  "4.gif",
    ]

    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.dataSource = self
            
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
            let imageUrl = images[indexPath.row]
        cell.loadGif(from: imageUrl)
        return cell
    }

    
    
    
}

