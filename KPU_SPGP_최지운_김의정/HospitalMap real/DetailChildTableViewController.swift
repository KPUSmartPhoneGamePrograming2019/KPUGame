//
//  DetailChildTableViewController.swift
//  HospitalMap real2
//
//  Created by 최지 on 02/06/2019.
//  Copyright © 2019 최지. All rights reserved.
//

import UIKit

class DetailChildTableViewController: UITableViewController, XMLParserDelegate {
    
    @IBOutlet var detailTableView: UITableView!
    
    var url : String?
    
    var parser = XMLParser()
    
    let postsname : [String] = ["병원분류","병원분류명","기관명","대표전화","주소","시작시간","종료시간"]
    
    var posts : [String] = ["","","","","","",""]
    
    var element = NSString()
    
    var yadmNm = NSMutableString()
    var addr = NSMutableString()
    var telno = NSMutableString()
    var hospUrl = NSMutableString()
    var clCdNm = NSMutableString()
    var estbDd = NSMutableString()
    var drTotCnt = NSMutableString()
    
    
    func beginParsing(){
        posts = []
        parser = XMLParser(contentsOf:(URL(string:url!))!)!
        parser.delegate = self
        parser.parse()
        detailTableView!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item"){
            
            posts = ["","","","","","",""]
            
            yadmNm = NSMutableString()
            yadmNm = ""
            addr = NSMutableString()
            addr = ""
            
            telno = NSMutableString()
            telno = ""
            hospUrl = NSMutableString()
            hospUrl = ""
            clCdNm = NSMutableString()
            clCdNm = ""
            estbDd = NSMutableString()
            estbDd = ""
            drTotCnt = NSMutableString()
            drTotCnt = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "dutyDiv"){
            yadmNm.append(string)
        }else if element.isEqual(to: "dutyDivName"){
            addr.append(string)
        }else if element.isEqual(to: "dutyName"){
            telno.append(string)
        }else if element.isEqual(to: "dutyTel1"){
            hospUrl.append(string)
        }else if element.isEqual(to: "dutyAddr"){
            clCdNm.append(string)
        }else if element.isEqual(to: "startTime"){
            estbDd.append(string)
        }else if element.isEqual(to: "endTime"){
            drTotCnt.append(string)
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item"){
            if !yadmNm.isEqual(nil){
                posts[0] = yadmNm as String
            }
            if !addr.isEqual(nil){
                posts[1] = addr as String
            }
            if !telno.isEqual(nil){
                posts[2] = telno as String
            }
            if !hospUrl.isEqual(nil){
                posts[3] = hospUrl as String
            }
            if !clCdNm.isEqual(nil){
                posts[4] = clCdNm as String
            }
            if !estbDd.isEqual(nil){
                posts[5] = estbDd as String
            }
            if !drTotCnt.isEqual(nil){
                posts[6] = drTotCnt as String
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "HospitalCell", for: indexPath)
        cell.textLabel?.text = postsname[indexPath.row]
        cell.detailTextLabel?.text = posts[indexPath.row]
        // Configure the cell...
        
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
