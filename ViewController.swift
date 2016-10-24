//
//  ViewController.swift
//  PokeDex
//
//  Created by Luke on 1/26/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var inSearchMode = false
    var filteredPokemon = [Pokemon]()
    
    var musicPlayer: AVAudioPlayer!
    var pokemans = [Pokemon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.Done //makes "Return" in the keyboard say "Done"
        
        parsePokemonCvs()
        initAudio()
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)//hide keyboard
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //every key stroke
        
        if searchBar.text == nil || searchBar.text == ""{
        
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
            
        }else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredPokemon = pokemans.filter({$0.name.rangeOfString(lower) != nil})//grab the name of object "$0" check if this string exists in it
            collection.reloadData()
        }
        
    }
    
    func initAudio(){
        let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //infinite
            musicPlayer.play()
            
        }catch let err as NSError{
            print(err.debugDescription)
        }
        
    }
    
    @IBAction func musicBtnPressed(sender: UIButton) {
        
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2
        }
        else{
            sender.alpha = 1.0
            musicPlayer.play()
        }
        
        
    }
    
    func parsePokemonCvs(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            for row in rows{
            
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemans.append(poke)
                
            }
        }catch let err as NSError{
            print(err.debugDescription)
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell{
            
            let poke: Pokemon!
            
            if inSearchMode {
                
                poke = filteredPokemon[indexPath.row]
                
            }
            else{
                 poke = pokemans[indexPath.row]
            }

            cell.configureCell(poke)
            return cell
        }
            
        else{
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //make sure you dont use deselect!!
        
        let poke: Pokemon!
        
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
        }
        else{
            poke = pokemans[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filteredPokemon.count
        }
        
        return pokemans.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PokemonDetailVC"{
            
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC{
              
                if let poke = sender as? Pokemon{
                    detailsVC.pokemon = poke //holds "poke" in detailsVC in var "pokemon" from that view
                }
            }
        }
    }
    
    
}

