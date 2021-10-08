//
//  File.swift
//  
//
//  Created by Markus Moenig on 5/10/2564 BE.
//

typealias OpCodeType = UInt8

enum OpCode : OpCodeType {
    
    case Constant
    case Add
    case Subtract
    case Multiply
    case Divide
    case Negate
    case Return
    case Nil
    case True, False
    case Not
    case Equal, Greater, Less
}

