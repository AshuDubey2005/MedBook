//
//  BaseViewModel.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import Foundation

class BaseViewModel: NSObject {
    var showHUD: Bindable<Bool> = Bindable(false)
    var success: Bindable<Bool> = Bindable(false)
}
