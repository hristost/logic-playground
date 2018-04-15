/*:
 # Logic simulator
 Logic gates are simple circuits that take a few inputs and produce an output based on some
 function.

 This playground can simulate circuits made out of basic logic gates, inputs and outputs.
In electronics, bits are represented using different voltage levels. Usually, a designated
 high voltage is logic 1, and some lower voltage is logic 0. In this playground, we represent inputs using switches and outputs using lights.
 The colours of the wires that connect components also change depending on the state -- green is for logic 1, and white is for logic 0.
 */
import UIKit
import PlaygroundSupport

// Initialize our circuit
let circuit = Circuit(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
PlaygroundPage.current.liveView = circuit

// Components used in the S-R latch
let gate = AndGate(circuit: circuit, position: CGPoint(x: 4, y: 2))
//:> Change `AndGate` in the above line to see how other logic gates behave. You can use `OrGate`, `XorGate`, `NandGate` and `NorGate`
let input = Switch(circuit: circuit, position: CGPoint(x: 1, y: 1), type: .toggle(initialState: false))
let input2 = Switch(circuit: circuit, position: CGPoint(x: 1, y: 4), type: .toggle(initialState: false))
let output = Led(circuit: circuit, position: CGPoint(x: 8, y: 2.5))
// Make connections
circuit.connect(gate.a, input.out)
circuit.connect(gate.b, input2.out)
circuit.connect(gate.y, output.input)
// Start simulation
circuit.simulate()

/*:
 Now, visit the [next page](@next) to learn about a simple circuit implemented using only two logic gates.

 */
//: [Next page](@next)
