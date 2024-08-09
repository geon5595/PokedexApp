//
//  PokemonCollectionCell.swift
//  PokedexApp
//
//  Created by pc on 8/1/24.
//

import UIKit
import Kingfisher

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
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
  
  func configure(with pokemon: Pokemon) {
    guard let pokemonID = pokemon.url.split(separator: "/").last else { return }
    let urlString =  "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonID).png"
    guard let url = URL(string: urlString) else { return }
    
    imageView.kf.setImage(with: url)
  }
  
}
