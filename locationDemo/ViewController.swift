//
//  ViewController.swift
//  locationDemo
//
//  Created by Tommy on 2021/07/13.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MapViewを関連付けする
    @IBOutlet var mapView: MKMapView!
    // 位置情報を取得するマネージャー
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        
        // 現在位置を取得するリクエストを表示
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()
        
        // 位置情報の取得を開始
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        // MapViewの設定
        mapView.delegate = self
        // MapViewの中心を常に現在位置にする
        mapView.userTrackingMode = .followWithHeading
    }
    
    // 現在位置が変わった時に呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // ユーザーの位置情報を取得（見つからなければ、以降のコードは実行されない）
        guard let location = locations.first?.coordinate else { return }
        
        // Mapのピンを全て削除
        mapView.removeAnnotations(mapView.annotations)
        // Pinを作成
        let annotation = MKPointAnnotation()
        // Pinのタイトルを設定
        annotation.accessibilityLabel = "現在位置"
        // Pinの座標を設定
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        // PinをMapに追加
        mapView.addAnnotation(annotation)
        
        // 今Map上に書かれている円を削除
        mapView.removeOverlays(mapView.overlays)
        // 現在位置を中心に半径500mの円をかく
        let myCircle: MKCircle = MKCircle(center: location, radius: CLLocationDistance(500))
        // mapViewに円を追加.
        mapView.addOverlay(myCircle)
    }
    
    // AddOverlayされた時に呼ばれる（円の色の変更とかができる）
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // rendererを生成.
        let myCircleView: MKCircleRenderer = MKCircleRenderer(overlay: overlay)
        // 円を青に塗りつぶす
        myCircleView.fillColor = .blue
        // 円を透過させる.
        myCircleView.alpha = 0.3
        return myCircleView
    }
}

