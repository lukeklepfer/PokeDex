//
//  Constants.swift
//  PokeDex
//
//  Created by Luke on 1/27/16.
//  Copyright © 2016 Luke. All rights reserved.
//

import Foundation

//URLS
let URL_BASE = "http://pokeapi.co"
let URL = "/api/v1/pokemon/"

//closure: block that is called when we want it to be empty with nothing passed it, nothing returned
typealias DownloadComplete = () -> ()