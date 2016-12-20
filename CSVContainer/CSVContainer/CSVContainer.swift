//
//  CSVContainer.swift
//  CSVContainer
//
//  Created by 史　翔新 on 2016/12/19.
//  Copyright © 2016年 crazism. All rights reserved.
//

import Foundation

public struct CSVContainer {
	
	public enum Data {
		case string(String)
	}
	
	fileprivate var content: [[Data]]
	
}

extension CSVContainer.Data {
	
	public init(_ string: String) {
		self = .string(string)
	}
	
	public var text: String {
		switch self {
		case .string(let string):
			return string
		}
	}
	
}

extension CSVContainer {
	
	public init(fromContent content: String) {
		
		let components = content.lineSeparatedComponents.map { (line) -> [String] in
			return line.commaSeparatedComponents
		}
		let data = components.map { (line) -> [Data] in
			let data = line.map({ (component) -> Data in
				return Data(component)
			})
			return data
		}
		
		self.content = data
		
	}
	
}

extension CSVContainer {
	
	public func map<T>(_ transform: ([Data]) throws -> T) rethrows -> [T] {
		return try self.content.map({ (line) -> T in
			return try transform(line)
		})
	}
	
}

private extension Array {
	
	func removingLast() -> Array<Element> {
		return Array(self.dropLast())
	}
	
}

private extension String {
	
	var lineSeparatedComponents: [String] {
		let components = self.components(separatedBy: .newlines)
		let trimmedComponents = components.flatMap { (component) -> String? in
			if component.trimmingCharacters(in: .whitespaces).isEmpty {
				return nil
				
			} else {
				return component
			}
		}
		return trimmedComponents
	}
	
	var commaSeparatedComponents: [String] {
		let components = self.components(separatedBy: ",")
		let reducedComponents = components.reduce([]) { (components, next) -> [String] in
			if let lastComponent = components.last, lastComponent.hasPrefix("\"") && !lastComponent.hasSuffix("\"") {
				let combinedLastComponent = lastComponent + "," + next
				return components.removingLast() + [combinedLastComponent]
				
			} else {
				return components + [next]
			}
		}
		return reducedComponents
	}
	
}
