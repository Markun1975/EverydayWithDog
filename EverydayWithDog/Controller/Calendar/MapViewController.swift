import UIKit
import GoogleMaps
import GooglePlaces

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var mapView = GMSMapView()
    
    
    @IBOutlet var serchView: UIView!
    
    var locationManager = CLLocationManager()
    
    
    @IBOutlet var serchTextField: UITextField!
    
    @IBOutlet var nawPlaceButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupLocationManager()
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        setMap()
        infomationWindow()
        requestLoacion()
        
        
        
        nawPlaceButton.layer.cornerRadius = 0.5 * nawPlaceButton.bounds.size.width
        nawPlaceButton.clipsToBounds = false
        nawPlaceButton.setImage(UIImage(named:"nowPlace2.png"), for: .normal)
    }
    
    //GoogleMap表示設定。後に設定

//    override func loadView() {
//        // マップに指定の緯度経度の場所を指定の倍率で表示するように指示
//        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 10.0)
//
//        // 指定のフレームとcameraPositionでmapviewをビルドして返す
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        mapView.isMyLocationEnabled = true
//        view = mapView
//
//        // markerはピンの場所
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
//        marker.map = mapView
//
//        googleMap.settings.myLocationButton = true
//    }
//
//    func setupLocationManager() {
//        locationManager.requestWhenInUseAuthorization()
//
//        // 「アプリ使用中の位置情報取得」の許可が得られた場合のみ、CLLocationManagerクラスのstartUpdatingLocation()を呼んで、位置情報の取得を開始する
//        if .authorizedWhenInUse == CLLocationManager.authorizationStatus() {
//
//            // 許可が得られた場合にViewControllerクラスがCLLoacationManagerのデリゲート先になるようにする
//            locationManager.delegate = self
//            // 何メートル移動ごとに情報を取得するか。ここで設定した距離分移動したときに現在地を示すマーカーも移動する
//            locationManager.distanceFilter = 1
//            // 位置情報取得開始
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//    // 位置情報を取得・更新するたびに呼ばれる
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let location = locations.first
//        let latitude =  location?.coordinate.latitude
//        let longitude = location?.coordinate.longitude
//
//        print("latitude: \(latitude!)\n longitude: \(longitude!)")
//    }
    
    
    private func setMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 35.6812226, longitude: 139.7670594, zoom: 12.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: mapView.frame.size.height - 100, width: mapView.frame.size.width, height: mapView.frame.size.height), camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        buttonSetup()
//        view.addSubview(nawPlaceButton)
        view.addSubview(serchView)
    }
    
    private func requestLoacion() {
           // ユーザにアプリ使用中のみ位置情報取得の許可を求めるダイアログを表示
           locationManager.requestWhenInUseAuthorization()
           // 常に取得したい場合はこちら↓
           // locationManager.requestAlwaysAuthorization()
       }
    private func infomationWindow(){
//        let position = CLLocationCoordinate2D(latitude:51.5, longitude: -0.127)
//        let london = GMSMarker(position: position)
//        london.title = ""
//        london.snippet = "Population: 8,1"
//        london.map = mapView
    }
    
    
    private func buttonSetup(){
        nawPlaceButton.layer.shadowColor = UIColor.black.cgColor
        nawPlaceButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        nawPlaceButton.layer.shadowRadius = 2
        nawPlaceButton.layer.shadowOpacity = 0.3
        view.addSubview(nawPlaceButton)
    }
    @IBAction func nawPlace(_ sender: Any) {
        mapView.isMyLocationEnabled = true
    }
}
