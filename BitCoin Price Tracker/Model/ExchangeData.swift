//
//  ExchangeData.swift
//  BitCoin Price Tracker
//
//  Created by Adeeb K on 17/12/24.
//

import Foundation

struct ExchangeData: Decodable {
    let time: String
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Double
}
