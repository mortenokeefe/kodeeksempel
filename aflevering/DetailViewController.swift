//
//  DetailViewController.swift
//  aflevering
//
//  Created by dmu mac 07 on 22/04/2020.
//  Copyright © 2020 eaaa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
 
//    @IBOutlet weak var txtvDescription: UITextView! {
//        didSet {
//            txtvDescription.isEditable = false
//        }
//    }
//    @IBOutlet weak var txtUrl: UILabel!
//
//    @IBOutlet weak var txtCreatedAt: UILabel!
//
//    @IBOutlet weak var txtUpdatedAt: UILabel!

    @IBOutlet weak var txtvDescription: UITextView!
    
    @IBOutlet weak var txtUrl: UITextField!
    
    @IBOutlet weak var txtCreatedAt: UITextField!
    
    @IBOutlet weak var txtUpdatedAt: UITextField!
    
    
    @IBOutlet weak var switchFavorite: UISwitch!
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        //check om switch er sat og repoet skal gemems i favorites
        if let index = stateController?.selectedUserIndex {
            if switchFavorite.isOn {
                stateController?.setAsFavorite(id: index)
            }
            else {
                stateController?.removeAsFavorite(id: index)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    

    var stateController: StateController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let stateController = stateController, let index = stateController.selectedUserIndex, let item = stateController.items?[index] {
            
            self.title = item.name
            
            txtvDescription.text = item.description
            txtUrl.text = item.url
            
            //laver dansk dato formattering
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            dateFormatter.locale = Locale(identifier: "da_DK")
            
            txtCreatedAt.text = dateFormatter.string(from: item.created_at)
            
            txtUpdatedAt.text = dateFormatter.string(from: item.updated_at)
                        
            if let index = stateController.selectedUserIndex {
                switchFavorite.isOn = stateController.isFavorite(id: index)
            }
        }
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
