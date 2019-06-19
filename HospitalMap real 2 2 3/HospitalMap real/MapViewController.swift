//
//  MapViewController.swift
//  HospitalMap real
//
//  Created by 최지 on 02/05/2019.
//  Copyright © 2019 최지. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController , MKMapViewDelegate{

    
    @IBOutlet weak var mapView1: MKMapView!
    var posts = NSMutableArray()
    var clinic_posts = NSMutableArray()
    
    // 이지역은 regionRadius 5000m의 거리에 따라 남북 및 동서에 걸쳐있을 것이다.
    let regionRadius: CLLocationDistance = 5000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView1.setRegion(coordinateRegion, animated: true)
    }
    
    var clinics : [Hospital] = []
    
    var hospitals : [Hospital] = []
    
    
    // 전송받은 posts배열에서 정보를 얻어서 hospital객체를 생성하고 배열에 추가생성
    func loadInitialData() {
        for post in clinic_posts {
            let yadmNm = (post as AnyObject).value(forKey: "clinic_yadmNm") as! NSString as String
            let addr = (post as AnyObject).value(forKey: "clinic_addr") as! NSString as String
            let XPos = (post as AnyObject).value(forKey: "clinic_XPos") as! NSString as String
            let YPos = (post as AnyObject).value(forKey: "clinic_YPos") as! NSString as String
            let lat = (YPos as NSString).doubleValue
            let lon = (XPos as NSString).doubleValue
            
            let clinic = Hospital(title: yadmNm, locationName: addr, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            clinics.append(clinic)
        }
        for post in posts {
            let yadmNm = (post as AnyObject).value(forKey: "yadmNm") as! NSString as String
            let addr = (post as AnyObject).value(forKey: "addr") as! NSString as String
            let XPos = (post as AnyObject).value(forKey: "XPos") as! NSString as String
            let YPos = (post as AnyObject).value(forKey: "YPos") as! NSString as String
            let lat = (YPos as NSString).doubleValue
            let lon = (XPos as NSString).doubleValue
            
            let hospital = Hospital(title: yadmNm, locationName: addr, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
            hospitals.append(hospital)
        }
    }
    
    // 사용자가 지도 주석 마커를 탭하면 설명 선에 info button이 표시
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Hospital
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    
    // 1.mapView는, tableView 테이블보기로 작업할 때와 마찬가지로 지도에 추가하는 모든 주석이 호출되어 각 주석에 대한 보기를 반환합니다.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2. 이 주석이 Hospital 객체 인지 확인! 그렇지안흥면 nil 지도뷰에서 기본 주석뷰를 사용하도록
        guard let annotation = annotation as? Hospital else {return nil}
        // 3. 마커가 나타나게 MKMarkerAnnotationView를 만듦
        // 이 자습서의 뒷부분에는 MKAnnotationView마커 대신 이미지를 표시하는 객체를 만듭니다.
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4.코드를 새로 생성하기 전에 재사용 가능한 주석 뷰를 사용할 수 있는지 먼저 확인
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5.MKMarkerAnnotationView 주석보기에서 대기열에서 삭제할 수 없는 경우 여기에서 새 객체를 만듭니다.
            // hospital 클래스의 title 및 subtitle 속성을 사용하여 콜 아웃에 표시 할 내용을 결정합니다.
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 초기위치 서울시 광진구
        let initialLocation = CLLocation(latitude: 37.5384514, longitude: 127.0709764)
        centerMapOnLocation(location: initialLocation)
        
        mapView1.delegate = self
        loadInitialData()
        mapView1.addAnnotations(hospitals)
        mapView1.addAnnotations(clinics)
        // Do any additional setup after loading the view.
    }
}
