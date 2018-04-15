import UIKit

/// A complete circuit of elements and connections that can be simulated

public class Circuit: UIView {
    public var spacing: CGFloat = 40
    var elements: [Module] = []
    var connections: [Wire] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// Connect two elements in the circuit
    public func connect(_ a: Pin, _ b: Pin) {
        let wire = Wire(a: a, b: b)
        connections.append(wire)
        if wire.a.signal == nil && wire.b.signal == nil {
            wire.signal = Signal()
            wire.a.signal = wire.signal
            wire.b.signal = wire.signal
        } else if wire.a.signal == nil {
            wire.signal = wire.b.signal
            wire.a.signal = wire.signal
        } else if wire.b.signal == nil {
            wire.signal = wire.a.signal
            wire.b.signal = wire.signal
        } else {
            mergeSignals(wire.a.signal!, wire.b.signal!)
            wire.signal = wire.a.signal!
        }
    }


    /// Add a new element to the circuit
    public func addElement(_ element: Module) {
        elements.append(element)
        // Position the element on the circuit grid
        let p = element.frame.origin
        let c = element.centerPoint
        element.frame.origin = CGPoint(x: p.x * spacing - c.x, y: p.y * spacing - c.y)
        // Make sure all pins hold a reference to the element
        var mirror: Mirror? = Mirror(reflecting: element)
        repeat {
            for pin in mirror!.children where type(of: pin.value) == Pin.self {
                (pin.value as? Pin)?.module = element
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
    }


    func mergeSignals(_ a: Signal, _ b: Signal) {
        for wire in connections {
            if let signal = wire.signal, signal === b {
                wire.a.signal = a
                wire.b.signal = a
                wire.signal = a
            }
        }
    }
    /// Update all states
    ///
    /// This is not a proper simulation algorithm (it's inefficient and doesn't detect
    /// errors, but works well enough for the purposes of this playground
    public func simulate() {
        // Make every logic element in the circuit update its output. Repeat enough times
        // and eventually, the circuit should converge to a stable state.
        for _ in 0..<elements.count {
            elements.forEach {
                $0.compute()
            }
        }
        // Redraw elements. Some element such as lights and switches can be drawn
        // differently depending on state
        elements.forEach {
            $0.setNeedsDisplay()
        }
        // Draw wires
        self.setNeedsDisplay()
    }

    public override func draw(_ rect: CGRect) {
        // Clear view
        self.backgroundColor?.setFill()
        UIBezierPath(rect: rect).fill()
        // Draw dots in a square grid
        UIColor.white.withAlphaComponent(0.5).setFill()
        var y: CGFloat = 0
        while y<bounds.width {
            y += spacing
            var x: CGFloat = 0
            while x<bounds.width {
                x += spacing
                let dot = CGRect(x: x-1, y:y-1, width: 2, height: 2)
                UIBezierPath(ovalIn: dot).fill()
            }
        }
        // Draw all wires
        for wire in connections {
            // Ensure the wire has a valid signal, and that its pins hold a reference to
            // the modules they belong in
            if let signal = wire.signal,
                let a = wire.a.module,
                let b = wire.b.module {
                // The wire is drawn with a cubic curve so that it follows the pin direction
                // when it connects with the modules
                let start = a.frame.origin + wire.a.position
                let end = b.frame.origin + wire.b.position
                let startControlPoint = start + wire.a.direction.bezierVector(length: 60)
                let endControlPoint = end + wire.b.direction.bezierVector(length: 60)
                // We draw the wire twice with different widths and colours to create a
                // "stroke" effect

                let strokePath = UIBezierPath()
                strokePath.lineWidth = 6
                strokePath.move(to: start)
                strokePath.addCurve(to: end, controlPoint1: startControlPoint, controlPoint2: endControlPoint)
                self.backgroundColor?.setStroke()
                strokePath.stroke()

                let path = UIBezierPath()
                path.lineWidth = 4
                path.move(to: start)
                path.addCurve(to: end, controlPoint1: startControlPoint, controlPoint2: endControlPoint)
                // Colour the wire in green if its signal is high, otherwise colour in white
                (signal.value ? UIColor.green : UIColor.white).setStroke()
                path.stroke()
            }
        }


    }
}
