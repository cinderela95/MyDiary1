//
//  updateItemViewController.swift
//  MyDiary
//
//  Created by Apple on 6/18/20.
//  Copyright © 2020 Minh Thang. All rights reserved.
//

import UIKit
import CoreData

class updateItemViewController: UIViewController, UITextViewDelegate {
    var item:Item!
    
    @IBOutlet weak var textView: UITextView!
    @IBAction func btn_Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func btn_Update(_ sender: Any) {
        guard let updateEntry = textView.text else {
            return
        }
        item.entry = updateEntry
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        do {
            try context.save()
        } catch {}
        
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        loadData(entry: item)
        textView.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func loadData(entry: Item) {
        guard let text = entry.entry else {
            return
        }
        textView.text = text
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
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
