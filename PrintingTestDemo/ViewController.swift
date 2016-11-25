//
//  ViewController.swift
//  PrintingTestDemo
//
//  Created by appstudioz on 9/13/16.
//  Copyright © 2016 Pradeep. All rights reserved.Quartz
//

import UIKit




class ViewController: UIViewController,UIPrintInteractionControllerDelegate ,UITableViewDelegate,UITableViewDataSource{

    //MARK-*********** outlets *******************
    
    @IBOutlet weak var segmentControl:  UISegmentedControl!
    @IBOutlet weak var imageView:       UIImageView!
    @IBOutlet weak var tableView:       UITableView!

    var webView = UIWebView()

    //MARK-*********** view life cycle *******************
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView =  UIWebView(frame: CGRect(x: 0 , y: 70, width: self.view.frame.width  , height: self.view.frame.height-70))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    

    //MARK:-***********IBAction*******************

    
    @IBAction func btnClickedToMakePDF(sender: AnyObject) {
       makePDFIntoMultiplePages()
    }
    
    
    @IBAction func btnClicktoshowpdf(sender: AnyObject) {
       openPdf()
    }
    
    @IBAction func sendToPrinter(sender: AnyObject) {
        sendPrintImages()
    }
    

    
    
    //MARK:-*********** delegate for UIPrintInteractionController *******************

    
    func printInteractionControllerDidFinishJob(printInteractionController: UIPrintInteractionController){
        print("job finish")
        
        
    }
    
    func printInteractionControllerDidDismissPrinterOptions(printInteractionController: UIPrintInteractionController){
        
        print("diddismiss")
    }
    
    func printInteractionControllerWillStartJob(printInteractionController: UIPrintInteractionController){
        print("will start")
    }

    
    
    
    //MARK:-*********** functions *******************

    func sendPrintImages(){
        let url1 = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/testfilewnew.pdf")
        let data = NSData(contentsOfFile: url1)
        let printInteractionContrlObj  = UIPrintInteractionController.sharedPrintController()
        let printInfo = UIPrintInfo.printInfo()
        printInfo.jobName = "printclasstestdemo"
        printInfo.orientation = .Landscape
        printInfo.outputType = .Grayscale
        printInteractionContrlObj.printInfo = printInfo
        printInteractionContrlObj.delegate = self
        printInteractionContrlObj.printingItem = data
        printInteractionContrlObj.presentAnimated(true, completionHandler: nil)
        
    }

    
    func openPdf(){
        
        let url1 = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/testfilewnew.pdf")
        print(url1)
        let request = NSURLRequest(URL: NSURL(string: url1)!)
        webView.loadRequest(request)
        
        view.addSubview(webView)
    }
    
    
    
    
    func makePDFIntoMultiplePages (){//612 x 792 points
        
        let paperA4 = CGRect(x: -25, y: 0, width: 612, height: 792);
        let pageWithMargin = CGRect(x: 0, y: 0, width: paperA4.width-50, height: paperA4.height-50);
        
        let  fittedSize:CGSize = self.tableView.sizeThatFits(CGSizeMake(pageWithMargin.width, self.tableView.contentSize.height))
        self.tableView.bounds = CGRectMake(0, 0, fittedSize.width, fittedSize.height);
        
        let  pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, paperA4, nil)
        for var pageOriginY:CGFloat = 0; pageOriginY < fittedSize.height; pageOriginY += paperA4.size.height {
            UIGraphicsBeginPDFPageWithInfo(paperA4, nil);
            
            CGContextSaveGState(UIGraphicsGetCurrentContext());
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, -pageOriginY)
            
            self.tableView.layer.drawsAsynchronously = true
            
            self.tableView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            
        }
        UIGraphicsEndPDFContext();
        self.tableView.bounds = CGRectMake(0, 80, 320, 490)
        
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        let  pdfFileName = path.stringByAppendingPathComponent("testfilewnew.pdf")
        
        print(path)
        pdfData.writeToFile(pdfFileName, atomically: true)
        
    }
    
    
    // *************touches began*************

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        webView.removeFromSuperview()
    }
    

    
    
    //MARK:- *************tableView Delegate And datasource*************
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell1", forIndexPath: indexPath)
        let lbl = cell.viewWithTag(99) as! UILabel
        lbl.text = "cell number" + "\(indexPath.row)"
        return cell
        
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "header" + "\(section)"
    }
    
}

