//
//  UIDeviceExtension.swift
//  Persimmon
//
//  Created by hyeoktae kwon on 2019/10/15.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}

/* How to use
if UIDevice.current.hasNotch {
    //... consider notch
} else {
    //... don't have to consider notch
}
*/
