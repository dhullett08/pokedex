//
//  Pokemon.swift
//  Pokedex
//
//  Created by Dustin Hullett on 10/18/16.
//  Copyright © 2016 Dustin Hullett. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _pokemonURL: String!
    private var _nextEvoName: String!
    private var _nextEvoId: String!
    private var _nextEvoLvl: String!
    private var _movesNameArray: [String]!
    var storageid: Int!
    
    
    //Start of getters and setters//
    
    var movesNameArray: [String] {
        if _movesNameArray == nil {
            _movesNameArray = []
        }
        return _movesNameArray
    }
    
    var nextEvoName: String {
        if _nextEvoName == nil {
            _nextEvoName = ""
        }
        return _nextEvoName
    }
    
    var nextEvoId: String {
        if _nextEvoId == nil {
            _nextEvoId = ""
        }
        return _nextEvoId
    }
    
    var nextEvoLvl: String {
        if _nextEvoLvl == nil {
            _nextEvoLvl = ""
        }
        return _nextEvoLvl
    }
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        return _nextEvolutionTxt
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var weight: String {
        if _weight == nil {
            _weight = "'"
        }
        return _weight
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    //End of getters and setters//
    
    var name: String {
        
        return _name
    }
    
    var pokedexId: Int {
        
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        
        self._name = name
        self._pokedexId = pokedexId
        storageid = 0
        
        
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(pokedexId)/"
        
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonURL).responseJSON { (response) in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
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
                
                if let types = dict["types"] as? [Dictionary<String, String>] , types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                    
                } else {
                    
                    self._type = ""
                }
                
                if let movesArr = dict["moves"] as? [Dictionary<String, AnyObject>] , movesArr.count > 0{
                    if let moveName = movesArr[0]["name"] {
                        
                        self._movesNameArray = ["\(moveName)"]
                        
                    }

                    if movesArr.count > 1 {
                        
            // Need to implement clearing the Array when back is pressed to stop the fatal error of index out of range//
                        
                        for y in 1..<movesArr.count {
                            
                            if self.storageid != 1000 {
                                
                            if let moveName = movesArr[y]["name"] {
                                
                                self._movesNameArray.append ("\(moveName)")
                                
                                
                                
                                
                            } else {
                                self._movesNameArray = [""]
                                
                            }
                                
                            } else  {
                                self._movesNameArray = [""]
                            
                        }
                    }
                        print("This is a new line for printing" + "\(self._movesNameArray)")
                }
                
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] , descArr.count > 0 {
                    
                    if let url = descArr[0]["resource_uri"] {
                        
                        let descURL = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descURL).responseJSON(completionHandler: { (response) in
                            
                            if let descDict = response.result.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    
                                    let newdescription = description.replacingOccurrences(of: "POKMON", with: "Pokemon")
                                    self._description = newdescription
                                    print(newdescription)
                                }
                            }
                            
                            completed()
                        })
                        
                    }
                } else {
                    
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] , evolutions.count > 0 {
                    
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        
                        if nextEvolution.range(of: "mega") == nil {
                            self._nextEvoName = nextEvolution
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon/", with: "")
                                
                                let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                                self._nextEvoId = nextEvoId
                                
                                if let lvlExists = evolutions[0]["level"] {
                                    
                                    if let lvl = lvlExists as? Int {
                                        
                                        self._nextEvoLvl = "\(lvl)"
                                    }
                                    
                                } else {
                                    
                                    self._nextEvoLvl = ""
                                }
                            }
                            
                        }
                        
                    }
                }
                
            }
            completed()
        }
    }
}
}
