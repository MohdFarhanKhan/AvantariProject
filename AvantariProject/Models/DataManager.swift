//
//  DataManager.swift
//  AvantariProject
//
//  Created by Mohd Farhan Khan on 5/14/18.
//  Copyright © 2018 Mohd Farhan Khan. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class DataManager{
    static let sharedInstance = DataManager()
    var dataArray : [AvantariRecords] = []
    init(){
        getData()
    }
    func getData(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        DispatchQueue.main.async{
            do{
                let managedContext = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<AvantariRecords>(entityName: "AvantariRecords")
                let sortDescriptor = NSSortDescriptor(key: "dataTime", ascending: true)
                let sortDescriptors = [sortDescriptor]
                request.sortDescriptors = sortDescriptors
                let results = try managedContext.fetch(request)
                if results.count > 0{
                     self.dataArray.removeAll()
                    if results.count > 10{
                        let fromIndex = results.count - 10
                        let toIndex = results.count-1
                        for i in 0...(fromIndex-1){
                            managedContext.delete(results[i])
                        }
                      try  managedContext.save()
                        for i in fromIndex...(toIndex){
                            self.dataArray.append(results[i])
                          
                        }
                    }
                    else{
                       
                        self.dataArray = results
                    }
                   
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dataChange"), object: nil, userInfo: nil)
                }
               
            }
            catch{
                print("Error")
            }
        }
    }
    private func isNumberFound(number: Int)->Bool{
       
       let savedNumber = dataArray.last?.dataNumber
        if savedNumber == Int32(number){
            return true
        }
        else{
            return false
        }
    }
    func addNumber(number : Int){
        if isNumberFound(number: number) == true{
           LocalNotification.sharedInstance.setNotification(number: number)
        }
        else{
           addNumberToDatabase(number: number)
            getData()
        }
    }
   private func addNumberToDatabase(number: Int){
        let dateTime = Date()
        let numberToSave = number
        var colorToSave : UIColor?
        switch number {
        case 0,1,2,3,4,5,6,7:
            colorToSave = UIColor.black
        case 8:
            colorToSave = UIColor.cyan
            
        default:
            colorToSave = UIColor.red
            
        }
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    let entity = NSEntityDescription.entity(forEntityName: "AvantariRecords",
                                            in: managedContext)!
    let locationManagedObject = AvantariRecords(entity: entity, insertInto: managedContext)
    locationManagedObject.dataTime = dateTime as NSDate
    locationManagedObject.dataNumber = Int32(numberToSave)
    locationManagedObject.dataColor = colorToSave
    try! managedContext.save()
    }
   
    
}
