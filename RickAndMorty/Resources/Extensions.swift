//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Amir Sajad Nemati on 2/26/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...){
        views.forEach({
            addSubview($0)
        })
    }
}
