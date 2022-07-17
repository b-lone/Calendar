//
//  MonthViewController.swift
//  YCalendar
//
//  Created by Archie on 2022/7/17.
//

import UIKit

class MonthViewController: UIViewController {
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellReuseIdentifier = "MonthCollectionViewCell"
    let dataSource: MonthDataSource
    
    init(byAdding monthOffset: Int) {
        self.dataSource = MonthDataSource(byAdding: monthOffset)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinit:\(dataSource.month) \(dataSource.year)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .randomColor
        
        monthLabel.text = dataSource.month.abbreviation
        yearLabel.text = "\(dataSource.year)"
        
        collectionView.backgroundColor = .clear
        collectionView.register(UINib (nibName: cellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    func update() {
        view.layoutIfNeeded()
        let cellHeight = view.width / 7.0
        let collectionViewHeight = CGFloat((dataSource.days.count + 6) / 7) * cellHeight
        collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight).isActive = true
    }
}

extension MonthViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! MonthCollectionViewCell
        cell.update(dataSource.days[indexPath.row])
        return cell
    }
}

extension MonthViewController: UICollectionViewDelegate {
}

extension MonthViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.width / 7.0
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
