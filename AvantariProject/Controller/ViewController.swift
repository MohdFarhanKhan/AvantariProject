//
//  ViewController.swift
//  AvantariProject
//
//  Created by Mohd Farhan Khan on 5/14/18.
//  Copyright © 2018 Mohd Farhan Khan. All rights reserved.
//

import UIKit
import SocketIO
import Charts
class ViewController: UIViewController {
    @IBOutlet weak var lineChartView: LineChartView!
    
    let manager = SocketManager(socketURL: URL(string: "http://ios-test.us-east-1.elasticbeanstalk.com/")!)
    var socket: SocketIOClient!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       NotificationCenter.default.addObserver(self, selector: #selector(ViewController.dataChange), name: NSNotification.Name(rawValue: "dataChange"), object: nil)
       DataManager.sharedInstance.getData()
       socket = manager.socket(forNamespace: "/random")
       socket.connect()
       
       socket.once(clientEvent: .connect) {  (data, ack)  in
          
           self.socket.on("capture") { (data, ack) in
               let numArray = data as! [Int]
               if numArray.count > 0{
                   let number = numArray[0]
                   if number >= 0 && number <= 9{
                       print(number)
                        DataManager.sharedInstance.addNumber(number: number)
                   }
               }
              
           }
           
       }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        socket.disconnect()
    }
    @objc func dataChange()
    {
        var timeArray = [String]()
        var colorArray = [UIColor]()
        var numberArray = [Double]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
       
        for record in DataManager.sharedInstance.dataArray{
            numberArray.append(Double(record.dataNumber))
            colorArray.append(record.dataColor as! UIColor)
            timeArray.append(dateFormatter.string(from: record.dataTime! as Date))
            
        }       
      
      setChart(dataPoints: timeArray, values: numberArray, colors: colorArray)
        
    }
    func setChart(dataPoints: [String], values: [Double], colors: [UIColor]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i+1), y: values[i])
            
            dataEntries.append(dataEntry)
        }
               
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Number of random numbers stored: \(dataEntries.count)")
        lineChartDataSet.mode = .cubicBezier
        
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawIconsEnabled = false
        lineChartDataSet.colors = colors
       
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        lineChartView.xAxis.labelWidth = 1
        lineChartView.data = lineChartData
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5, easingOption: .easeInBounce)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

