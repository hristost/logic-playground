//: [Previous](@previous)
//: # Counting
//:
//: ## D Flip-Flop
//: By combining two D-latches and a `NOT` gate, we can create a D Flip-Flop.
//: A D Flip-Flop has two inputs: `Data` (`D`) and `Clock` (`CLK`).
//:
//: The operation of the D Flip-Flop is similar to that of the D latch, except
//: that the state does not get update when `CLK` is high, but when `CLK`
//: transitions from high to low. This makes the D Flip-Flop suitable for
//: memory applications.
//:
//: Here we define a D Flip-Flop to use in a circuit. You do not need to read
//: through this code.
import UIKit
import PlaygroundSupport

// We use a class so we can create many instances of the flip-flop
class DFlipFlop {
    let data: Pin
    let clock: Pin
    let q: Pin
    let qq: Pin
    init(circuit: Circuit, position: CGPoint) {
        // We position the components relative to the position of the whole flip-flop
        var p = position + CGPoint(x: -2, y: -1)
        // Gates used in the first D latch
        let and_r = AndGate(circuit: circuit, position: p+CGPoint(x:4.5, y: 1))
        let or_r = NorGate(circuit: circuit, position: p+CGPoint(x: 7, y: 1.5))
        let and_s = AndGate(circuit: circuit, position: p+CGPoint(x:4, y: 4.5))
        let or_s = NorGate(circuit: circuit, position: p+CGPoint(x: 7, y: 4))
        let not = Not(circuit: circuit, position: p+CGPoint(x:2, y:0.5))
        let not_clk = Not(circuit: circuit, position: p+CGPoint(x:6, y:5))
        p = p + CGPoint(x:6, y: 0)
        // Gates used in the second D latch
        let and_r2 = AndGate(circuit: circuit, position: p+CGPoint(x:4.5, y: 1))
        let or_r2 = NorGate(circuit: circuit, position: p+CGPoint(x: 7, y: 1.5))
        let and_s2 = AndGate(circuit: circuit, position: p+CGPoint(x:4, y: 4.5))
        let or_s2 = NorGate(circuit: circuit, position: p+CGPoint(x: 7, y: 4))
        // Connections in the second D latch
        circuit.connect(and_r2.y, or_r2.a)
        circuit.connect(and_s2.y, or_s2.b)
        circuit.connect(or_s2.y, or_r2.b)
        circuit.connect(or_r2.y, or_s2.a)
        circuit.connect(and_s2.a, and_r2.b)
        circuit.connect(or_s.y, and_r2.a)
        circuit.connect(or_r.y, and_s2.b)
        circuit.connect(not_clk.out, and_s2.a)
        circuit.connect(not_clk.input, and_s.a)
        circuit.connect(not.out, and_r.a)
        // Connections in the first D latch
        circuit.connect(and_r.y, or_r.a)
        circuit.connect(and_s.y, or_s.b)
        circuit.connect(or_s.y, or_r.b)
        circuit.connect(or_r.y, or_s.a)
        circuit.connect(and_s.a, and_r.b)
        circuit.connect(not.input, and_s.b)
        // Designate pins as inputs and outputs
        data = not.input
        clock = and_s.a
        q = or_r2.y
        qq = or_s2.y
    }
}
/*:
 ## Counting
 By chaining D Flip-Flops together we can easily create a counter
 The input of the counter is a clock signal, and the output is a number coded in binary that increases every time the clock transitions from high to low
 The circuit on the right has two D Flip-Flops used to create a 2-bit counter,
 and some logic gates on the bottom that display the output in a human readable form
 */
