//
//  ViewController.swift
//  PokedexApp
//
//  Created by pc on 8/1/24.
//

import UIKit
import RxSwift
import SnapKit

class MainViewController: UIViewController {

  private let disposeBag = DisposeBag()
  private let mainViewModel = MainViewModel()
  private let detailViewModel = DetailViewModel()
  private var pokemon = [Pokemon]()
  
  private let pokeballImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Pokeball")
    imageView.layer.cornerRadius = 10
    imageView.clipsToBounds = true
    return imageView
  }()
  
  private lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.id)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .darkRed
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .mainRed
    configureUI()
    bind()
    
  }
  
  private func bind() {
    mainViewModel.pokemonSubject
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] pokemons in
        self?.pokemon = pokemons
        self?.collectionView.reloadData()
      }, onError: { error in
        print("error")
      }).disposed(by: disposeBag)
  }
  
  private func configureUI() {
    [
      pokeballImage,
      collectionView
    ].forEach { view.addSubview($0) }
    
    pokeballImage.snp.makeConstraints {
      $0.top.equalToSuperview().inset(80)
      $0.centerX.equalToSuperview()
      $0.height.width.equalTo(100)
    }
    
    collectionView.snp.makeConstraints {
      $0.top.equalTo(pokeballImage.snp.bottom).offset(20)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalToSuperview().inset(50)
    }
  }
}

extension UIColor {
  static let mainRed = UIColor(red: 190/255, green: 30/255, blue: 40/255, alpha: 1.0)
  static let darkRed = UIColor(red: 120/255, green: 30/255, blue: 30/255, alpha: 1.0)
  static let cellBackground = UIColor(red: 245/255, green: 245/255, blue: 235/255, alpha: 1.0)
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.navigationController?.pushViewController(DetailViewController(), animated: true)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.id, for: indexPath) as? PokemonCell else {
      return UICollectionViewCell()
    }
    cell.configure(with: pokemon[indexPath.row])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return pokemon.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.width - 40) / 3
    let size = CGSize(width: width, height: width)
    return size
  }
}
