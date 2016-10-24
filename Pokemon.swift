//
//  Pokemon.swift
//  PokeDex
//
//  Created by Luke on 1/26/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    private var _name:        String!
    private var _pokedexId:   Int!
    private var _description: String!
    private var _type:        String!
    private var _defense:     String!
    private var _height:      String!
    private var _weight:      String!
    private var _attack:      String!
    private var _nextEvo:     String!
    private var _nextEvoId:   String!
    private var _pokemonUrl:  String!
    private var _nextEvoLvl:  String!
    
    
    var name: String{
        return _name
    }
    var pokedexId: Int{
        return _pokedexId
    }
    
    var description: String{
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var type: String{
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    var height: String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    var nextEvo: String{
        if _nextEvo == nil{
            _nextEvo = ""
        }
        return _nextEvo
    }
    var nextEvoId: String{
        if _nextEvoId == nil{
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    var nextEvoLvl: String{
        if _nextEvoLvl == nil{
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        _pokemonUrl = "\(URL_BASE)\(URL)\(self._pokedexId)/"
        
    }
    
    
    //af networking in obj c
    func downloadPokemonDetails(completed: DownloadComplete){
        //must call completed at the end
        
        let url = NSURL(string: _pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON{ (response) -> Void in
            
            //print(response.result) //SUCCESS
            
            if let JSON = response.result.value {
                
                //print("JSON: \(JSON)") //prints the value of the result
                
                if let dict = response.result.value as? Dictionary<String, AnyObject> {
                    
                    if let weight = dict["weight"] as? String { //string in "" needs to match the json keys
                     
                        self._weight = weight
                        
                    }
                    if let height = dict["height"] as? String {
                        
                        self._height = height
                        
                    }
                    if let attack = dict["attack"] as? Int {
                        
                        self._attack = "\(attack)"
                        
                    }
                    if let defense = dict["defense"] as? Int {
                        
                        self._defense = "\(defense)"
                        
                    }
                    if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0{
                        
                        if let name = types[0]["name"]{
                         
                            self._type = name.capitalizedString
                            
                        }
                        if types.count > 1{
                            for var x = 1; x < types.count; x++ {
                                if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalizedString)"
                                    
                                }
                            }
                        }
                    }
                    else {
                        //no types
                        self._type = ""
                    }
                    if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                        
                        if let url = descArr[0]["resource_uri"]{
                            let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                            
                            Alamofire.request(.GET, nsurl).responseJSON { response in
                                let desResult = response.result
                                if let descDect = desResult.value as? Dictionary<String, AnyObject>{
                                    
                                   if let description = descDect["description"] as? String{
                                            self._description = description
                                        //print(self._description)
                                    }
                                }
                                completed()
                            }
                        }
                    }
                    else {
                        self._description = ""
                    }
                    
                    if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0{
                        
                        if let to = evolutions[0]["to"] as? String {
                            
                            if to.rangeOfString("mega") == nil{
                                
                                if let uri = evolutions[0]["resource_uri"] as? String{
                                    
                                    let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                    let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                    //remove the url around our id number
                                    self._nextEvo = to
                                    self._nextEvoId = num
                                    
                                    if let level = evolutions[0]["level"] as? Int{
                                        
                                        self._nextEvoLvl = "\(level)"
                                        //print(self.nextEvoLvl)
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}