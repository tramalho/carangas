//
//  CarsTableViewController.swift
//  Carangas
//
//  Created by Eric Brito on 21/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class CarsTableViewController: UITableViewController {

    private var cars: [Car] = []
    
    private lazy var label: UILabel = {
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(named: "main")
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCars()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = cars.count == 0 ? label : nil
        return cars.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let car = cars[indexPath.row]
        cell.textLabel?.text = car.name
        cell.detailTextLabel?.text = car.brand
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSegue", let vc = segue.destination as? CarViewController {
            if let row = tableView.indexPathForSelectedRow?.row {
                vc.car = cars[row]
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let car = cars[indexPath.row]
            
            Rest.delete(car: car) { (success) in
                if success {
                    self.cars.remove(at: indexPath.row)
                    
                    DispatchQueue.main.async {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
 
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */


    private func loadCars() {
        label.text = "Carregando carros..."

        Rest.loadCars(onComplete: { (cars:[Car]) in
            
            self.cars = cars
            DispatchQueue.main.async {
                self.label.text = "Não existem carros cadastrados"
                self.tableView.reloadData()
            }
            
        }) { (error) in
            DispatchQueue.main.async {
                self.label.text = "Erro ao consultar dados!"
            }
            print(error)
        }
    }
}
