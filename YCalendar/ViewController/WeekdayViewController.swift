//
//  WeekdayViewController.swift
//  YCalendar
//
//  Created by Archie on 2022/7/17.
//

import UIKit

class WeekdayCollectionViewCell: UICollectionViewCell {
    let weekdayLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(weekdayLabel)
        weekdayLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        weekdayLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ weekday: Weekday) {
        weekdayLabel.text = weekday.abbreviation
    }
}

class WeekdayViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource = [Weekday]()
    private let cellReuseIdentifier = "WeekdayCollectionViewCell"
    private var viewWidth: CGFloat = 0 {
        didSet {
            if oldValue != viewWidth {
                collectionView.reloadLayout()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = [.sun, .mon, .tue, .wed, .thur, .fri, .sat]
        
        collectionView.backgroundColor = .clear
        collectionView.register(WeekdayCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewWidth = view.width
    }
}

extension WeekdayViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! WeekdayCollectionViewCell
        cell.update(dataSource[indexPath.row])
        return cell
    }
}

extension WeekdayViewController: UICollectionViewDelegate {
}

extension WeekdayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = viewWidth / 7.0
        let height = 30.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
