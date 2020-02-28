//
//  PerformanceScoreController.swift
//  eLiteSIS
//
//  Created by apar on 01/08/19.
//  Copyright © 2019 apar. All rights reserved.
//

import UIKit
import DropDown
import Charts
import MBCircularProgressBar
import CoreData

struct Performance {
    let examtype : String!
    let resultsinpercentage : Int!
    let grading : String!
    let totalMark : Int!
    let obtainedMarks : Int!
    let markdID : String!
    
    init(_ dict:[String:Any]) {
        examtype = dict["examtype"] as? String
        resultsinpercentage = dict["resultInPercentage"] as? Int
        grading = dict["grading"] as? String
        totalMark = dict["totalmarks"] as? Int
        obtainedMarks = (dict["obtainedmarks"] as? Int)!
        markdID = dict["marksID"] as? String
    }
}

struct Score {
    let sis_name : String
    let sis_totalmarks : Int
    let sis_obtainedmarks : Int
    let new_performance : Int
    let new_grade : String
    
    init(_ dict:[String:Any]) {
        if let name = dict["sis_name"] as? String{
            self.sis_name = name
        }else{
            self.sis_name = ""
        }
        let totalMarks = dict["sis_totalmarks"] as? Int
        self.sis_totalmarks = totalMarks!
        let obtainedMarks = dict["sis_obtainedmarks"] as? Int
        self.sis_obtainedmarks = obtainedMarks!
        let performance = dict["new_performance"] as? Int
        self.new_performance = performance!
        if let grade = dict["new_grade"] as? String{
            self.new_grade = grade
        }else{
         self.new_grade = ""
    }
}
}

