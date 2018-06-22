//
//  PokemonViewController.swift
//  Pokedex
//
//  Created by Karson Chau on 2018-06-15.
//  Copyright © 2018 Karson Chau. All rights reserved.
//

import UIKit

struct Pokemon:Decodable {
    let name:String?
    let height:Int?
    let weight:Int?
    let sprites:Sprites?
    let moves:[Moves]?
    let types:[Types]?
    let stats:[Stats]?
    
    struct Sprites:Decodable {
        let front_default:String?
        let front_shiny:String?
    }
    struct Moves:Decodable {
        let move:Move?
        struct Move:Decodable {
            let name:String?
        }
    }
    struct Types:Decodable {
        let slot:Int?
        let type:Type?
        struct `Type`:Decodable {
            let name:String?
        }
    }
    
    
    struct Stats: Decodable {
        let stat:Stat?
        let base_stat:Int?
        struct Stat:Decodable {
            let name:String?
        }
    }
    
}

class PokemonViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var type: UILabel!
    
    @IBOutlet weak var attack: UILabel!
    @IBOutlet weak var specialAttack: UILabel!
    @IBOutlet weak var defense: UILabel!
    @IBOutlet weak var specialDefense: UILabel!
    @IBOutlet weak var hp: UILabel!
    
    @IBOutlet weak var movesTextView: UITextView!
    
    var id:Int = -1
    
    var pokemon:Pokemon = Pokemon(name: "nil", height: -1, weight: -1,sprites: nil, moves:nil,types: nil, stats:nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add loading screen
        if id > 1 && id <= 151 {            
            getPokemonData()
            //remove loading screen
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPokemonData() {
        let urlString = "https://pokeapi.co/api/v2/pokemon/" + String(self.id)
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {return}
            do {
                self.pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                
                print(self.pokemon)
                
                DispatchQueue.main.async { // Correct
                    self.setPokemonData()
                }
                
            } catch {
                print("Json Error")
            }
            
            
        }.resume()
    }
    
    func setPokemonData() {
        
        guard let url = URL(string: (self.pokemon.sprites?.front_default)!) else {return}
        
        self.image.downloadedFrom(url: url)
        
        self.image.contentMode = .scaleAspectFit
        
        self.name.text = String(self.id) + " " + (self.pokemon.name?.uppercased())!
        
        self.height.adjustsFontSizeToFitWidth = true
        self.height.minimumScaleFactor = 0.2
        self.height.text = "HEIGHT: " + String(self.pokemon.height!) + "m"
        
        self.weight.adjustsFontSizeToFitWidth = true
        self.weight.minimumScaleFactor = 0.2
        self.weight.text = "WEIGHT: " + String(self.pokemon.weight!) + "kg"
        
        var fullType:String = "TYPE: "
        for type in self.pokemon.types! {
            if type.slot == 2 {
                
                fullType += (type.type?.name)!
                fullType += "/"
            }
            else {
                fullType += (type.type?.name)!
            }
        }
        self.type.adjustsFontSizeToFitWidth = true
        self.type.minimumScaleFactor = 0.2        
        self.type.text = fullType.uppercased()
        
        setPokemonStats()
        setPokemonMoves()
    }
    
    func setPokemonStats() {
        for stats in self.pokemon.stats! {
            let stat = String(stats.base_stat!)
            switch stats.stat?.name! {
                case "special-defense":
                    self.specialDefense.text = "SPECIAL DEFENSE: " + stat
                case "defense":
                    self.defense.text = "DEFENSE: " + stat
                case "special-attack":
                    self.specialAttack.text = "SPECIAL ATTACK: " + stat
                case "attack":
                    self.attack.text = "ATTACK: " + stat
                case "hp":
                    self.hp.text = "HP: " + stat
                default:
                    print("no stats")
            }
        }
    }
    
    func setPokemonMoves() {
        for moves in self.pokemon.moves! {
            let name = moves.move?.name!.uppercased()
            
             let n = name?.replacingOccurrences(of: "-", with: " ")
            self.movesTextView.text! += n!
            self.movesTextView.text! += "\n"
        }
        
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
