//
//  ChildTableViewController.swift
//  HospitalMap real2
//
//  Created by 최지 on 02/06/2019.
//  Copyright © 2019 최지. All rights reserved.
//


import UIKit

class ChildTableViewcontroller: UITableViewController, XMLParserDelegate {
    
    @IBOutlet var tbData: UITableView!
    
    var url : String?
    
    var parser = XMLParser()
    
    var posts = NSMutableArray()
    
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var yadmNm = NSMutableString()
    var addr = NSMutableString()
    
    var XPos = NSMutableString()
    var YPos = NSMutableString()
    
    var for_qu_x = ""
    var for_qu_x_utf8 = ""
    var for_qu_y = ""
    var for_qu_y_utf8 = ""
    
    var Hpid = NSMutableString()
    
    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf:(URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        tbData!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])  {
        element = elementName as NSString
        if ( elementName as NSString).isEqual(to: "item"){
            elements = NSMutableDictionary()
            elements = [:]
            yadmNm = NSMutableString()
            yadmNm = ""
            addr = NSMutableString()
            addr = ""
            
            XPos = NSMutableString()
            XPos = ""
            YPos = NSMutableString()
            YPos = ""
            Hpid = NSMutableString()
            Hpid = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "dutyName"){
            yadmNm.append(string)
        }else if element.isEqual(to: "dutyAddr"){
            addr.append(string)
        }
            
        else if element.isEqual(to: "wgs84Lon"){
            XPos.append(string)
        }
        else if element.isEqual(to: "wgs84Lat"){
            YPos.append(string)
        }
        else if element.isEqual(to: "hpid"){
            Hpid.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName as NSString).isEqual(to: "item"){
            if !yadmNm.isEqual(nil){
                elements.setObject(yadmNm, forKey: "yadmNm" as NSCopying)
            }
            if !addr.isEqual(nil){
                elements.setObject(addr, forKey: "addr" as NSCopying)
            }
            
            if !XPos.isEqual(nil){
                elements.setObject(XPos, forKey: "XPos" as NSCopying)
            }
            if !YPos.isEqual(nil){
                elements.setObject(YPos, forKey: "YPos" as NSCopying)
            }
            if !Hpid.isEqual(nil){
                elements.setObject(Hpid, forKey: "hpid" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToMapView"{
            if let mapViewController = segue.destination as? MapViewController {
                mapViewController.posts = posts
            }
        }
        
        if segue.identifier == "segueToHospitalDetail"{
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                for_qu_x = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "XPos") as! NSString as String
                for_qu_y = (posts.object(at: (indexPath?.row)!) as AnyObject).value(forKey: "YPos") as! NSString as String
                for_qu_x_utf8 = for_qu_x.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                for_qu_y_utf8 = for_qu_y.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                
                if let detailChildTableViewController = segue.destination as? DetailChildTableViewController {
                    detailChildTableViewController.url = "http://apis.data.go.kr/B552657/HsptlAsembySearchService/getBabyLcinfoInqire?ServiceKey=9%2Fp4b%2Blim3NglmINIHv1qlKmh5A4VouFEu7pyqMAVrYzzJoIFNfM6w9t4nAd%2FHn9nIyvU3WusddtcbchFfHYiQ%3D%3D&WGS84_LON=" + for_qu_x_utf8 + "&WGS84_LAT=" + for_qu_y_utf8
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginParsing()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "yadmNm") as! NSString as String
        
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "addr") as! NSString as String
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