class PerformanceScoreController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var overallProgress: MBCircularProgressBarView!
    @IBOutlet weak var currentProgress: MBCircularProgressBarView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var PerformanceView: UIView!
    
    
    var marksvalue : String = ""
    var grade : String = ""
    var obtainedMark : String = ""
    var totalMark : String = ""
    var resultpercen : String = ""
    var performnceList = [Performance]()
    var scoreList = [Score]()
    let scoreDropdwon =  DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.scoreDropdwon
            ]
    }()
    
    
    var sum : Double = 0.0
    @IBOutlet weak var segmentcontrol: UISegmentedControl!
    @IBOutlet weak var performancetableview: UITableView!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        Singleton.setUpTableViewDisplay(self.performancetableview, headerView:"PerformanceHeaderView","PerformanceTableViewCell")
        self.performancetableview.delegate = self
        self.performancetableview.dataSource = self
        self.fetchPerformnaceList()
        self.getPerformanceList()
        dropDownButton.layer.cornerRadius = 5
        dropDownButton.layer.borderWidth = 1
        dropDownButton.layer.borderColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func dropDownButton(_ sender: Any) {
       scoreDropdwon.show()
    }

    @IBAction func segmentcontrol(_ sender: Any) {
        
        if segmentcontrol.selectedSegmentIndex == 0 {
            self.PerformanceView.isHidden = false
        }
        else if segmentcontrol.selectedSegmentIndex == 1{
            self.PerformanceView.isHidden = true
        }
    }
    
    //Mark :Line Chart
    func setUpChartViewData() {
        
        lineChartView.delegate = self as? ChartViewDelegate
        
        lineChartView.chartDescription?.enabled = false
        lineChartView.dragEnabled = true
        lineChartView.setScaleEnabled(true)
        lineChartView.pinchZoomEnabled = true
        
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .bottomRight
        llXAxis.valueFont = .systemFont(ofSize: 10)
        
        lineChartView.xAxis.gridLineDashLengths = [10, 10]
        lineChartView.xAxis.gridLineDashPhase = 0
        
        let ll1 = ChartLimitLine(limit: 100, label: "")
        ll1.lineWidth = 2
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .topRight
        ll1.valueFont = .systemFont(ofSize: 10)
        
        let ll2 = ChartLimitLine(limit: 10, label: "")
        ll2.lineWidth = 2
        ll2.lineDashLengths = [5,5]
        ll2.labelPosition = .bottomRight
        ll2.valueFont = .systemFont(ofSize: 10)
        
        let leftAxis = lineChartView.leftAxis
        leftAxis.removeAllLimitLines()
       // leftAxis.addLimitLine(ll1)
       // leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = 100.0
        leftAxis.axisMinimum = 0.0
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        lineChartView.rightAxis.enabled = false
        
   
        //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
        
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = lineChartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        lineChartView.marker = marker
        lineChartView.legend.form = .line
        lineChartView.animate(xAxisDuration: 0)
        self.updateChartData()
    }
    
  func updateChartData() {
    
        self.setDataCount(self.performnceList.count)
    
    }
   
    
    func setDataCount(_ count: Int) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = self.performnceList[i].resultsinpercentage
            return ChartDataEntry(x: Double(i), y: Double(val!), icon:#imageLiteral(resourceName: "Ellipse 126"))
        }
        
        let set1 = LineChartDataSet(entries: values, label:"Performance Chart")
        set1.drawIconsEnabled = false
        
        set1.setColor(#colorLiteral(red: 0.08809600025, green: 0.831815064, blue: 0.664421618, alpha: 1))
        set1.setCircleColor(#colorLiteral(red: 0.08809600025, green: 0.831815064, blue: 0.664421618, alpha: 1))
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formSize = 15
        
        let gradientColors = [ChartColorTemplates.colorFromString("#00ffffff").cgColor,
                              ChartColorTemplates.colorFromString("#ffffffff").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set1.fillAlpha = 1
        set1.fill = Fill(linearGradient: gradient, angle: 90)
        set1.drawFilledEnabled = true
        let data = LineChartData(dataSet:set1)
        lineChartView.data = data
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
        return self.scoreList.count
    }
    if section == 1{
        return 1
    }
    return 0
}
    
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PerformanceHeaderView") as! PerformanceHeaderView
    
        if section == 0{
            viewHeader.backView.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            viewHeader.subjectLabel.text = "Subject"
            viewHeader.obtainedLabel.text = "Obtained"
            viewHeader.totalLabel.text = "Total"
            viewHeader.gradeLabel.text = "Grade"
        }
            
        else if section == 1 {
            viewHeader.backView.backgroundColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
            viewHeader.subjectLabel.text = "Total Marks"
            viewHeader.obtainedLabel.text = obtainedMark
            viewHeader.totalLabel.text = totalMark
            viewHeader.gradeLabel.text = resultpercen + " %"
    }
        return viewHeader
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"PerformanceTableViewCell") as! PerformanceTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name:"Helvetica Neue", size:12)
        cell.subject.textColor = #colorLiteral(red: 0.001235360745, green: 0.1602756083, blue: 0.3412861824, alpha: 1)
        cell.subject.font = .boldSystemFont(ofSize:12)
        if indexPath.section == 0 {
            cell.subject.textAlignment = .left
            cell.subject.text = self.scoreList[indexPath.row].sis_name
            cell.obtained.text = String(self.scoreList[indexPath.row].sis_obtainedmarks)
            cell.total.text = String(self.scoreList[indexPath.row].sis_totalmarks)
            cell.grade.text = self.scoreList[indexPath.row].new_grade
            cell.backview.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        if indexPath.section == 1{
            if indexPath.row == 0{
                cell.subject.text = "Grade : " + self.grade
                cell.subject.textAlignment = .center
                //cell.subject.frame = CGRect(x:0, y: 10, width:cell.frame.width, height:cell.subject.frame.height)
                cell.obtained.text = ""
                cell.total.text = ""
                cell.grade.text = ""
                cell.backview.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.9372549057, blue: 0.9568627477, alpha: 1)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // Mark : Webservice Call
    func getPerformanceList()
    {
        let studentID = UserDefaults.standard.value(forKey:"sis_studentid") as? String ?? ""
        let currentsession = UserDefaults.standard.value(forKey: "_sis_currentclasssession_value") as? String ?? ""
        let sectionValue = UserDefaults.standard.value(forKey:"_sis_section_value") as? String ?? ""
        WebService.shared.getPerformanceList(studentID:studentID, currentclasssession:currentsession, sectionValue:sectionValue,completion:{(response, error) in
            self.performnceList.removeAll()
            if error == nil , let responseDict = response {
              
                if let performanceDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for obj in performanceDict {
                  CoreDataController.sharedInstance.insertAndUpdateStudentPerformance(marksID:(obj["sis_classsessionwisemarksid"] as? String)!, jsonObject:[obj])
                    }
                    self.fetchPerformnaceList()
                }
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching Pinboard data")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    func fetchPerformnaceList() {
        CoreDataController.sharedInstance.fetchStudentPerformanceRequest(completion:{(respose,error) in
            if error == nil , let resposeDict = respose {
                let itemsJsonArray = (Singleton.convertToJSONArray(moArray:resposeDict as! [NSManagedObject])) as? [[String:Any]]
                if itemsJsonArray!.count > 0 {
                    self.performnceList.removeAll()
                    for obj in itemsJsonArray! {
                        let performnace = Performance(obj)
                        self.performnceList.append(performnace)
                        self.setupScoreDropDown()
                        self.performancetableview.reloadData()
                        self.setUpChartViewData()
                    }
                    
                }
            }
        })
     }
    // Mark : Webservice Call
    
    func fetchScore(_ marksValue:String) {
        
        WebService.shared.GetScore(marksID:marksvalue, completion:{(response, error) in
            if error == nil , let responseDict = response {
                ProgressLoader.shared.showLoader(withText:"")
                self.scoreList.removeAll()
                if let scoreDict = responseDict["value"].arrayObject as? [[String:Any]]{
                    for obj in scoreDict {
                        let score = Score(obj)
                        self.scoreList.append(score)
                        self.performancetableview.reloadData()
                        self.performancetableview.isHidden = false
                    }
                }
                
            }else{
                AlertManager.shared.showAlertWith(title: "Error!", message: "while fetching Pinboard data")
            }
            ProgressLoader.shared.hideLoader()
        })
    }
    
    // Mark : DropDown
    func setupScoreDropDown() {
          Singleton.customizeDropDown()
        scoreDropdwon.anchorView = dropDownButton
        let  marksid : [String]
        let obtained : [Int]
        let total : [Int ]
        let grade : [String]
        let result : [Int]
        
        let name = (0..<performnceList.count).map { (i) -> String in
            return performnceList[i].examtype
        }
        marksid = (0..<performnceList.count).map { (i) -> String in
            return performnceList[i].markdID
        }
        grade = (0..<performnceList.count).map { (i) -> String in
            return performnceList[i].grading
        }
        
        obtained = (0..<performnceList.count).map { (i) -> Int in
            return performnceList[i].obtainedMarks
        }
        total = (0..<performnceList.count).map { (i) -> Int in
            return performnceList[i].totalMark
        }
        
        result = (0..<performnceList.count).map { (i) -> Int in
            
            return performnceList[i].resultsinpercentage
        }
        
        sum = (result as NSArray).value(forKeyPath:"@avg.floatValue") as! Double
         self.view.layoutIfNeeded()
        UIView.animate(withDuration:1.0, delay: 0.1, options:.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.overallProgress.value = CGFloat(Int(self.sum))
            self.currentProgress.value = CGFloat(Double(result.last!))
            
        }, completion: { finished in
        })
        
        scoreDropdwon.dataSource = name
        scoreDropdwon.bottomOffset = CGPoint(x: 0, y: dropDownButton.bounds.height)
        
        scoreDropdwon.selectionAction = { [weak self] (index, item) in
            self?.dropDownButton.setTitle("", for: .normal)
            self?.scoreLabel.text = item
            self?.marksvalue = marksid[index]
            self?.obtainedMark = String(obtained[index])
            self?.totalMark = String(total[index])
            self?.grade = grade[index]
            self?.resultpercen = String(result[index])
            self?.fetchScore(self?.marksvalue ?? "")
        }
        
    }
    
  
}



