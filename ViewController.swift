//
//  ViewController.swift
//  Color My Kicks
//
//  Created by Farhana Mustafa on 11/18/16.
//  Copyright © 2016 Farhana Mustafa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

@IBOutlet weak var mainImageView: UIImageView! //drawing so far
@IBOutlet weak var tempImageView: UIImageView! //currently drawing line

var lastPoint = CGPoint.zero
var red: CGFloat = 0.0
var green: CGFloat = 0.0
var blue: CGFloat = 0.0
var brushWidth: CGFloat = 10.0
var opacity: CGFloat = 1.0
var swiped = false
let jordan = UIImage(named: "Jordan.png")
let nike = UIImage(named: "Nike.png")
let adidas = UIImage(named: "Adidas.png")
  
let colors: [(CGFloat, CGFloat, CGFloat)] = [
    (0, 0, 0),
    (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
    (1.0, 0, 0),
    (0, 0, 1.0),
    (51.0 / 255.0, 204.0 / 255.0, 1.0),
    (102.0 / 255.0, 204.0 / 255.0, 0),
    (102.0 / 255.0, 1.0, 0),
    (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
    (1.0, 102.0 / 255.0, 0),
    (1.0, 1.0, 0),
    (1.0, 1.0, 1.0),
]

override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(patternImage: jordan!)
}

  //buttons

  @IBAction func reset(sender: AnyObject) {
    mainImageView.image = nil
  }

  func screenShotMethod() {
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
    }
    
  @IBAction func save(sender: UIButton) {
    
    UIGraphicsBeginImageContext(mainImageView.bounds.size)
    mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
          width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
    let layer = UIApplication.sharedApplication().keyWindow!.layer
    let scale = UIScreen.mainScreen().scale
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
    
    layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let screenshot = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    let activity = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
  }
  
  @IBAction func crayonPressed(sender: AnyObject) {
    
    var index = sender.tag ?? 0
    if index < 0 || index >= colors.count {
      index = 0
    }
    
    (red, green, blue) = colors[index]
    
    if index == colors.count - 1 {
      opacity = 1.0
    }
    else {
        opacity = 0.5
    }
  }
  
  @IBAction func jordan(button: UIButton) {
    mainImageView.image = nil
    view.backgroundColor = UIColor(patternImage: jordan!)
  }
    
  @IBAction func nike(button: UIButton) {
    mainImageView.image = nil
    view.backgroundColor = UIColor(patternImage: nike!)
  }
    
  @IBAction func adidas(button: UIButton) {
    mainImageView.image = nil
    view.backgroundColor = UIColor(patternImage: adidas!)
  }
    
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) { //when finger first touches screen
    swiped = false
    if let touch = touches.first {
      lastPoint = touch.locationInView(self.view)
    }
  }
  
  func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
    UIGraphicsBeginImageContext(view.frame.size)
    let context = UIGraphicsGetCurrentContext()
    tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
    CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
    CGContextSetLineCap(context, CGLineCap.Round)
    CGContextSetLineWidth(context, brushWidth)
    CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
    CGContextSetBlendMode(context, CGBlendMode.Normal)
    CGContextStrokePath(context)
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = opacity
    UIGraphicsEndImageContext()
  }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    swiped = true
    if let touch = touches.first{
      let currentPoint = touch.locationInView(view)
      drawLineFrom(lastPoint, toPoint: currentPoint)
      lastPoint = currentPoint
    }
  }
  
  override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {

    if !swiped {
      drawLineFrom(lastPoint, toPoint: lastPoint)
    }
    
    // Merge tempImageView into mainImageView
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
    tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    tempImageView.image = nil
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let settingsViewController = segue.destinationViewController as! SettingsViewController
    settingsViewController.delegate = self
    settingsViewController.brush = brushWidth
    settingsViewController.opacity = opacity
    settingsViewController.red = red
    settingsViewController.green = green
    settingsViewController.blue = blue
  }
  
}
extension ViewController: SettingsViewControllerDelegate {
  func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
    self.brushWidth = settingsViewController.brush
    self.opacity = settingsViewController.opacity
    self.red = settingsViewController.red
    self.green = settingsViewController.green
    self.blue = settingsViewController.blue
  }
}
