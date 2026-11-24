import PlaygroundSupport
import Foundation
import UIKit
import AVFoundation

class MainView: UIView {
    var board: Board!
    var emojiLabel: UILabel!
    
    var startButton: UIButton!
    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var firstStory = false
    var secondStory = false
    var thirdStory = false
    
    var circutElements1: [Element] = []
    var circutElements2: [Element] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        board = Board(frame: CGRect(x: 0, y: 0, width: 434, height: 400))
        self.addSubview(board)
        
        let storyView = UIView(frame: CGRect(x: 0, y: 400, width: self.frame.size.width, height: 200))
        storyView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        
        emojiLabel = UILabel(frame: CGRect(x: 60, y: 50, width: 1090, height: 100))
        
        emojiLabel.font = UIFont.systemFont(ofSize: 80.0)
        emojiLabel.text = "🙂"
        storyView.addSubview(emojiLabel)
        self.addSubview(storyView)
        
        startButton = UIButton(frame: CGRect(x: 200, y: 80, width: 100, height: 60))
        startButton.setTitle("Start", for: .normal)
        startButton.tintColor = UIColor.blue
        startButton.addTarget(self, action: #selector(MainView.startStory), for: .touchUpInside)
        
        storyView.addSubview(startButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareScene1() {
        let source = Source(voltage: 5)
        source.position = CGPoint(x: 180, y: 120)
        
        let diode = Diode(color: UIColor.green.cgColor)
        diode.position = CGPoint(x: 185, y: 300)
        
        let switcher = Switcher()
        switcher.position = CGPoint(x: 320, y: 190)
        
        let wire1 = Wire(beginPoint: source.outputPoint, endPoint: switcher.inputPoint)
        let wire2 = Wire(endPoint: switcher.outputPoint, beginPoint: diode.inputPoint)
        let wire3 = Wire(beginPoint: diode.outputPoint, distance: 100, endPoint: source.inputPoint)
        
        
        board.addElement(element: diode)
        
        board.addElement(element: wire1)
        board.addElement(element: wire2)
        board.addElement(element: wire3)
        board.addElement(element: switcher)
        
        board.addElement(element: source)
        
        
        //board.reloadCircuts()
        
    }
    
    func prepareScene2() {
        let source = Source(voltage: 12)
        source.position = CGPoint(x: 180, y: 120)
        
        let crossSwitcher = CrossSwitcher()
        crossSwitcher.position = CGPoint(x: 120, y: 300)
        
        let resistor1 = Resistor(resistance: 100)
        resistor1.position = CGPoint(x: 170, y: 285)
        
        let resistor2 = Resistor(resistance: 10000)
        resistor2.position = CGPoint(x: 170, y: 315)
        
        let wire1 = Wire(beginPoint: source.outputPoint, distance: 350, endPoint: CGPoint(x: 320, y: 300))
        let wire2 = Wire(endPoint: CGPoint(x: 320, y: 300), beginPoint: resistor2.inputPoint)
        let wire3 = Wire(endPoint: CGPoint(x: 320, y: 300), beginPoint: resistor1.inputPoint)
        let wire4 = Wire(beginPoint: crossSwitcher.inputPoint, distance: 100, endPoint: source.inputPoint)
        
        board.addElement(element: wire1)
        board.addElement(element: wire2)
        board.addElement(element: wire3)
        board.addElement(element: wire4)
        
        board.addElement(element: crossSwitcher)
        board.addElement(element: resistor1)
        board.addElement(element: resistor2)
        
        board.addElement(element: source)
        
        circutElements1 = [source, wire1, wire2, resistor2, crossSwitcher, wire4]
        circutElements2 = [source, wire1, wire3, resistor1, crossSwitcher, wire4]
        
        board.resistance = resistor2.resistance
        board.addCircut(elements: circutElements1, discharge: false)
    }
    
    func prepareScene3() {
        let source = Source(voltage: 48)
        source.position = CGPoint(x: 180, y: 120)
        
        let capacitor = Capacitor(farad: 100)
        capacitor.position = CGPoint(x: 180, y: 250)
        
        let switcher = Switcher()
        switcher.position = CGPoint(x: 320, y: 150)
        
        let resistor = Resistor(resistance: 100)
        resistor.position = CGPoint(x: 170, y: 350)
        
        let wire1 = Wire(beginPoint: source.outputPoint, endPoint: switcher.inputPoint)
        let wire2 = Wire(endPoint: switcher.outputPoint, beginPoint: capacitor.inputPoint)
        let wire3 = Wire(beginPoint: capacitor.outputPoint, distance: 100, endPoint: source.inputPoint)
        let wire4 = Wire(beginPoint: capacitor.inputPoint, distance: 320, endPoint: resistor.inputPoint)
        let wire5 = Wire(beginPoint: resistor.outputPoint, distance: 100, endPoint: capacitor.outputPoint)
        
        board.addElement(element: wire1)
        board.addElement(element: wire2)
        board.addElement(element: wire3)
        board.addElement(element: wire4)
        board.addElement(element: wire5)
        
        board.addElement(element: resistor)
        board.addElement(element: capacitor)
        board.addElement(element: switcher)
        
        board.addElement(element: source)
        
        circutElements1 = [source, wire1, switcher, wire2, capacitor, wire3]
        circutElements2 = [capacitor, wire4, resistor, wire5]
    }
    
    func removeScene() {
        board.removeAllElements()
    }
    
    @objc func startStory() {
        startButton.isHidden = true
        
        let speechUtterance = AVSpeechUtterance(string: "Hi! My name is Peter and I want to tell you a story about your well done job! Many years ago young boy started to learn how he can talk with his computer. It was not easy for 13 years old guy who did not know English. Some day his uncle brings first iPhone and from that time small light bubble shine in his head! Come on, turn the light on!")
        
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.pitchMultiplier = 1.0
        speechUtterance.volume = 1.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        speechSynthesizer.speak(speechUtterance)
        
        let text = "😀😗🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😀🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀🙂🙂😀😗😮😗😀😮😗😮😗😀😮😗😮😗😀😮😗😮🙂🙂😀😗😮😗😀😮😗😮😗😀😮😗😮😗😀😮😗😮😗😀😮😗😀🙂🙂😀😮🙂🙂😀😮😗😮🙂🙂😉😉🙂"
        
        emojiLabel.setTextWithTypeAnimation(typedText: text, characterInterval: 0.14, completed: {
            NotificationCenter.default.addObserver(self, selector: #selector(MainView.buttonPressed), name: NSNotification.Name(rawValue: "button_pressed"), object: nil)
            self.board.switchButton.isEnabled = true
            
            self.board.descriptionLabel.text = "Close the circut by tapping on the switcher."
        })
    }
    
    @objc func buttonPressed() {
        if firstStory {return}
        firstStory = true
        
        self.board.descriptionLabel.text = "The closed circuit supplies a diode that lights up!"
        
        let speechUtterance = AVSpeechUtterance(string: "Well done! With this great idea the boy started to research how he can get his first iPhone. When he had got 16 the iPhone has its first premiere in Poland. Unfortunately it was too expensive for youth person. He build in his head the plan how to get it. Some jobs and teenage work brings his dreams to reality. Change his flow and bring him more energy!")
        
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.pitchMultiplier = 1.0
        speechUtterance.volume = 1.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        speechSynthesizer.speak(speechUtterance)
        
        let text = "😀😗🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😀🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀🙂🙂😀😗😮😗😀😮😗😮😗😀😮😗😮😗😀😮😗😮🙂🙂😀😗😮😗😀😮😗😮😗😀😮😗😮😗😀😮😗😮😗😀😮😗😀🙂🙂😀😮🙂🙂😀😮😗😮🙂🙂😉😉🙂"
        
        emojiLabel.setTextWithTypeAnimation(typedText: text, characterInterval: 0.14, completed: {
            NotificationCenter.default.addObserver(self, selector: #selector(MainView.crossButtonPressed), name: NSNotification.Name(rawValue: "cross_button_pressed"), object: nil)
            self.board.crossswitchButton.isEnabled = true
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: {
            self.removeScene()
            self.board.descriptionLabel.text = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.board.addScene {
                    self.prepareScene2()
                }
            })
        })
    }
    
    @objc func crossButtonPressed() {
        board.removeCircuts()
        
        self.board.descriptionLabel.text = "The resistor reduces the current in the circuit."
        
        if board.crossSwitcher!.isOn {
            board.addCircut(elements: circutElements1, discharge: false)
        } else {
            board.addCircut(elements: circutElements2, discharge: false)
        }
        
        if secondStory {return}
        secondStory = true
        
        let speechUtterance = AVSpeechUtterance(string: "Wow, its fast as a speed of light! Young dreams was moved on the new device. After first WWDC online conference and Xcode presentation he bought first Mac to start communicate with his phone. By many years the programming skills were growing up but not only that. Language, research and curiosity brings him to another level of self-improvement. A former shy boy became Chairman of International Matters Committee in the Students Union to represent his University in Europe and around the world. It begains from one dream that powered by the one company changed not only a knowledge. Lets do it! Charge his brain!")
        
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.pitchMultiplier = 1.0
        speechUtterance.volume = 1.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        speechSynthesizer.speak(speechUtterance)
        
        let text = "😁😂😂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😀🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀🙂🙂😀😗🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😀🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀🙂🙂😀😗🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😀🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀🙂🙂😀😗😮😗😀😮😗😮😗😀😮😗😮😗😀😮😗😮🙂🙂😀😗😮😗😀😮😗😮😗🙂🙂😮😗😮😗😮😗🙂🙂😜😜🙂"
        
        emojiLabel.setTextWithTypeAnimation(typedText: text, characterInterval: 0.14, completed: {
            NotificationCenter.default.addObserver(self, selector: #selector(MainView.switchPressed), name: NSNotification.Name(rawValue: "switch_story3_pressed"), object: nil)
            self.board.switchButton.isEnabled = true
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 14, execute: {
            self.removeScene()
            self.board.descriptionLabel.text = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.board.addScene {
                    self.prepareScene3()
                }
            })
        })
    }
    
    @objc func switchPressed() {
        if !firstStory {return}
        board.removeCircuts()
        
        if board.switcher!.isOn {
            board.addCircut(elements: circutElements1, discharge: true)
            
            for circut in board.circuts {
                circut.animation.speed = 0.1
            }
        } else {
            board.addCircut(elements: circutElements2, discharge: true)
            for circut in board.circuts {
                circut.animation.speed = 0.5
            }
        }
        
        if thirdStory {return}
        thirdStory = true
        
        self.board.descriptionLabel.text = "Capacitor collect the energy and share it with elements."
        
        let speechUtterance = AVSpeechUtterance(string: "Time is passing quickly but I am proud from myself, that this small boy that stays in Me to today, helps me on the beginning of my adult life. It began from the passion that was a programming, it push me to learn languages, not only that devide one. It took me to unknown world. I want to thank you for this amazing job that You had done in my life!")
        
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.pitchMultiplier = 1.0
        speechUtterance.volume = 1.0
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        speechSynthesizer.speak(speechUtterance)
        
        let text = "😁😂🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😀🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀🙂🙂😀😗🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😀🙂🙂😗😀😗😮😗😀😗😮😗😀😗😮😗😀😗😮😗😀🙂😀😗😀😗😮😗🙂"
        
        emojiLabel.setTextWithTypeAnimation(typedText: text, characterInterval: 0.14, completed: {})
    }
}

class Board: UIView {
    var elements: [Element] = []
    var circuts: [Circut] = []
    var circutLayers: [CAShapeLayer] = []
    
    var voltage: CGFloat = 0.0
    var resistance: CGFloat = 0.0
    
    var idCounter = 0
    
    var crossSwitcher: CrossSwitcher?
    var switcher: Switcher?
    var led: Diode?
    
    var descriptionLabel = UILabel()
    var switchButton = UIButton()
    var crossswitchButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.803921580314636, green: 0.803921580314636, blue: 0.803921580314636, alpha: 1.0)
        
        descriptionLabel = UILabel(frame: CGRect(x: 0, y: frame.size.height - 30, width: frame.size.width, height: 20))
        descriptionLabel.textAlignment = .center
        descriptionLabel.minimumScaleFactor = 0.5
        self.addSubview(descriptionLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCircut(elements: [Element], discharge: Bool) {
        
        if discharge {
            let source = self.findElementFor(tag: 5)
            let circut = Circut(source: source as! Source, onBoard: self, elements: elements)
            circut.isWorking = true
            circuts.append(circut)
            
            circutLayers.append(circut.circutDischargeShape(voltage: voltage, ohm: resistance))
            self.layer.addSublayer(circutLayers.last!)
        } else {
            let source = self.findElementFor(tag: 5)
            let circut = Circut(source: source as! Source, onBoard: self, elements: elements)
            circut.isWorking = true
            circuts.append(circut)
            
            circutLayers.append(circut.circutShape(voltage: voltage, ohm: resistance))
            self.layer.addSublayer(circutLayers.last!)
        }
    }
    
    func addElement(element: Element) {
        element.id = idCounter
        idCounter += 1
        
        elements.append(element)
        self.layer.addSublayer(element.symbol)
        
        if element.tag == 5 {
            self.voltage = (element as! Source).voltage
            let circut = Circut(source: element as! Source, onBoard: self)
            circuts.append(circut)
            
            circutLayers.append(circut.circutShape(voltage: voltage, ohm: resistance))
            self.layer.addSublayer(circutLayers.last!)
            
            let label = UILabel(frame: CGRect(x: element.position.x , y: element.position.y - 40, width: 80, height: 20))
            label.text = "\(self.voltage)[V]"
            self.addSubview(label)
            
        } else if element.tag == 3 {
            self.resistance = (element as! Resistor).resistance
            
            let label = UILabel(frame: CGRect(x: element.position.x + 13 , y: element.position.y - 10, width: 44, height: 20))
            label.text = "\(Int(self.resistance))[Ω]"
            label.font = UIFont.systemFont(ofSize: 9.0)
            label.textAlignment = .center
            
            self.addSubview(label)
        } else if element.tag == 6 {
            switcher = element as? Switcher
            
            switchButton = UIButton(frame: CGRect(x: element.position.x - 10, y: element.position.y, width: 20, height: 60))
            switchButton.addTarget(self, action: #selector(Board.switcherPressed), for: .touchUpInside)
            switchButton.isEnabled = false
            self.addSubview(switchButton)
        } else if element.tag == 4 {
            led = element as? Diode
        } else if element.tag == 8 {
            crossSwitcher = element as? CrossSwitcher
            
            crossswitchButton = UIButton(frame: CGRect(x: element.position.x, y: element.position.y - 20, width: 40, height: 60))
            crossswitchButton.addTarget(self, action: #selector(Board.crossSwitcherPressed), for: .touchUpInside)
            crossswitchButton.isEnabled = false
            self.addSubview(crossswitchButton)
        }
    }
    
    func addScene(scene: () -> Void) {
        let shadowView = UIView(frame: self.bounds)
        shadowView.backgroundColor = #colorLiteral(red: 0.803921580314636, green: 0.803921580314636, blue: 0.803921580314636, alpha: 1.0)
        shadowView.alpha = 1.0
        self.addSubview(shadowView)
        
        scene()
        
        UIView.animate(withDuration: 0.5, animations: {
            shadowView.alpha = 0.0
        })
    }
    
    func removeAllElements() {
        let shadowView = UIView(frame: self.bounds)
        shadowView.backgroundColor = #colorLiteral(red: 0.803921580314636, green: 0.803921580314636, blue: 0.803921580314636, alpha: 1.0)
        shadowView.alpha = 0.0
        self.addSubview(shadowView)
        
        UIView.animate(withDuration: 0.25, animations: {
            shadowView.alpha = 1.0
        }, completion: {
            success in
            
            for layer in self.circutLayers {
                layer.removeFromSuperlayer()
            }
            
            for element in self.elements {
                element.symbol.removeFromSuperlayer()
            }
            
            for view in self.subviews{
                
                if view != self.descriptionLabel {
                    view.removeFromSuperview()
                }
            }
        })
        
        
    }
    
    func findElementFor(tag: Int) -> Element {
        for element in elements {
            if element.tag == tag {
                return element
            }
        }
        return Element()
    }
    
    func findConnectedElementFor(point:CGPoint, element: Element) -> Element {
        for object in elements {
            
            if object !== element && (object.inputPoint == point || object.outputPoint == point) {
                return object
            }
        }
        return Element()
    }
    
    func reloadCircuts() {
        removeCircuts()
        
        for circut in circuts {
            circut.reload()
            
            if circut.isWorking {
                circutLayers.append(circut.circutShape(voltage: voltage, ohm: resistance))
                self.layer.addSublayer(circutLayers.last!)
            }
        }
    }
    
    func removeCircuts() {
        for layer in circutLayers {
            layer.removeFromSuperlayer()
        }
        
        circutLayers = []
    }
    
    @objc func switcherPressed() {
        switcher!.isOn = !switcher!.isOn
        led?.isOn = switcher!.isOn
        
        for circut in circuts {
            circut.isWorking = switcher!.isOn
        }
        
        if switcher!.isOn {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "button_pressed"), object: nil)
        }
        
        reloadCircuts()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "switch_story3_pressed"), object: nil)
        
    }
    
    @objc func crossSwitcherPressed() {
        crossSwitcher!.isOn = !crossSwitcher!.isOn
        
        if crossSwitcher!.isOn {
            self.resistance = 10000
        } else {
            self.resistance = 0.1
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cross_button_pressed"), object: nil)
    }
}

class Element {
    
    var id = 0
    var tag = 0
    
    var inputPoint: CGPoint!
    var outputPoint: CGPoint!
    
    var symbol: CAShapeLayer!
    var position = CGPoint.zero {
        didSet {
            symbol.frame.origin = position
            inputPoint = CGPoint(x: inputPoint.x + position.x, y: inputPoint.y + position.y)
            outputPoint = CGPoint(x: outputPoint.x + position.x, y: outputPoint.y + position.y)
        }
    }
    
    init() {
        self.symbol = CAShapeLayer()
        tag = -1
    }
    
    init(symbol: CAShapeLayer) {
        self.symbol = symbol
        self.symbol.fillColor = nil
        self.symbol.strokeColor = UIColor.black.cgColor
        self.symbol.lineWidth = 4.0
    }
}

class Wire: Element {
    init(beginPoint: CGPoint, endPoint: CGPoint) {
        let wire = CAShapeLayer()
        let wirePath = UIBezierPath()
        
        wirePath.move(to: beginPoint)
        wirePath.addLine(to: CGPoint(x: endPoint.x, y: beginPoint.y))
        wirePath.addLine(to: endPoint)
        
        wire.path = wirePath.cgPath
        
        super.init(symbol: wire)
        self.inputPoint = beginPoint
        self.outputPoint = endPoint
        self.tag = 1
    }
    
    init(endPoint: CGPoint, beginPoint: CGPoint) {
        let wire = CAShapeLayer()
        let wirePath = UIBezierPath()
        
        wirePath.move(to: endPoint)
        wirePath.addLine(to: CGPoint(x: endPoint.x, y: beginPoint.y))
        wirePath.addLine(to: beginPoint)
        
        wire.path = wirePath.cgPath
        
        super.init(symbol: wire)
        self.inputPoint = beginPoint
        self.outputPoint = endPoint
        self.tag = 1
    }
    
    init(beginPoint: CGPoint, distance: CGFloat, endPoint: CGPoint) {
        let wire = CAShapeLayer()
        let wirePath = UIBezierPath()
        
        wirePath.move(to: beginPoint)
        wirePath.addLine(to: CGPoint(x: distance, y: beginPoint.y))
        wirePath.addLine(to: CGPoint(x: distance, y: endPoint.y))
        wirePath.addLine(to: endPoint)
        
        wire.path = wirePath.cgPath
        super.init(symbol: wire)
        self.inputPoint = beginPoint
        self.outputPoint = endPoint
        self.tag = 1
    }
}

class Source: Element {
    var voltage: CGFloat = 5
    
    init(voltage: CGFloat) {
        let sourceSymbol = CAShapeLayer()
        let sourcePath = UIBezierPath()
        
        sourcePath.move(to: CGPoint(x: 0.0, y: 0.0))
        sourcePath.addLine(to: CGPoint(x: 20.0, y: 0))
        sourcePath.move(to: CGPoint(x: 20.0, y: -10.0))
        sourcePath.addLine(to: CGPoint(x: 20.0, y: 10.0))
        sourcePath.move(to: CGPoint(x: 30.0, y: -16.0))
        sourcePath.addLine(to: CGPoint(x: 30.0, y: 16.0))
        sourcePath.move(to: CGPoint(x: 30.0, y: 0.0))
        sourcePath.addLine(to: CGPoint(x: 50.0, y: 0.0))
        
        sourceSymbol.path = sourcePath.cgPath
        
        super.init(symbol: sourceSymbol)
        
        self.tag = 5
        self.voltage = voltage
        inputPoint = CGPoint(x: 0, y: 0)
        outputPoint = CGPoint(x: 50, y: 0)
    }
}

class Resistor: Element {
    var resistance: CGFloat = 0
    
    init(resistance: CGFloat) {
        let resistorSymbol = CAShapeLayer()
        let resistorPath = UIBezierPath()
        
        resistorPath.move(to: CGPoint(x: 0.0, y: 0.0))
        resistorPath.addLine(to: CGPoint(x: 10.0, y: 0))
        resistorPath.addLine(to: CGPoint(x: 10.0, y: 10.0))
        resistorPath.addLine(to: CGPoint(x: 60.0, y: 10.0))
        resistorPath.addLine(to: CGPoint(x: 60.0, y: -10.0))
        resistorPath.addLine(to: CGPoint(x: 10.0, y: -10.0))
        resistorPath.addLine(to: CGPoint(x: 10.0, y: 0))
        resistorPath.move(to: CGPoint(x: 60.0, y: 0.0))
        resistorPath.addLine(to: CGPoint(x: 70.0, y: 0))
        
        resistorSymbol.path = resistorPath.cgPath
        
        super.init(symbol: resistorSymbol)
        self.resistance = resistance
        inputPoint = CGPoint(x: 70, y: 0)
        outputPoint = CGPoint(x: 0, y: 0)
        self.tag = 3
    }
}

class Switcher: Element {
    var isOn = false {
        didSet {
            if isOn {
                let switcherPath = UIBezierPath()
                switcherPath.move(to: CGPoint(x: 0.0, y: 0.0))
                switcherPath.addLine(to: CGPoint(x: 0.0, y: 50.0))
                
                self.symbol.path = switcherPath.cgPath
            } else {
                let switcherPath = UIBezierPath()
                
                switcherPath.move(to: CGPoint(x: 0.0, y: 0.0))
                switcherPath.addLine(to: CGPoint(x: 0.0, y: 10.0))
                switcherPath.addLine(to: CGPoint(x: 15.0, y: 40.0))
                switcherPath.move(to: CGPoint(x: 0.0, y: 40.0))
                switcherPath.addLine(to: CGPoint(x: 0.0, y: 50.0))
                
                self.symbol.path = switcherPath.cgPath
            }
        }
    }
    
    override init() {
        let switcherSymbol = CAShapeLayer()
        let switcherPath = UIBezierPath()
        
        switcherPath.move(to: CGPoint(x: 0.0, y: 0.0))
        switcherPath.addLine(to: CGPoint(x: 0.0, y: 10.0))
        switcherPath.addLine(to: CGPoint(x: 15.0, y: 40.0))
        switcherPath.move(to: CGPoint(x: 0.0, y: 40.0))
        switcherPath.addLine(to: CGPoint(x: 0.0, y: 50.0))
        
        switcherSymbol.path = switcherPath.cgPath
        
        super.init(symbol: switcherSymbol)
        inputPoint = CGPoint(x: 0.0, y: 0.0)
        outputPoint = CGPoint(x: 0.0, y: 50.0)
        
        self.tag = 6
    }
}

class Diode: Element {
    
    var lightColor: CGColor!
    var isOn = false {
        didSet {
            if isOn {
                self.symbol.fillColor = lightColor
                self.symbol.strokeColor = UIColor.black.cgColor
                self.symbol.lineWidth = 4.0
            } else {
                self.symbol.fillColor = nil
                self.symbol.strokeColor = UIColor.black.cgColor
                self.symbol.lineWidth = 4.0
            }
        }
    }
    
    init(color: CGColor) {
        lightColor = color
        
        let diodeSymbol = CAShapeLayer()
        let diodePath = UIBezierPath()
        
        diodePath.addArc(withCenter: CGPoint(x: 20.0, y: 0.0), radius: 20.0, startAngle: 0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        
        diodeSymbol.path = diodePath.cgPath
        
        super.init(symbol: diodeSymbol)
        self.tag = 4
        inputPoint = CGPoint(x: 40.0, y: 0.0)
        outputPoint = CGPoint(x: 0.0, y: 0.0)
    }
}

class CrossSwitcher: Element {
    var isOn = true {
        didSet {
            if isOn {
                let switcherPath = UIBezierPath()
                
                switcherPath.move(to: CGPoint(x: 0.0, y: 0.0))
                switcherPath.addLine(to: CGPoint(x: 10.0, y: 0.0))
                switcherPath.addLine(to: CGPoint(x: 40.0, y: 15.0))
                switcherPath.move(to: CGPoint(x: 40.0, y: 15.0))
                switcherPath.addLine(to: CGPoint(x: 50.0, y: 15.0))
                switcherPath.move(to: CGPoint(x: 40.0, y: -15.0))
                switcherPath.addLine(to: CGPoint(x: 50.0, y: -15.0))
                
                self.symbol.path = switcherPath.cgPath
            } else {
                let switcherPath = UIBezierPath()
                
                switcherPath.move(to: CGPoint(x: 0.0, y: 0.0))
                switcherPath.addLine(to: CGPoint(x: 10.0, y: 00.0))
                switcherPath.addLine(to: CGPoint(x: 40.0, y: -15.0))
                switcherPath.move(to: CGPoint(x: 40.0, y: 15.0))
                switcherPath.addLine(to: CGPoint(x: 50.0, y: 15.0))
                switcherPath.move(to: CGPoint(x: 40.0, y: -15.0))
                switcherPath.addLine(to: CGPoint(x: 50.0, y: -15.0))
                
                self.symbol.path = switcherPath.cgPath
            }
        }
    }
    
    var circutPath: UIBezierPath {
        let switcherPath = UIBezierPath()
        
        if isOn {
            switcherPath.move(to: CGPoint(x: 50.0 + position.x, y: 15.0 + position.y))
            switcherPath.addLine(to: CGPoint(x: 40.0 + position.x, y: 15.0 + position.y))
            switcherPath.addLine(to: CGPoint(x: 10.0 + position.x, y: 0.0 + position.y))
            switcherPath.addLine(to: CGPoint(x: 0.0 + position.x, y: 0.0 + position.y))
        } else {
            switcherPath.move(to: CGPoint(x: 50.0 + position.x, y: -15.0 + position.y))
            switcherPath.addLine(to: CGPoint(x: 40.0 + position.x, y: -15.0 + position.y))
            switcherPath.addLine(to: CGPoint(x: 10.0 + position.x, y: 0.0 + position.y))
            switcherPath.addLine(to: CGPoint(x: 0.0 + position.x, y: 0.0 + position.y))
        }
        
        return switcherPath
    }
    
    override init() {
        let switcherSymbol = CAShapeLayer()
        let switcherPath = UIBezierPath()
        
        switcherPath.move(to: CGPoint(x: 0.0, y: 0.0))
        switcherPath.addLine(to: CGPoint(x: 10.0, y: 0.0))
        switcherPath.addLine(to: CGPoint(x: 40.0, y: 15.0))
        switcherPath.move(to: CGPoint(x: 40.0, y: 15.0))
        switcherPath.addLine(to: CGPoint(x: 50.0, y: 15.0))
        switcherPath.move(to: CGPoint(x: 40.0, y: -15.0))
        switcherPath.addLine(to: CGPoint(x: 50.0, y: -15.0))

        switcherSymbol.path = switcherPath.cgPath
        
        super.init(symbol: switcherSymbol)
        inputPoint = CGPoint(x: 0.0, y: 0.0)
        outputPoint = CGPoint(x: 50.0, y: 00.0)
        
        self.tag = 8
    }
}

class Capacitor: Element {
    var capacity: CGFloat = 5
    
    init(farad: CGFloat) {
        let sourceSymbol = CAShapeLayer()
        let sourcePath = UIBezierPath()
        
        sourcePath.move(to: CGPoint(x: 00.0, y: 0.0))
        sourcePath.addLine(to: CGPoint(x: 20.0, y: 0))
        sourcePath.move(to: CGPoint(x: 20.0, y: -16.0))
        sourcePath.addLine(to: CGPoint(x: 20.0, y: 16.0))
        sourcePath.move(to: CGPoint(x: 30.0, y: -16.0))
        sourcePath.addLine(to: CGPoint(x: 30.0, y: 16.0))
        sourcePath.move(to: CGPoint(x: 30.0, y: 0.0))
        sourcePath.addLine(to: CGPoint(x: 50.0, y: 0.0))
        
        sourceSymbol.path = sourcePath.cgPath
        
        super.init(symbol: sourceSymbol)
        
        self.tag = 9
        self.capacity = farad
        inputPoint = CGPoint(x: 50, y: 0)
        outputPoint = CGPoint(x: 00, y: 0)
    }
}

class Circut {
    var elements: [Element] = []
    
    var board: Board!
    var source: Source
    
    var isWorking = false
    var amper: CGFloat = 0.0
    
    var animation = CABasicAnimation()
    
    init(source: Source, onBoard: Board) {
        self.board = onBoard
        self.source = source
        self.elements = onBoard.elements
        //self.reload()
    }
    
    init (source: Source, onBoard: Board, elements: [Element]) {
        self.board = onBoard
        self.source = source
        self.elements = elements
    }
    
    func testCircut() {
        let firstElement = elements.first
        
        for i in 1...elements.count {
            let element = board.findConnectedElementFor(point: elements[i].outputPoint, element: elements[i])
            
            if element.id == firstElement?.id {
                isWorking = true
            } else {
                isWorking = false
            }
        }
    }
    
    func reload() {
        let element = board.findConnectedElementFor(point: source.outputPoint, element: source)
        if element.tag == -1 { return }
        
        elements.append(element)
        
        for _ in 1 ... board.elements.count {
            let element = board.findConnectedElementFor(point: elements.last!.outputPoint, element: elements.last!)
            if element.tag == -1 { return }
            
            elements.append(element)
        }
        
        repeat {
            let element = board.findConnectedElementFor(point: elements.last!.outputPoint, element: elements.last!)
            if element.tag == -1 { return }
            
            elements.append(element)

        } while elements.last!.tag == 5
    }
    
    func circutShape(voltage: CGFloat, ohm: CGFloat) -> CAShapeLayer {
        if !isWorking { return CAShapeLayer()}
        
        let circutPath = UIBezierPath()
        let circutShape = CAShapeLayer()
        
        amper = CGFloat(1) - (voltage * 0.4347/ohm)

        for object in elements {
            if object.tag == 1 {
                let path = object.symbol.path
                circutPath.append(UIBezierPath(cgPath: path!))
            } else if object.tag == 8 {
                let path = (object as! CrossSwitcher).circutPath
                circutPath.append(UIBezierPath(cgPath: path.cgPath))
            } else {
                let path = UIBezierPath()
                path.move(to: object.inputPoint)
                path.addLine(to: object.outputPoint)
                circutPath.append(path)
            }
        }
        
        circutShape.path = circutPath.cgPath
        circutShape.fillColor = nil
        circutShape.strokeColor = UIColor.green.cgColor
        circutShape.lineWidth = 4.0
        circutShape.lineDashPattern = [8,8]
        
        animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = 0
        animation.toValue = circutShape.lineDashPattern?.reduce(0) {$0 - $1.intValue}
        animation.duration = CFTimeInterval(amper)
        animation.speed = 1.0
        animation.repeatCount = Float.greatestFiniteMagnitude
        
        circutShape.add(animation, forKey: nil)
        
        return circutShape
    }
    
    func circutDischargeShape(voltage: CGFloat, ohm: CGFloat) -> CAShapeLayer {
        if !isWorking { return CAShapeLayer()}
        
        let circutPath = UIBezierPath()
        let circutShape = CAShapeLayer()
        
        for object in elements {
            if object.tag == 1 {
                let path = object.symbol.path
                circutPath.append(UIBezierPath(cgPath: path!))
            } else if object.tag == 8 {
                let path = (object as! CrossSwitcher).circutPath
                circutPath.append(UIBezierPath(cgPath: path.cgPath))
            } else {
                let path = UIBezierPath()
                path.move(to: object.inputPoint)
                path.addLine(to: object.outputPoint)
                circutPath.append(path)
            }
        }
        
        circutShape.path = circutPath.cgPath
        circutShape.fillColor = nil
        circutShape.strokeColor = UIColor.green.cgColor
        circutShape.lineWidth = 4.0
        circutShape.lineDashPattern = [8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8]
        
        animation = CABasicAnimation(keyPath: "lineDashPhase")
        animation.fromValue = 0
        animation.toValue = circutShape.lineDashPattern?.reduce(0) {$0 - $1.intValue}
        animation.duration = CFTimeInterval(3.0)
        animation.speed = 1.0
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        circutShape.add(animation, forKey: nil)
        
        return circutShape
    }
}

extension UILabel {
    func setTextWithTypeAnimation(typedText: String, characterInterval: TimeInterval = 0.25, completed: @escaping () -> Void) {
        text = ""
        DispatchQueue.global(qos: .userInteractive).async {

            for (index, character) in typedText.enumerated() {
                DispatchQueue.main.async {
                    self.text = String(character)
                    
                    if index + 1 == typedText.count {
                        completed()
                    }
                }
                Thread.sleep(forTimeInterval: characterInterval)
            }
        }
    }
}

//Set Main View
let mainView = MainView(frame: CGRect(x: 0, y: 0, width: 434, height: 600))
PlaygroundPage.current.liveView = mainView
mainView.prepareScene1()
mainView.addConstraint(NSLayoutConstraint(item: mainView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 434))
mainView.addConstraint(NSLayoutConstraint(item: mainView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 600))




