//
//  PokemonDetailVC.swift
//  PokeDex
//
//  Created by Luke on 1/27/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLbl:       UILabel!
    @IBOutlet weak var mainImg:       UIImageView!
    @IBOutlet weak var descLbl:       UILabel!
    @IBOutlet weak var typeLbl:       UILabel!
    @IBOutlet weak var defenceLbl:    UILabel!
    @IBOutlet weak var heightLbl:     UILabel!
    @IBOutlet weak var idLbl:         UILabel!
    @IBOutlet weak var weightLbl:     UILabel!
    @IBOutlet weak var attackLbl:     UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg:    UIImageView!
    @IBOutlet weak var evoLbl:        UILabel!
    @IBOutlet weak var segmentor:     UISegmentedControl!

    
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name.capitalizedString
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        pokemon.downloadPokemonDetails { () -> () in
            //called after download is done
            //print("Download Complete")
            
            self.updateUI()//need self cuz its in a closure
            
        }
    }
    
    func updateUI(){
        
        descLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenceLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        idLbl.text = "\(pokemon.pokedexId)"
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        
        if pokemon.nextEvoId == "" {
            evoLbl.text = "No Evolutions"
            nextEvoImg.hidden = true
        }
        else{
            nextEvoImg.hidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvoId)
            evoLbl.text = pokemon.nextEvo
            
            var str = "Next Evolution: \(pokemon.nextEvoLvl)"
            
            if pokemon.nextEvoLvl != ""{
            
                str += " - LVL \(pokemon.nextEvoLvl)"
            
            }
        }
    }
    
    
    @IBAction func backBtnPressed(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}
