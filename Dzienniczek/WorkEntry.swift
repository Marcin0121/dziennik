//
//  WorkEntry.swift
//  Dzienniczek
//
//  Created by Marcin Seńko on 2/26/25.
//


import Foundation

struct WorkEntry: Identifiable, Codable {
    let id = UUID()
    var name: String
    var time: String
    var date: Date
}