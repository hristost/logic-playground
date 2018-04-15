import UIKit
/// A class that represents a logic element. Subclasses must define `size` - visual size
/// of the component, override `drawRect` for display logic, define inputs and outputs as
/// properties of type `Pin` and define logic by overriding `compute`
open class Module: UIImageView {
    /// The size of the element when displayed on screen, in pts
    open var size: CGSize {
        return .zero
    }
    open var centerPoint: CGPoint {
        return CGPoint(x: size.width/2, y: size.height/2)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public init(circuit: Circuit, position: CGPoint) {
        super.init(frame: .zero)
        self.frame = CGRect(origin: position, size: self.size)
        circuit.addElement(self)
        circuit.addSubview(self)
        self.isUserInteractionEnabled = true

    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Update output states
    open func compute() {

    }
}
