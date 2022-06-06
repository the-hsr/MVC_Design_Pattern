//
//  ViewController.swift
//  Learning
//
//  Created by Himanshu Singh on 04/06/22.
//

// MARK: This is a view and controller model is named with DataModel.swift where we define what type of data needs to be stored

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data = [DataModel]()
    override func viewDidLoad() {
        /* tableView.delegate = self
           tableView.dataSource = self can also be done from here to attach to the ViewController
        */
         super.viewDidLoad()
        // Do any additional setup after loading the view.
        callAPI{
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: fetch api function below with completion handler to update the table view along with it.
    
    func callAPI(completed: @escaping () -> ()){
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            guard error == nil else{
                print("error: \(String(describing: error))")
                return
            }
            
            do{
                self.data = try JSONDecoder().decode([DataModel].self, from: data!)
                DispatchQueue.main.async {
                    completed()
                }
            }catch{
                print("Json error")
            }
        }.resume()
    }


}

// MARK: extension for the tableView delegate and dataSource to be conformed. tableView.delegate = self and tableView.dataSource = self is associated in storyboard.

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(data[indexPath.row].id ?? 0)
        cell.detailTextLabel?.text = data[indexPath.row].body
        
        return cell
    }
}

