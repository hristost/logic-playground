//: [Previous](@previous)
/*:
 # D Latch
 The circuit on the right is called a D latch.
 It consists of a S-R latch, two `AND` gates, and one `NOT` gate.

 As with the S-R latch, the D latch has two inputs and two outputs.
 The input connected to the top switch is called the `Enable` input (`E`),
 and the input connected to the bottom switch is called the `Data` input (`D`).

 The operation of the `D` latch is also simple. While `E` is high, the outputs reflect the state of `D`. However, while `E` is low, the outputs remain unchanged.

 */
import UIKit
import PlaygroundSupport

// Initialize our circuit
let circuit = Circuit(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
PlaygroundPage.current.liveView = circuit

// Components used in the S-R latch
let nor_r = NorGate(circuit: circuit, position: CGPoint(x: 7, y: 1.5))
let nor_s = NorGate(circuit: circuit, position: CGPoint(x: 7, y: 4))
// Additional components for the D latch
let and_r = AndGate(circuit: circuit, position: CGPoint(x:4, y: 1))
let and_s = AndGate(circuit: circuit, position: CGPoint(x:4, y: 4.5))
let not = Not(circuit: circuit, position: CGPoint(x:2, y:7))
// Inputs
let input_e = Switch(circuit: circuit, position: CGPoint(x: 1, y: 1), type: .toggle(initialState: true))
let input_d = Switch(circuit: circuit, position: CGPoint(x: 1, y: 4), type: .toggle(initialState: false))
// Outputs
let out_q = Led(circuit: circuit, position: CGPoint(x: 10, y: 1))
// Make connections
circuit.connect(input_e.out, and_r.a)
circuit.connect(input_e.out, and_s.a)
circuit.connect(input_d.out, and_s.b)
circuit.connect(not.input, input_d.out)
circuit.connect(not.out, and_r.b)
circuit.connect(and_r.y, nor_r.a)
circuit.connect(and_s.y, nor_s.b)
circuit.connect(nor_s.y, nor_r.b)
circuit.connect(nor_r.y, nor_s.a)
circuit.connect(nor_r.y, out_q.input)
// Start simulation
circuit.simulate()
//:> Try toggling the switches in such a way that you can change the output state
//:
//: Learn how D Latches can be used to construct the so-called "counter" circuit
//: in the [next page](@next)
//:
//: [Next](@next)
