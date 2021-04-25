//
//  UITableViewCell+Extension.swift
//  TimetableApp
//
//  Created by 大西玲音 on 2021/04/25.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String { String(describing: self) }
    static func nib() -> UINib { UINib(nibName: String(describing: self), bundle: nil) }
    
}
