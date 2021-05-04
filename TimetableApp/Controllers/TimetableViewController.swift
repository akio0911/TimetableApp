//
//  TimetableViewController.swift
//  TimetableApp
//
//  Created by 大西玲音 on 2021/04/19.
//

import UIKit

final class TimetableViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var weekStackView: UIStackView!
    @IBOutlet private weak var mondayView: NeumorphismView!
    @IBOutlet private weak var tuesdayView: NeumorphismView!
    @IBOutlet private weak var wednesdayView: NeumorphismView!
    @IBOutlet private weak var thursdayView: NeumorphismView!
    @IBOutlet private weak var fridayView: NeumorphismView!
    @IBOutlet private weak var saturdayView: NeumorphismView!
    @IBOutlet private weak var periodStackView: UIStackView!
    @IBOutlet private weak var onePeriodView: NeumorphismView!
    @IBOutlet private weak var twoPeriodView: NeumorphismView!
    @IBOutlet private weak var threePeriodView: NeumorphismView!
    @IBOutlet private weak var fourPeriodView: NeumorphismView!
    @IBOutlet private weak var fivePeriodView: NeumorphismView!
    @IBOutlet private weak var sixPeriodView: NeumorphismView!
    
    private var timetable: Timetable = (weeks: Week.data, periods: Period.data)
    private var horizontalItemCount: Int { timetable.weeks.count }
    private var verticalItemCount: Int { timetable.periods.count }
    private var lectures = [Lecture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TimetableCollectionViewCell.nib,
                                forCellWithReuseIdentifier: TimetableCollectionViewCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let ints = UserDefaults.standard.array(forKey: .saturdayAndSixPeriodKey) as? [Int] {
            configureSaturday(isHidden: ints[0] == 0)
            configureSixPeriod(isHidden: ints[1] == 0)
        }
        
        lectures.removeAll()
        setupTimetable()
        collectionView.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupCollectionView()
        setupWeekAndPeriodViews()
        
    }
    
}

// MARK: - setup
private extension TimetableViewController {
    
    func setupTimetable() {
        for period in timetable.periods {
            for week in timetable.weeks {
                let convert = Convert(week: week, period: period)
                let index = convert.index(timetable: timetable)!
//                lectures.append(Lecture(name: "\(week.rawValue),\(period.rawValue)",
//                                        time: "\(index.convertWeek(timetable: timetable))",
//                                        room: "\(index.convertPeriod(timetable: timetable))"))
                lectures.append(Lecture(name: "", time: "", room: ""))
            }
        }
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let totalItemSize = CGSize(
            width: collectionView.bounds.width - layout.minimumInteritemSpacing * CGFloat(horizontalItemCount - 1),
            height: collectionView.bounds.height - layout.minimumLineSpacing * CGFloat(verticalItemCount - 1)
        )
        layout.itemSize = CGSize(
            width: totalItemSize.width / CGFloat(horizontalItemCount),
            height: totalItemSize.height / CGFloat(verticalItemCount)
        )
        collectionView.collectionViewLayout = layout
    }
    
    func setupWeekAndPeriodViews() {
        mondayView.setupWeekAndPeriodView(Week.monday.rawValue)
        tuesdayView.setupWeekAndPeriodView(Week.tuesday.rawValue)
        wednesdayView.setupWeekAndPeriodView(Week.wednesday.rawValue)
        thursdayView.setupWeekAndPeriodView(Week.thursday.rawValue)
        fridayView.setupWeekAndPeriodView(Week.friday.rawValue)
        saturdayView.setupWeekAndPeriodView(Week.saturday.rawValue)
        onePeriodView.setupWeekAndPeriodView(Period.one.rawValue)
        twoPeriodView.setupWeekAndPeriodView(Period.two.rawValue)
        threePeriodView.setupWeekAndPeriodView(Period.three.rawValue)
        fourPeriodView.setupWeekAndPeriodView(Period.four.rawValue)
        fivePeriodView.setupWeekAndPeriodView(Period.five.rawValue)
        sixPeriodView.setupWeekAndPeriodView(Period.six.rawValue)
    }
    
}

// MARK: - configure timetable
private extension TimetableViewController {
    
    func configureSaturday(isHidden: Bool) {
        timetable.weeks = Week.configureSaturday(weeks: timetable.weeks, isHidden: isHidden) {
            let saturdaySuperView = weekStackView.arrangedSubviews[5]
            saturdaySuperView.isHidden = $0
        }
    }
    
    func configureSixPeriod(isHidden: Bool) {
        timetable.periods = Period.configureSixPeriod(periods: timetable.periods, isHidden: isHidden) {
            let sixPeriodSuperView = periodStackView.arrangedSubviews[5]
            sixPeriodSuperView.isHidden = $0
        }
    }
    
}

// MARK: - setup NeumorphismView
private extension NeumorphismView {
    
    func setupWeekAndPeriodView(_ text: String) {
        self.type = .normal
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.setContentView(label)
        [label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
         label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ].forEach { $0.isActive = true }
    }
    
}

// MARK: - UICollectionViewDelegate
extension TimetableViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension TimetableViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return horizontalItemCount * verticalItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimetableCollectionViewCell.identifier,
                                                      for: indexPath) as! TimetableCollectionViewCell
        cell.delegate = self
        let lecture = lectures[indexPath.row]
        cell.setup(index: indexPath.row, lecture: lecture)
        return cell
    }
    
}

// MARK: - TimetableCollectionViewCellDelegate
extension TimetableViewController: TimetableCollectionViewCellDelegate {
    
    func collectionView(didSelectItemAt index: Int, lecture: Lecture) {
        let settingLectureVC = UIStoryboard.settingLecture.instantiateViewController( 
            identifier: SettingLectureViewController.identifier
        ) as! SettingLectureViewController
        settingLectureVC.modalPresentationStyle = .overCurrentContext
        self.view.layer.opacity = 0.6
        settingLectureVC.backButtonEvent = { self.view.layer.opacity = 1 }
        settingLectureVC.lecture = lecture
        present(settingLectureVC, animated: true, completion: nil)
    }
    
}
