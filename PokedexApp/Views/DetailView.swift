//
//  detailView.swift
//  PokedexApp
//
//  Created by pc on 8/2/24.
//

import UIKit
import SnapKit

class DetailView: UIView {
  private let pokemonImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  private let pokemonName: UILabel = {
    let Label = UILabel()
    Label.font = UIFont.boldSystemFont(ofSize: 30)
    Label.textColor = .white
    return Label
  }()
  private let pokemonType: UILabel = {
    let Label = UILabel()
    return Label
  }()
  private let pokemonHeight: UILabel = {
    let Label = UILabel()
    return Label
  }()
  private let pokemonWeight: UILabel = {
    let Label = UILabel()
    return Label
  }()

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureUI() {
    self.backgroundColor = .darkRed
    [
      pokemonImageView,
      pokemonName,
      pokemonType,
      pokemonHeight,
      pokemonWeight
    ].forEach { self.addSubview($0) }
    [
      pokemonType,
      pokemonHeight,
      pokemonWeight
    ].forEach {
      $0.font = UIFont.boldSystemFont(ofSize: 18)
      $0.textColor = .white
    }

    pokemonImageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(30)
      $0.centerX.equalToSuperview()
      $0.width.height.equalTo(200)
    }
    
    pokemonName.snp.makeConstraints {
      $0.top.equalTo(pokemonImageView.snp.bottom).offset(5)
      $0.centerX.equalToSuperview()

    }
    pokemonType.snp.makeConstraints {
      $0.top.equalTo(pokemonName.snp.bottom).offset(15)
      $0.centerX.equalToSuperview()

    }
    pokemonHeight.snp.makeConstraints {
      $0.top.equalTo(pokemonType.snp.bottom).offset(15)
      $0.centerX.equalToSuperview()

    }
    pokemonWeight.snp.makeConstraints {
      $0.top.equalTo(pokemonHeight.snp.bottom).offset(15)
      $0.centerX.equalToSuperview()

    }
  }

  func setPokemonImageView(_ image: UIImage) {
    pokemonImageView.image = image
  }
  
  func setPokemonName(_ pokemonNumber: Int, _ name: String) {
    pokemonName.text = "No.\(String(pokemonNumber + 1)) \(name)"
  }
  
  func setPokemonType(_ type: String) {
    pokemonType.text = "타입: \(type)"
  }
  
  func setPokemonHeight(_ height: Double) {
    pokemonHeight.text = "키: \(String(height)) m"
  }
  
  func setPokemonWeight(_ weight: Double) {
    pokemonWeight.text = "몸무게: \(String(weight)) kg"
  }
  
}
