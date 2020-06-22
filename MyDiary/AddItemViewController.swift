//
//  addItemViewController.swift
//  MyDiary
//
//  Created by Apple on 6/17/20.
//  Copyright © 2020 Minh Thang. All rights reserved.
//

import UIKit
import CoreData

class AddItemViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    
    @IBAction func btn_Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_Add(_ sender: Any) {
        if textView.text.isEmpty {
            let alert = UIAlertController(title: "Please Type Anything", message: "Your entry is empty", preferredStyle: UIAlertController.Style.alert)
            let btnOK = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(btnOK)
            present(alert, animated: true, completion: nil)
            }
        else {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/dd/YY"
            let currentDate = formatter.string(from: date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            let currentTime = timeFormatter.string(from: date)
            
            let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDel.persistentContainer.viewContext
            let newEntry = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context)
            newEntry.setValue(textView.text!, forKey: "entry")
            newEntry.setValue(currentDate, forKey: "date")
            newEntry.setValue(currentTime, forKey: "time")
            do {
                try context.save()
                dismiss(animated: true, completion: nil)
                
            } catch {
                print("Error")
            }
            
            }
    }
    override func viewDidLoad() {
        textView.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //func textViewDidBeginEditing(_ textView: UITextView) {
        //textView.text = ""
        //textView.textColor = UIColor.black
    //}
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
