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
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private var brands:[Brand] = []
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let car = car {
            tfBrand.text = car.brand
            tfName.text = car.name
            tfPrice.text = "\(String(describing: car.price))"
            scGasType.selectedSegmentIndex = car.gasType
            btAddEdit.setTitle("Alterar", for: .normal)
        } else {
            car = Car()
        }
        
        setupPickerView()
    }
    
    // MARK: - IBActions
    @IBAction func addEdit(_ sender: UIButton) {
        
        sender.isEnabled = false
        sender.backgroundColor = .gray
        sender.alpha = 0.5
        loading.startAnimating()
        
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
    private func setupPickerView() {
        pickerView.backgroundColor = .white
        let canncelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "main")
        toolbar.items = [canncelButton, flexButton, doneButton]
        
        tfBrand.inputView = pickerView
        
        tfBrand.inputAccessoryView = toolbar
        
        loadBrands()
    }
    
    private func loadBrands() {
        Rest.loadBrands(onComplete: { (brands) in
            if let brands = brands {
                self.brands = brands.sorted(by: { ($0.fipe_name ?? "") < ($1.fipe_name ?? "") })
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
            }
        }) { (error) in
            print(error)
        }
    }
    
    private func goBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func cancel() {
        tfBrand.resignFirstResponder()
    }
    
    @objc private func done() {
        let index = pickerView.selectedRow(inComponent: 0)
        tfBrand.text = brands[index].fipe_name
        cancel()
    }
}

extension AddEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return brands.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return brands[row].fipe_name
    }
}
