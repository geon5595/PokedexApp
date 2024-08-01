//
//  PokemonCollectionCell.swift
//  PokedexApp
//
//  Created by pc on 8/1/24.
//

import UIKit

class PokemonCell: UICollectionViewCell {
  
  static let id = "PokemonCell"
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 10
    imageView.backgroundColor = .cellBackground
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    imageView.frame = contentView.bounds
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with pokemon: Pokemon) {
    guard let pokemonID = pokemon.url.split(separator: "/").last else { return }
    print(pokemonID)
    let urlString =  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonID).png"
    guard let url = URL(string: urlString) else { return }
    
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self?.imageView.image = image
          }
        }
      }
    }
  }
  
}
