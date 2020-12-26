//
//  AddEditViewController.swift
//  Carangas
//
//  Created by Eric Brito.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfBrand: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfPrice: UITextField!
    @IBOutlet weak var scGasType: UISegmentedControl!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!

    // MARK: - Properties
    var car: Car!
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        
        if car == nil {
            car = Car()
        }
        
        if let name = tfName.text {
            car.name = name
        }
        
        if let brand = tfBrand.text {
            car.brand = brand
        }
        
        if let price = tfPrice.text, !price.isEmpty {
            car.price = Double(price)
        } else {
            car.price = Double("0")
        }
        
        car.gasType = scGasType.selectedSegmentIndex
        
        Rest.save(car: car) { (result) in
            self.goBack()
        }
    }

    // MARK: - Methods
    private func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
