//
//  ColorExtension.swift
//  Persimmon
//
//  Created by Jeon-heaji on 2019/10/13.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

enum AssetsColor {
  // AppColor Green
  case appFontColor
  case appPersimmonColor
  case appYellowColor
  case appGreenColor
  case appLayerBorderColor

}

extension UIColor {
  static func appColor(_ colorName: AssetsColor) -> UIColor {
    switch colorName {
    case .appFontColor:
      return #colorLiteral(red: 0.4235695601, green: 0.1683633327, blue: 0.1960875094, alpha: 1)
    case .appPersimmonColor:
      return #colorLiteral(red: 0.8873428702, green: 0.3557569683, blue: 0, alpha: 1)
    case .appYellowColor:
      return #colorLiteral(red: 1, green: 0.6457151771, blue: 0, alpha: 1)
    case .appGreenColor:
      return #colorLiteral(red: 0.3548052609, green: 0.284040451, blue: 0.116188474, alpha: 1)
    case .appLayerBorderColor:
      return #colorLiteral(red: 0.9475665689, green: 0.9102826715, blue: 0.8136286139, alpha: 1)

    }
  }
}
