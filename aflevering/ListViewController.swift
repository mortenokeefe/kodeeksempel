//
//  ListViewController.swift
//  aflevering
//
//  Created by dmu mac 07 on 20/04/2020.
//  Copyright © 2020 eaaa. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    var stateController: StateController?
    
    @IBOutlet weak var itemTabelView: UITableView! {
        didSet {
            itemTabelView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if stateController == nil {
            stateController = StateController()
        }
        
        stateController?.onComplete = {[weak self] in
            self?.itemTabelView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItem" {
            let destination = segue.destination as? DetailViewController
            stateController?.selectedUserIndex = itemTabelView.indexPathForSelectedRow?.row
            destination?.stateController = stateController
    }
}
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stateController?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath)
        guard let item = stateController?.items?[indexPath.row] else { return cell }
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.description
        if let image = stateController?.imageCache.object(forKey: item.name as NSString) {
            cell.imageView?.image = image
            //Henter billede fra cache for bruger item.name
        } else {
            if let theURL = URL(string: item.owner.avatar_url) {
                    cell.imageView?.load(url: theURL) {[weak self] image in
                        self?.stateController?.imageCache.setObject(image, forKey: item.name as NSString)
                    cell.setNeedsLayout()
                        //Henter billede fra www for bruger item.name og gemmer det i cache
                }
            }
        }
        return cell
    }
    
}
