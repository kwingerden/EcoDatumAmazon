import Foundation
import UIKit

class ScaleDataValueChoiceController: UIViewController {
  
  var parentController: AbioticDataValueChoiceController!
  
  var embeddedViewToDisplay: AbioticDataValueChoiceController.EmbeddedView!
  
  var ecoFactor: EcoFactor!
  
  @IBOutlet weak var tableView: UITableView!
  
  private var abioticEcoData: AbioticEcoData! {
    return ecoFactor.abioticEcoData!
  }
  
  private var abioticDataUnit: AbioticDataUnit! {
    return abioticEcoData!.dataUnit!
  }
  
  private var selectedIndex: Int? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    guard embeddedViewToDisplay == .scaleDataValueView else {
      return
    }
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.tableFooterView = UIView()
  }
  
  func doneButtonPressed() {
    guard embeddedViewToDisplay == .scaleDataValueView else {
      return
    }
    
    if let index = selectedIndex {
      var abioticDataValue: AbioticDataValue?
      switch abioticDataUnit! {
      case ._Air_Ozone_Scale_:
        abioticDataValue = AbioticDataValue.AirOzoneScale(AirOzoneScale.all[index])
      case ._Soil_Potassium_Scale_:
        abioticDataValue = AbioticDataValue.SoilPotassiumScale(SoilPotassiumScale.all[index])
      case ._Water_Odor_Scale_:
        abioticDataValue = AbioticDataValue.WaterOdorScale(WaterOdorScale.all[index])
      case ._Water_pH_Scale_:
        abioticDataValue = AbioticDataValue.DecimalDataValue("\(index + 1)")
      case ._Water_Turbidity_Scale_:
        abioticDataValue = AbioticDataValue.WaterTurbidityScale(WaterTurbidityScale.all[index])
      default:
        LOG.error("Unexpected data unit \(abioticDataUnit)")
      }
      
      if let abioticDataValue = abioticDataValue {
        let ecoData = abioticEcoData.new(abioticDataValue)
        parentController.ecoFactor = EcoFactor(
          collectionDate: ecoFactor.collectionDate,
          ecoData: EcoFactor.EcoData.Abiotic(ecoData))
        parentController.saveData()
        parentController.popToMainTabBarController()
      }
    }
  }
  
}

extension ScaleDataValueChoiceController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedIndex = indexPath.row
  }
  
}

extension ScaleDataValueChoiceController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    switch abioticDataUnit! {
    case ._Air_Ozone_Scale_:
      return AirOzoneScale.all.count
    case ._Soil_Potassium_Scale_:
      return SoilPotassiumScale.all.count
    case ._Water_Odor_Scale_:
      return WaterOdorScale.all.count
    case ._Water_pH_Scale_:
      return 14
    case ._Water_Turbidity_Scale_:
      return WaterTurbidityScale.all.count
    default:
      LOG.error("Unexpected data unit \(abioticDataUnit)")
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    switch abioticDataUnit! {
      
    case ._Air_Ozone_Scale_:
      switch AirOzoneScale.all[indexPath.row] {
      case let .LessThan90(_, label): cell.textLabel?.text = label
      case let .Between90And150(_, label):cell.textLabel?.text = label
      case let .GreaterThan150To210(_, label):cell.textLabel?.text = label
      case let .GreaterThan210(_, label): cell.textLabel?.text = label
      }
    
    case ._Soil_Potassium_Scale_:
      switch SoilPotassiumScale.all[indexPath.row] {
      case let .Low(_, label): cell.textLabel?.text = label
      case let .Medium(_, label):cell.textLabel?.text = label
      case let .High(_, label):cell.textLabel?.text = label
      }
    
    case ._Water_Odor_Scale_:
      switch WaterOdorScale.all[indexPath.row] {
      case let .NoOdor(_, label): cell.textLabel?.text = label
      case let .SlightOdor(_, label):cell.textLabel?.text = label
      case let .Smelly(_, label):cell.textLabel?.text = label
      case let .VerySmelly(_, label): cell.textLabel?.text = label
      case let .Devastating(_, label): cell.textLabel?.text = label
      }
    
    case ._Water_pH_Scale_:
     cell.textLabel?.text = String(indexPath.row + 1)
    
    case ._Water_Turbidity_Scale_:
      switch WaterTurbidityScale.all[indexPath.row] {
      case let .CrystalClear(_, label): cell.textLabel?.text = label
      case let .SlightlyCloudy(_, label):cell.textLabel?.text = label
      case let .ModeratelyCloudy(_, label):cell.textLabel?.text = label
      case let .VeryCloudy(_, label): cell.textLabel?.text = label
      case let .BlackishOrBrownish(_, label): cell.textLabel?.text = label
      }
    
    default:
      LOG.error("Unexpected data unit \(abioticDataUnit)")
    }
    
    return cell
  }
  
}
