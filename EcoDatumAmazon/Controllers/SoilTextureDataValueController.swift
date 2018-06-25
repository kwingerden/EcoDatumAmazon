import Foundation
import UIKit

class SoilTextureDataValueChoiceController: UIViewController {
    
  var ecoFactor: EcoFactor!
  
  private var abioticDataUnit: AbioticDataUnit! {
    return ecoFactor.abioticEcoData!.dataUnit!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}
