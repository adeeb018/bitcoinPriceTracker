//
//  CoinManager.swift
//  BitCoin Price Tracker
//
//  Created by Adeeb K on 16/12/24.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coinData: ExchangeData)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    
    let apiKey = "DDCCB299-D557-497B-AC04-015200ED04E5"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        // create URL
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // Create URL
        if let url = URL(string: urlString) {
            // Create URL session
            let session = URLSession(configuration: .default)
            // Give the session a task
            let task = session.dataTask(with: url) { data, URLResponse, error in
                if error != nil {
                }
                if let safeData = data {
                    if let priceData = self.parseJson(coinData: safeData){
                        print("the rate of your coin \(priceData.asset_id_quote) in bitcoin is \(priceData.rate)")
                        self.delegate?.didUpdateCoin(self, coinData: priceData)
                    }
                    
                }
            }
            // start the task
            task.resume()
        }
    }
    
    func parseJson(coinData: Data) -> ExchangeData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(ExchangeData.self, from: coinData)
            return decodedData
        } catch {
            print(error)
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
