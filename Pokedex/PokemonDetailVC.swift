//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Dustin Hullett on 10/18/16.
//  Copyright © 2016 Dustin Hullett. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let img = UIImage(named: "\(pokemon.pokedexId)")
        
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLbl.text = "\(pokemon.pokedexId)"
        
        nameLbl.text = pokemon.name.capitalized
        
        tableView.delegate = self
        tableView.dataSource = self
        

        pokemon.downloadPokemonDetails {
            
            
            
            
            self.tableView.reloadData()
            // whatever we write here will only be called after the network calls are complete
            self.updateUI()
            
            
        }
    }
    
    func updateUI() {
        
        attackLbl.text = pokemon.attack
        weightLbl.text = pokemon.weight
        heightLbl.text = pokemon.height
        defenseLbl.text = pokemon.defense
        typeLbl.text = pokemon.type
        descriptionLbl.text = pokemon.description
        
        if pokemon.nextEvoId == "" {
            
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoId)
            let str = "Next Evolution: \(pokemon.nextEvoName) - LVL - \(pokemon.nextEvoLvl)"
            evoLbl.text = str
        }
    }


    @IBAction func backBtnPressed(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        pokemon.storageid = 1000
        
    }
    
    func displayMoveNames() {
        
    }
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        if segmentOutlet.selectedSegmentIndex == 1 {
            for x in 1...12 {
            self.view.viewWithTag(x)?.isHidden = true
                tableView.isHidden = false
        }
        } else  {
            for y in 1...12 {
                self.view.viewWithTag(y)?.isHidden = false
                tableView.isHidden = true
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "movesCell", for: indexPath) as? movesCell {
            let name = pokemon.movesNameArray[indexPath.row]
            cell.configureCell(name: name)
            return cell
        } else  {
            
            return movesCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.movesNameArray.count
    }
    
    
    
}
    



