import UIKit

public class Gate: Module {
    public var symbol: UIImage? {
        return nil
    }
    public override var size: CGSize {
        return CGSize(width: 75, height: 60)
    }
    public override var centerPoint: CGPoint {
        return CGPoint(x: 0, y: 10)
    }
    public let a = Pin(position: CGPoint(x:5, y: 10), direction: .left)
    public let b = Pin(position: CGPoint(x:5, y: 50), direction: .left)
    public let y = Pin(position: CGPoint(x:72, y:30), direction: .right)
    public override init(circuit: Circuit, position: CGPoint) {
        super.init(circuit: circuit, position: position)
        self.image = self.symbol
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
public class Not: Module {
    public override var size: CGSize {
        return CGSize(width: 75, height: 60)
    }
    public override var centerPoint: CGPoint {
        return CGPoint(x: 0, y: 10)
    }
    public let input = Pin(position: CGPoint(x:10, y: 30), direction: .left)
    public let out = Pin(position: CGPoint(x:72, y:30), direction: .right)
    public override init(circuit: Circuit, position: CGPoint) {
        super.init(circuit: circuit, position: position)
        self.image = gateImage(type: .not, negated: true)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func compute() {
        out.state = !input.state
    }

}
public class AndGate: Gate {
    public override var symbol: UIImage? {
        return gateImage(type: .and, negated: false)
    }
    public override func compute() {
        y.state = a.state && b.state
    }
}
public class NandGate: Gate {
    public override var symbol: UIImage? {
        return gateImage(type: .and, negated: true)
    }
    public override func compute() {
        y.state = !(a.state && b.state)
    }
}
public class OrGate: Gate {
    public override var symbol: UIImage? {
        return gateImage(type: .or, negated: false)
    }
    public override func compute() {
        y.state = a.state || b.state
    }
}
public class NorGate: Gate {
    public override var symbol: UIImage? {
        return gateImage(type: .or, negated: true)
    }

    public override func compute() {
        y.state = !(a.state || b.state)
    }
}
public class XnorGate: Gate {
    public override var symbol: UIImage? {
        return gateImage(type: .xor, negated: true)
    }

    public override func compute() {
        y.state = !(a.state != b.state)
        self.setNeedsDisplay()
    }
}
public class XorGate: Gate {
    public override var symbol: UIImage? {
        return gateImage(type: .xor, negated: false)
    }

    public override func compute() {
        y.state = a.state != b.state
        self.setNeedsDisplay()
    }
}
