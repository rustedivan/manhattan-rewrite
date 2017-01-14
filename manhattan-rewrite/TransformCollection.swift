//
//  TransformCollection.swift
//  manhattan-rewrite
//
//  Created by Ivan Milles on 2017-01-10.
//  Copyright © 2017 Wildbrain. All rights reserved.
//

import Foundation

struct TransformCollection {
	private let transformMap = buildTransformMap()
	
	subscript(name: String) -> Transform {
		if let t = transformMap[name] {
			return t
		} else {
			fatalError("Transform \(name) not implemented.")
		}
	}
}


fileprivate func buildTransformMap() -> [String : Transform]
{
	var transforms = [String : Transform]()
	
	do {
		let tAdd = TransformNode.operator2(.add, .constant("a"), .constant("b"))
		let tAdded = TransformNode.constant("c")
		
		transforms["add-constants"] = { (e: ExpressionNode) in
			if e.matches(tAdd) {
				let left = try e.left()
				let right = try e.right()
				
				if case let (.constant(lv), .constant(rv)) = (left, right) {
					return ExpressionNode.constant(lv + rv)
				}
				throw TransformError.notMatchingHere(e, tAdd, tAdded)
			}
			throw TransformError.notApplicableHere(e, tAdd, tAdded)
		}
	}
	
	return transforms
}

