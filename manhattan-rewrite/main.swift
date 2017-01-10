//
//  main.swift
//  manhattan-rewrite
//
//  Created by Ivan Milles on 2017-01-07.
//  Copyright © 2017 Wildbrain. All rights reserved.
//

import Foundation

let t = TransformCollection()

let xPlus23 = ExpressionNode.operator2(.add, .variable("x"), .operator2(.add, .constant(5.0), .constant(2.0)))

let pathToConstantAdd = TreePath.right(.end)

if case let .operator2(_, _, rhs) = xPlus23 {
	do {
		let seven = try t["add-constants"](subTree(xPlus23, at: pathToConstantAdd))
		print(seven)
	} catch TreePathError.expressionTerminated(let p) {
		print("Path '\(p)' is too deep for this tree.")
	} catch TreePathError.expressionNotBranched(let e, let p) {
		print("Path wants to branch '\(p)' into unary node '\(e)'.")
	} catch TransformError.notApplicableHere(let e, let t, let r) {
		print("Transform '\(t)' -> '\(r)' cannot be applied to '\(e)'.")
	} catch TransformError.notMatchingHere {
		print("Transform lacks operands.")
	}
}

