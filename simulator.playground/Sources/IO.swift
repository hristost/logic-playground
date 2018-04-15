import UIKit


public enum LightColor {
    case yellow
    case green
    case red
}
public enum SwitchType {
    /// A toggle switch that is initially in `initialState`. A tap toggles state
    case toggle(initialState: Bool)
    /// A pushbutton switch. If `normallyOff`, the switch outputs a high signal when
    /// pressed, low signal when released. If `normallyOff` is false, the switch outputs a
    /// low signal then pressed and a high signal when released
    case pushbutton(normallyOff: Bool)
    /// A pushbutton switch. If `normallyOff`, the switch outputs a high signal when
    /// pressed, low signal when released. If `normallyOff` is false, the switch outputs a
    /// low signal then pressed and a high signal when released
    case large_pushbutton(normallyOff: Bool)
}
/// A light with one input `input` that turns on/off depending on the input logic level
public class Led: Module {
    var color: LightColor = .yellow
    /// A light with one input `input` that turns on/off depending on the input logic
    /// level. When on, it glows in the specified colour
    public convenience init(circuit: Circuit, position: CGPoint, color: LightColor) {
        self.init(circuit: circuit, position: position)
        self.color = color
    }
    public override var size: CGSize {
        return CGSize(width: 75, height: 75)
    }
    public let input = Pin(position: CGPoint(x:37.5, y:47.5), direction: .any)
    public override func compute() {
        // `Module` is an `UIImageView`, so we can just change the image accordingly
        if input.state {
            switch self.color {
            case .green:
                self.image = UIImage(named: "bulb_green")
            case .yellow:
                self.image = UIImage(named: "bulb_yellow")
            case .red:
                self.image = UIImage(named: "bulb_red")
            }
        } else {
            self.image = UIImage(named: "bulb_off")
        }
    }
}

/// A switch with one output `out` that changes state when the user taps on it
public class Switch: Module {
    public override var size: CGSize {
        return CGSize(width: 75, height: 75)
    }
    public let out = Pin(position: CGPoint(x:37.5, y:37.5), direction: .any)
    public var isOn: Bool = false
    public weak var circuit: Circuit!
    var switchType: SwitchType = .toggle(initialState: false)

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    /// A switch with one output `out` that changes state when the user taps on it
    public init(circuit: Circuit, position: CGPoint, type: SwitchType) {
        super.init(frame: .zero)
        self.frame = CGRect(origin: position, size: self.size)
        circuit.addElement(self)
        circuit.addSubview(self)
        self.isUserInteractionEnabled = true
        self.circuit = circuit
        self.switchType = type
        self.isOn = false
        if case .toggle(initialState: let state) = type {
            self.isOn = state
        }
    }
    public override func compute() {

        out.state = isOn

        switch self.switchType {
        case .toggle:
            self.image = isOn ? UIImage(named: "toggle_on") : UIImage(named: "toggle_off")
        case .large_pushbutton(normallyOff: let normallyOff):
            self.image = isOn ? UIImage(named: "button_big_on") : UIImage(named: "button_big_off")
            if !normallyOff {
                out.state = !isOn
            }
        case .pushbutton(normallyOff: let normallyOff):
            self.image = isOn ? UIImage(named: "button_small_on") : UIImage(named: "button_small_off")
            if !normallyOff {
                out.state = !isOn
            }
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch switchType {
        case .toggle:
            ()
        case .large_pushbutton, .pushbutton:
            self.isOn = true
            circuit.simulate()
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch switchType {
        case .toggle:
            isOn = !isOn
            circuit.simulate()
        case .large_pushbutton, .pushbutton:
            self.isOn = false
            circuit.simulate()
        }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
