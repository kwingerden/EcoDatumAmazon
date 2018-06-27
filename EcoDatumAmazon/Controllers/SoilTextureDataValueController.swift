import Foundation
import UIKit

class SoilTextureDataValueChoiceController: UIViewController {
  
  var parentController: AbioticDataValueChoiceController!
  
  var embeddedViewToDisplay: AbioticDataValueChoiceController.EmbeddedView!
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  
  @IBOutlet weak var sandPercentPicker: UIPickerView!
  
  @IBOutlet weak var siltPercentPicker: UIPickerView!
  
  @IBOutlet weak var clayPercentPicker: UIPickerView!
  
  private var abioticEcoData: AbioticEcoData! {
    return ecoFactor.abioticEcoData!
  }
  
  private enum Percentage: Int {
    case Zero = 0
    case Ten = 10
    case Twenty = 20
    case Thirty = 30
    case Forty = 40
    case Fifty = 50
    case Sixty = 60
    case Seventy = 70
    case Eighty = 80
    case Ninety = 90
    case OneHundred = 100
    
    static let all: [Percentage] = [
      .Zero,
      .Ten,
      .Twenty,
      .Thirty,
      .Forty,
      .Fifty,
      .Sixty,
      .Seventy,
      .Eighty,
      .Ninety,
      .OneHundred
    ]
  }
  
  private var abioticDataUnit: AbioticDataUnit! {
    return ecoFactor.abioticEcoData!.dataUnit!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard embeddedViewToDisplay == .soilTextureDataValueView else {
      return
    }
    
    let font: [AnyHashable: Any] = [
      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22)
    ]
    segmentedControl.setTitleTextAttributes(font, for: .normal)
    
    sandPercentPicker.dataSource = self
    siltPercentPicker.dataSource = self
    clayPercentPicker.dataSource = self
    
    sandPercentPicker.delegate = self
    siltPercentPicker.delegate = self
    clayPercentPicker.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    guard embeddedViewToDisplay == .soilTextureDataValueView else {
      return
    }
    
    segmentedControl.setTitle(
      "\(Percentage.all[0].rawValue)% Sand",
      forSegmentAt: 0)
    segmentedControl.setTitle(
      "\(Percentage.all[0].rawValue)% Silt",
      forSegmentAt: 1)
    segmentedControl.setTitle(
      "\(Percentage.all[0].rawValue)% Clay",
      forSegmentAt: 2)
    
    sandPercentPicker.selectRow(0, inComponent: 0, animated: false)
    siltPercentPicker.selectRow(0, inComponent: 0, animated: false)
    clayPercentPicker.selectRow(0, inComponent: 0, animated: false)
    
    showPercentPicker(sandPercentPicker)
  }
  
  func doneButtonPressed() {
    guard embeddedViewToDisplay == .soilTextureDataValueView else {
      return
    }
    
    let percentSand = Percentage.all[sandPercentPicker.selectedRow(inComponent: 0)].rawValue
    let percentSilt = Percentage.all[siltPercentPicker.selectedRow(inComponent: 0)].rawValue
    let percentClay = Percentage.all[clayPercentPicker.selectedRow(inComponent: 0)].rawValue
    let soilTextureScale = SoilTextureScale(
      percentSand: percentSand,
      percentSilt: percentSilt,
      percentClay: percentClay)
  
    DispatchQueue.main.async {
      let ecoData = self.abioticEcoData.new(.SoilTextureScale(soilTextureScale))
      self.parentController.ecoFactor = EcoFactor(
        collectionDate: self.ecoFactor.collectionDate,
        ecoData: EcoFactor.EcoData.Abiotic(ecoData))
      self.parentController.saveData()
      self.parentController.popToMainTabBarController()
    }
  }
  
  @IBAction func valueChanged(_ sender: UISegmentedControl) {
    
    switch segmentedControl.selectedSegmentIndex {
      
    case 0: showPercentPicker(sandPercentPicker)
    case 1: showPercentPicker(siltPercentPicker)
    case 2: showPercentPicker(clayPercentPicker)
      
    default: fatalError()
      
    }
    
  }
  
  private func showPercentPicker(_ pickerView: UIPickerView) {
    
    switch pickerView {
      
    case sandPercentPicker:
      sandPercentPicker.isHidden = false
      siltPercentPicker.isHidden = true
      clayPercentPicker.isHidden = true
      
    case siltPercentPicker:
      sandPercentPicker.isHidden = true
      siltPercentPicker.isHidden = false
      clayPercentPicker.isHidden = true
      
    case clayPercentPicker:
      sandPercentPicker.isHidden = true
      siltPercentPicker.isHidden = true
      clayPercentPicker.isHidden = false
      
    default: fatalError()
      
    }
    
  }
  
}

extension SoilTextureDataValueChoiceController: UIPickerViewDataSource {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return Percentage.all.count
  }
  
}

extension SoilTextureDataValueChoiceController: UIPickerViewDelegate {
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return String(Percentage.all[row].rawValue)
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    let percentage = Percentage.all[row]
    switch pickerView {
      
    case sandPercentPicker:
      segmentedControl.setTitle("\(percentage.rawValue)% Sand", forSegmentAt: 0)
      
    case siltPercentPicker:
      segmentedControl.setTitle("\(percentage.rawValue)% Silt", forSegmentAt: 1)
      
    case clayPercentPicker:
      segmentedControl.setTitle("\(percentage.rawValue)% Clay", forSegmentAt: 2)
      
    default: fatalError()
      
    }
    
  }
  
}

