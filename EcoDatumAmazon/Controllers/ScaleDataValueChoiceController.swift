import Foundation
import UIKit

class ScaleDataValueChoiceController: UIViewController {
    
  var ecoFactor: EcoFactor!
  
  private var abioticDataUnit: AbioticDataUnit! {
    return ecoFactor.abioticEcoData!.dataUnit!
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}
