//: [Previous](@previous)
/*:
 # S-R Latch
 The circuit on the right is called a S-R latch and consists of only two `NOR` gates.
 It has two inputs, and two outputs. Usually, one output is the inverse of the other.


 Pressing the button on the top "resets" the latch, setting the output to zero. The output remains
 zero after the button is released.
 Pressing the button on the bottom "sets" the latch, setting the output to one. The output remains
 one after the button is released.

 */
import UIKit
import PlaygroundSupport

// Initialize our circuit
let circuit = Circuit(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
PlaygroundPage.current.liveView = circuit

// Components used in the S-R latch
let nor1 = NorGate(circuit: circuit, position: CGPoint(x: 2, y: 1))
let nor2 = NorGate(circuit: circuit, position: CGPoint(x: 2, y: 3))
// Inputs
let input = Switch(circuit: circuit, position: CGPoint(x: 1, y: 1), type: .pushbutton(normallyOff: true))
let input2 = Switch(circuit: circuit, position: CGPoint(x: 1, y: 4), type: .pushbutton(normallyOff: true))
// Outputs
let output = Led(circuit: circuit, position: CGPoint(x: 6, y: 1))
let output2 = Led(circuit: circuit, position: CGPoint(x: 6, y: 4))
// Make connections
circuit.connect(nor1.a, input.out)
circuit.connect(nor2.b, input2.out)
circuit.connect(nor1.y, nor2.a)
circuit.connect(nor2.y, nor1.b)
circuit.connect(nor1.y, output.input)
circuit.connect(nor2.y, output2.input)
// Start simulation
circuit.simulate()
//:> Try pressing the buttons to see how the outputs change.
/*:
The latch circuit is fundamental to many circuits as it can function as a memory block.
 Go to the [next page](@next) to learn about an important variation to the S-R latch.
 */
//: [Next](@next)