let circuit = Circuit(frame: CGRect(x: 0, y: 0, width: 700, height: 700))
let flip1 = DFlipFlop(circuit: circuit, position: CGPoint(x:2, y: 1))
let flip2 = DFlipFlop(circuit: circuit, position: CGPoint(x:2, y: 7))
let input_e = Switch(circuit: circuit, position: CGPoint(x: 1, y: 1), type: .pushbutton(normallyOff: true))
let out_1 = Led(circuit: circuit, position: CGPoint(x: 16, y: 1))
let out_2 = Led(circuit: circuit, position: CGPoint(x: 16.25, y: 3))
circuit.connect(input_e.out, flip1.clock)
circuit.connect(flip1.qq, flip1.data)
circuit.connect(flip1.q, flip2.clock)
circuit.connect(flip2.qq, flip2.data)
circuit.connect(flip1.q, out_1.input)
circuit.connect(flip2.q, out_2.input)
//: By now we have two flip flops, one button and two lights. The flip flops
//: are connected in such a way that their combined outputs represent a number
//: binary that increases at every clock cycle. Try pushing the buttons to see
//: the lights change.
//:
//: However, it would be nicer if we could present this number in a human-readable
//: format. The code bellow arranges multiple lights in positions that form a
//: numeric display, and includes logic for turning them off and on.
let not_a = Not(circuit: circuit, position: CGPoint(x:2, y: 13))
let not_b = Not(circuit: circuit, position: CGPoint(x:2, y: 15))

let a_1 = Led(circuit: circuit, position: CGPoint(x: 15, y: 12))
let a_2 = Led(circuit: circuit, position: CGPoint(x: 16, y: 12))
let b_1 = Led(circuit: circuit, position: CGPoint(x: 16.5, y: 12.5))
let b_2 = Led(circuit: circuit, position: CGPoint(x: 16.5, y: 13.5))
let f_1 = Led(circuit: circuit, position: CGPoint(x: 14.5, y: 12.5))
let f_2 = Led(circuit: circuit, position: CGPoint(x: 14.5, y: 13.5))
let g_1 = Led(circuit: circuit, position: CGPoint(x: 15, y: 14))
let g_2 = Led(circuit: circuit, position: CGPoint(x: 16, y: 14))
let c_1 = Led(circuit: circuit, position: CGPoint(x: 16.5, y: 14.5))
let c_2 = Led(circuit: circuit, position: CGPoint(x: 16.5, y: 15.5))
let e_1 = Led(circuit: circuit, position: CGPoint(x: 14.5, y: 14.5))
let e_2 = Led(circuit: circuit, position: CGPoint(x: 14.5, y: 15.5))
let d_1 = Led(circuit: circuit, position: CGPoint(x: 15, y: 16))
let d_2 = Led(circuit: circuit, position: CGPoint(x: 16, y: 16))
// We need to make one of the segments always on
b_1.input.signal = Signal(high: true)
b_2.input.signal = Signal(high: true)
circuit.connect(a_1.input, a_2.input)
circuit.connect(c_1.input, c_2.input)
circuit.connect(d_1.input, d_2.input)
circuit.connect(e_1.input, e_2.input)
circuit.connect(f_1.input, f_2.input)
circuit.connect(g_1.input, g_2.input)

circuit.connect(flip1.q, not_a.input)
circuit.connect(flip2.q, not_b.input)

let and1 = AndGate(circuit: circuit, position: CGPoint(x: 6, y: 13))
let or1 = OrGate(circuit: circuit, position: CGPoint(x: 6, y: 15))
let or2 = OrGate(circuit: circuit, position: CGPoint(x: 10, y: 15))
circuit.connect(and1.a, not_a.out)
circuit.connect(and1.b, not_b.out)
circuit.connect(or1.a, not_a.out)
circuit.connect(or1.b, not_b.input)

circuit.connect(or1.y, a_1.input)
circuit.connect(a_1.input, d_1.input)
circuit.connect(not_b.input, g_1.input)
circuit.connect(or2.y, c_1.input)
circuit.connect(not_a.out, e_1.input)
circuit.connect(or2.a, and1.y)
circuit.connect(or2.b, not_a.input)
circuit.connect(and1.y, f_1.input)


circuit.simulate()
PlaygroundPage.current.liveView = circuit

//:> See what happens when you press the button. Can you figure out how the counter works?
//: The playground ends here. If you want to build your own logic circuit, feel free to
//: modify the code used among these pages -- it supports most components you would need.
