//
//  ExpressionTransform.swift
//  manhattan-rewrite
//
//  Created by Ivan Milles on 2017-01-07.
//  Copyright © 2017 Wildbrain. All rights reserved.
//

import Foundation

enum TransformError: Error {
	case notApplicableHere(ExpressionNode, TransformNode, TransformNode)
	case notMatchingHere(ExpressionNode, TransformNode, TransformNode)
}

indirect enum TransformNode: CustomDebugStringConvertible {
	case operator2(Operator, TransformNode, TransformNode)
	case constant(Character)
	case variable(Character)
	
	var debugDescription: String {
		switch self {
		case .constant(let symbol): return String(symbol)
		case .variable(let symbol): return String(symbol)
		case .operator2(let op, let lhs, let rhs):
			return "\(lhs) \(op) \(rhs)"
		}
	}
}

typealias Transform = ((ExpressionNode) throws -> ExpressionNode)
