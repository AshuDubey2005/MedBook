//
//  KeychainService.swift
//  MedBook
//
//  Created by deq on 14/02/24.
//

import Foundation

protocol HTTPRequestProtocol {
    associatedtype GenericProperty
    var path: String { get}
    var httpBody: GenericProperty { get }
    var queryParams: [String: String]? { get }
}
