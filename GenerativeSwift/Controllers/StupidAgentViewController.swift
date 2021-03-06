//
//  StupidAgentViewController.swift
//  GenerativeSwift
//
//  Created by Tatsuya Tobioka on 4/21/16.
//  Copyright © 2016 tnantoka. All rights reserved.
//

import UIKit
import C4

class StupidAgentViewController: BaseCanvasController {
    var point = Point(0, 0)
    var x = 0.0
    var y = 0.0
    var timer: Foundation.Timer?
    
    var step: Double {
        return 1.0
    }
    let diameter = 1.0
    
    var startItem: UIBarButtonItem!
    var stopItem: UIBarButtonItem!

    override init() {
        super.init()
        title = "Stupid Agent"
        trash = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(start))
        stopItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(stop))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [flexible, startItem, flexible, stopItem, flexible]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
        stop()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stop()
    }
    
    override func setup() {
        let _ = canvas.addPanGestureRecognizer { locations, center, translation, velocity, state in
            self.point = center
        }
        clear()
    }

    func draw() {
        let speed = map(point.x, min: 0, max: canvas.width, toMin: 2, toMax: 100)
        var points = [Point]()
        (0..<Int(speed)).forEach { _ in
            let direction = Direction.random()
            switch direction {
            case .north:
                y -= step
            case .northEast:
                x += step
                y -= step
            case .east:
                x += step
            case .southEast:
                x += step
                y += step
            case .south:
                y += step
            case .southWest:
                x -= step
                y += step
            case .west:
                x -= step
            case .northWest:
                x -= step
                y -= step
            }
            
            if x > canvas.width - diameter {
                x = 0
            }
            if x < 0 {
                x = canvas.width
            }
            if y > canvas.height - diameter {
                y = 0
            }
            if y < 0 {
                y = canvas.height
            }
            
//            let circle = Circle(frame: Rect(x, y, diameter, diameter))
//            circle.strokeColor = nil
//            circle.fillColor = Color(UIColor(white: 0.0, alpha: 0.4))
//            canvas.add(circle)
            points.append(Point(x, y))
        }
        
        let polygon = CirclePolygon(points, Size(diameter, diameter))
        polygon.strokeColor = nil
        polygon.fillColor = Color(UIColor(white: 0.0, alpha: 0.4))
        canvas.add(polygon)
    }
    
    func start() {
        startItem.isEnabled = false
        stopItem.isEnabled = true

        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(draw), userInfo: nil, repeats: true)
    }
    
    func stop() {
        startItem.isEnabled = true
        stopItem.isEnabled = false

        timer?.invalidate()
    }
    
    override func clear() {
        super.clear()
        clearPoints()
    }
    
    func clearPoints() {
        point = canvas.center
        x = point.x
        y = point.y
    }
}
