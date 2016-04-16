//
//  HelloFormViewController.swift
//  GenerativeSwift
//
//  Created by Tatsuya Tobioka on 4/16/16.
//  Copyright © 2016 tnantoka. All rights reserved.
//

import UIKit
import C4

class HelloFormViewController: BaseCanvasController {
    var form = [Shape]()
    var point = Point(0, 0)
    
    override init() {
        super.init()
        title = "Hello Form"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateCircle()
    }
    
    override func setup() {
        canvas.addPanGestureRecognizer { locations, center, translation, velocity, state in
            self.point = center
            self.updateCircle()
        }
        canvas.addTapGestureRecognizer { locations, center, state in
            self.point = center
            self.updateCircle()
        }
        self.point = Point(canvas.center.x, canvas.center.y * 0.4)
    }
    
    func updateCircle() {
        let circleResolution = Int(map(point.y, min: 64, max: canvas.height, toMin: 2, toMax: 80))
        let radius = point.x / 2 + 0.5
        let angle = M_PI * 2 / Double(circleResolution)
        createForm(circleResolution, radius: radius, angle: angle)
    }
    
    func createForm(circleResolution: Int, radius: Double, angle: Double) {
        for shape in form {
            shape.removeFromSuperview()
        }
        form = [Shape]()

        (0...circleResolution).forEach { i in
            let points = [canvas.center, circlePoint(i, angle: angle, radius: radius)]
            let line = Line(points)
            line.lineWidth = point.y / 20
            line.lineCap = .Square
            canvas.add(line)
            form.append(line)
        }
    }
    
    func circlePoint(i: Int, angle: Double, radius: Double) -> Point {
        let x = canvas.center.x + cos(angle * Double(i)) * radius
        let y = canvas.center.y + sin(angle * Double(i)) * radius
        return Point(x, y)
    }
}