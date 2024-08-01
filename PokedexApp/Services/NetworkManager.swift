//
//  NetworkManager.swift
//  PokedexApp
//
//  Created by pc on 8/1/24.
//

import Foundation
import RxSwift
import Alamofire

enum NetworkError: Error{
  case invalidUrl
  case dataFetchFail
  case decodingFail
}

class NetworkManager {
  static let shared = NetworkManager()
  private init() {}
  
  func fetch<T: Decodable>(url: URL) -> Single<T> {
    return Single.create { observer in
      AF.request(url)
        .validate()
        .responseData { response in
          switch response.result {
          case .success(let data):
            do {
              let decodedData = try JSONDecoder().decode(T.self, from: data)
              observer(.success(decodedData))
            } catch {
              observer(.failure(NetworkError.decodingFail))
            }
          case .failure:
            observer(.failure(NetworkError.dataFetchFail))
          }
        }
      return Disposables.create()
    }
  }
}

