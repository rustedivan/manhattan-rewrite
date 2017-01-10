//
//  ExpressionTree.swift
//  manhattan-rewrite
//
//  Created by Ivan Milles on 2017-01-07.
//  Copyright © 2017 Wildbrain. All rights reserved.
//

import Foundation

enum Operator: CustomDebugStringConvertible, Equatable {
	case add
	case subtract
	
	var symbol: String {
		switch self {
		case .add: return "+"
		case .subtract: return "-"
		}
	}
	
	var debugDescription: String {
		return self.symbol
	}
	
	static func == (lhs: Operator, rhs: Operator) -> Bool {
		return lhs.symbol == rhs.symbol
	}
}

indirect enum ExpressionNode: CustomDebugStringConvertible {
	case constant(Double)
	case variable(String)
	case operator2(Operator, ExpressionNode, ExpressionNode)
	
	var debugDescription: String {
		switch self {
		case .constant(let v): return "\(v)"
		case .variable(let n): return n
		case .operator2(let op, let lhs, let rhs):
			return "\(lhs) \(op) \(rhs)"
		}
	}
	
	func left() throws -> ExpressionNode {
		if case let .operator2(_, l, _) = self {
			return l
		} else {
			throw TreePathError.expressionNotBranched(self, .left(.end))
		}
	}
	func right() throws -> ExpressionNode {
		if case let .operator2(_, _, r) = self {
			return r
		} else {
			throw TreePathError.expressionNotBranched(self, .right(.end))
		}
	}
}

extension ExpressionNode {
	func matches(_ t: TransformNode) -> Bool {
		switch (self, t) {
		case (.operator2(let eOp, let eL, let eR), .operator2(let tOp, let tL, let tR)):
			return (tOp == eOp &&
							eL.matches(tL) &&
							eR.matches(tR))
		case (.variable, .variable):
			return true
		case (.constant, .constant):
			return true
		default:
			return false
		}
	}
}
