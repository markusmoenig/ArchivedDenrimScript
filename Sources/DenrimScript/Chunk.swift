//
//  Chunk.swift
//  
//
//  Created by Markus Moenig on 5/10/2564 BE.
//

import Foundation

class Chunk {
    
    // We use Swift's inbuild growth strategy
    
    /// Opcodes
    var code            = [OpCodeType]()
    var count           : Int {
        return code.count
    }

    /// Constants
    var constants       = ConstantArray<Value>()

    /// Lines
    var lines           = ConstantArray<Int>()
    
    deinit {
        code.removeAll()
    }
    
    /// Write an opcode to the chunk
    func write(_ opcode: OpCodeType, line: Int) {
        code.append(opcode)
        lines.write(line)
    }
    
    /// Add a constant and return its offset
    func addConstant(_ value: Value, line: Int) {
        constants.write(value)
        write(OpCodeType(exactly: constants.count - 1)!, line: line)
    }
    
    /// Create a string representation of the bytecode
    func disassemble(name: String) -> String {
        var result = "== \(name) ==\n"
        
        var i = 0
        while i < count {
            let d = disassemble(offset: i)
            result += d.0 + "\n"
            i = d.1
        }
        return result
    }
    
    /// Create a string for an individual op
    func disassemble(offset: Int) -> (String, Int) {
        let op = code[offset]
        var outOffset = offset + 1
        
        var outString = String(format: "%04d ", offset) + "  "
        
        let line = lines.values[offset]
        
        if offset > 0 && line == lines.values[offset - 1] {
            outString += "   |   "
        } else {
            outString += String(format: "%4d ", line) + "  "
        }

        switch OpCode(rawValue: op)! {
        case .Constant:
            outString += "OP_CONSTANT"
            let constantOffset = Int(exactly: code[offset + 1])!
            outString += "    " + String(constantOffset) + "  '" + String(constants.values[constantOffset]) + "'"
            outOffset += 1
        case .Add:          outString += "OP_ADD"
        case .Subtract:     outString += "OP_SUBTRACT"
        case .Multiply:     outString += "OP_MULTIPLY"
        case .Divide:       outString += "OP_DIVIDE"
        case .Negate:       outString += "OP_NEGATE"
        case .Return:       outString += "OP_RETURN"
        case .Nil:          outString += "OP_NIL"
        case .True:         outString += "OP_TRUE"
        case .False:        outString += "OP_FALSE"
        case .Not:          outString += "OP_NOT"
        case .Equal:        outString += "OP_EQUAL"
        case .Greater:      outString += "OP_GREATER"
        case .Less:         outString += "OP_LESS"
        }
        
        return (outString, outOffset)
    }
}
