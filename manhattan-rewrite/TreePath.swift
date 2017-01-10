//
//  TreePath.swift
//  manhattan-rewrite
//
//  Created by Ivan Milles on 2017-01-07.
//  Copyright © 2017 Wildbrain. All rights reserved.
//

import Foundation

indirect enum TreePath: CustomDebugStringConvertible {
	case left(TreePath)
	case right(TreePath)
	case end
	
	var debugDescription: String {
		let path = pathAsArray.map { (part) -> String in
			switch part {
			case .left: return "left"
			case .right: return "right"
			case .end: return "."
			}
		}
		return path.dropLast().joined(separator: ", ")
	}
	
	var pathAsArray: [TreePath] {
		var path = [self]
		switch self {
		case .left(let next): path.append(contentsOf: next.pathAsArray)
		case .right(let next): path.append(contentsOf: next.pathAsArray)
		case .end: break
		}
		return path
	}
}

enum TreePathError: Error {
	case expressionTerminated(ExpressionNode, TreePath)
	case expressionNotBranched(ExpressionNode, TreePath)
}

func subTree(_ e: ExpressionNode, at path: TreePath) throws -> ExpressionNode {
	switch path {
	case .end: return e
	case .left(let next):
		return try subTree(e.left(), at: next)
	case .right(let next):
		return try subTree(e.right(), at: next)
	}
}
