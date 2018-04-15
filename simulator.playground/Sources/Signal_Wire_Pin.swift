import Foundation
import UIKit

/// Which way a pin of a componnent is facing
public enum PinDirection {
    case left
    case right
    case up
    case down
    case any
    func bezierVector(length x: CGFloat) -> CGPoint {
        switch (self) {
        case .left:
            return CGPoint(x: -x, y: 0)
        case .right:
            return CGPoint(x: x, y: 0)
        case .up:
            return CGPoint(x: 0, y: -x)
        case .down:
            return CGPoint(x: 0, y: x)
        case .any:
            return CGPoint(x: 0, y: 0)
        }
    }
}

/// A node in a circuit
public class Signal {
    public var value: Bool = false
    public init() {

    }
    public init(high state: Bool) {
        value = state
    }
}

/// A wire is a connection between pins of two elements in the circuit
public class Wire {
    public var signal: Signal?
    public var a: Pin
    public var b: Pin
    /// A wire from pin 'a' to pin 'b'
    init(a: Pin, b: Pin) {
        self.a = a
        self.b = b
    }
}

/// A pin represents an input/output of a module
public class Pin {
    /// The position of the pin in the logical element. (0, 0) indicates the pin is drawn
    /// at the origin, (30, 40) indicates the pin is that much away from the origin
    public var position: CGPoint
    /// The direction of the pin
    public var direction: PinDirection
    /// The signal the pin is attached to
    public var signal: Signal?
    /// The element the pin belongs to. This variable is set only after the element is
    /// added to a circuit
    public var module: Module!

    /// The logic state of the pin
    public var state: Bool {
        get {
            // If there is no signal attached, assume default low level
            return self.signal?.value ?? false
        }
        set(newState){
            signal?.value = newState
        }
    }
    /// A pin that is drawn 'position' away from the element origin, and that faces in the
    /// specified direction
    public init(position: CGPoint, direction: PinDirection) {
        self.position = position
        self.direction = direction
    }
}
