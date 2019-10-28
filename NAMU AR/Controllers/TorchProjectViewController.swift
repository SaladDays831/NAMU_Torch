
import ARKit
import Metal
import SceneKit
import TorchKit
import UIKit
import OnboardKit
import SwiftEntryKit
import Network


class TorchProjectViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet var sessionInfoLabel: UILabel?
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpDescription: UILabel!
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationText: UILabel!
    
    @IBOutlet weak var guideView: UIView!
    @IBOutlet weak var guideTopLabel: UILabel!
    @IBOutlet weak var guideBottomLabel: UILabel!
    @IBOutlet weak var guideImageView: UIImageView!
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    //Monitor for checking internet connection
    let monitor = NWPathMonitor()
    
    let onboardingVC = OnboardingViewController.shared
    let popUpContentManager = PopUpContentManager.shared
    
 //MARK: Project URL
  var projectURL = Bundle.main.url(forResource: "NAMU-14", withExtension: "torchkitproj")!
    var projectIsLoaded = false
    var loadedProject: TorchProjectNode?

    
  private var torchProject: TorchProjectNode?
  private var lastTime: TimeInterval = 0.0
  private var projectAnchorManager: ProjectAnchorManager?
  private var viewLock: NSLock = NSLock()
  private var viewCenter: CGPoint = CGPoint(x: 0, y: 0)
  private var lastSize: CGSize = CGSize(width: 0, height: 0)
    

    
    
    //MARK: ViewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    self.sceneView = ARSCNView(frame: self.view.bounds)
    
    //Run the monitor to catch connection changes
    let queue = DispatchQueue(label: "Monitor")
    monitor.start(queue: queue)
    
    popUpContentManager.loadData()
    print(artObjects.count)
    
    //ADD SCENEVIEW BELOW BUTTON
    self.view.insertSubview(self.sceneView, belowSubview: menuButton)
    
    self.sessionInfoLabel = UILabel(frame: CGRect(x: 0, y: 75, width: self.view.bounds.width * 0.8, height: 100))
    self.sessionInfoLabel!.numberOfLines = 3
    self.sessionInfoLabel!.textColor = .white
    self.sessionInfoLabel!.shadowColor = .black
    self.sessionInfoLabel!.shadowOffset = CGSize(width: 1.0, height: 1.0)
    self.view.addSubview(self.sessionInfoLabel!)
    self.sceneView.translatesAutoresizingMaskIntoConstraints = false
    self.sceneView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    self.sceneView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
    self.sessionInfoLabel!.translatesAutoresizingMaskIntoConstraints = false
    self.sessionInfoLabel!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    self.sessionInfoLabel!.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
    self.sessionInfoLabel!.topAnchor.constraint(equalTo: self.sceneView.topAnchor, constant: 75.0).isActive = true
    self.sessionInfoLabel!.heightAnchor.constraint(equalToConstant: 180.0)
    self.sessionInfoLabel?.font = UIFont(name: "NAMU-1960", size: 16.0)
    
  }
    
    //MARK: ViewDidAppear
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    
    if projectIsLoaded == false {
        let configuration = ARWorldTrackingConfiguration()
        //PLANE DETECTION
        configuration.planeDetection = [.horizontal]
        self.sceneView.session.run(configuration)
        self.sceneView.session.delegate = self
        UIApplication.shared.isIdleTimerDisabled = true
        //self.sceneView.showsStatistics = true

        //MARK: TorchProject loading
        do {
          self.torchProject = try TorchProjectNode(withProjectURL: self.projectURL, andDevice: self.sceneView.device!, arSession: self.sceneView.session)
        } catch {
          fatalError(error.localizedDescription)
        }
        
        guard let torchProj = self.torchProject else { return }
        loadedProject = torchProj
        TorchGestureManager.shared.addGestureRecognizers(to: self.sceneView)
        self.sceneView.session.delegate = torchProj.arSessionDelegate ?? nil
        self.setupSceneLighting()
        self.sceneView.scene.rootNode.addChildNode(torchProj)
        self.projectAnchorManager = nil
        self.sceneView.delegate = self
        
        projectIsLoaded = true
        
        
         //DEBUG SETTING SCENE
        loadedProject?.setScene(sceneName: "to drunk", resetCurrentScene: true)
    }
   
    
    if UserDefaults.standard.bool(forKey: "OnboardingComplete") == false {
        let onbVC = onboardingVC.createOnboardingVC()
        onbVC.modalPresentationStyle = .overFullScreen
        onbVC.presentFrom(self, animated: true)
    }
    
    //Catch network changes
    monitor.pathUpdateHandler = { path in
        if path.status == .satisfied {
            print("We're connected!")
            self.UI() {
                self.removeNetworkNotification()
            }
        } else {
            print("No connection.")
            self.UI() {
                self.presentNetworkNotification()
            }
        }
    }
    
    
    //MARK: Catching triggers
    
    print("CURRENT SCENE IS \(loadedProject!.currentScene.name)")
    
    torchProject?.triggerFired = { trigger in
        
        switch trigger.name {
            
        case "heorhi1tapped":
            self.popUpDescription.text = artObjects[0].trigger1description
            self.presentPopUp(fromBottom: true)
        case "heorhi2tapped":
            self.popUpDescription.text = artObjects[0].trigger2description
            self.presentPopUp(fromBottom: true)
        case "heorhi3tapped":
            self.popUpDescription.text = artObjects[0].trigger3description
            self.presentPopUp(fromBottom: true)
        case "heorhi4tapped":
            self.popUpDescription.text = artObjects[0].trigger4description
            self.presentPopUp(fromBottom: true)
        case "heorhiNextTapped":
            self.popUpDescription.text = artObjects[0].nextconnection
            self.presentPopUp(fromBottom: false)
            
        case "horse1tapped":
            self.popUpDescription.text = artObjects[1].trigger1description
            self.presentPopUp(fromBottom: true)
        case "horse2tapped":
            self.popUpDescription.text = artObjects[1].trigger2description
            self.presentPopUp(fromBottom: true)
        case "horse3tapped":
            self.popUpDescription.text = artObjects[1].trigger3description
            self.presentPopUp(fromBottom: true)
        case "horse4tapped":
            self.popUpDescription.text = artObjects[1].trigger4description
            self.presentPopUp(fromBottom: true)
        case "horse5tapped":
            self.popUpDescription.text = artObjects[1].trigger5description
            self.presentPopUp(fromBottom: true)
        case "horseNextTapped":
            self.popUpDescription.text = artObjects[1].nextconnection
            self.presentPopUp(fromBottom: false)
            
        case "velyk1tapped":
            self.popUpDescription.text = artObjects[2].trigger1description
            self.presentPopUp(fromBottom: true)
        case "velyk2tapped":
            self.popUpDescription.text = artObjects[2].trigger2description
            self.presentPopUp(fromBottom: true)
        case "velyk3tapped":
            self.popUpDescription.text = artObjects[2].trigger3description
            self.presentPopUp(fromBottom: true)
        case "velykNextTapped":
            self.popUpDescription.text = artObjects[2].nextconnection
            self.presentPopUp(fromBottom: false)
            
        case "ded1tapped":
            self.popUpDescription.text = artObjects[3].trigger1description
            self.presentPopUp(fromBottom: true)
        case "ded2tapped":
            self.popUpDescription.text = artObjects[3].trigger2description
            self.presentPopUp(fromBottom: true)
        case "ded3tapped":
            self.popUpDescription.text = artObjects[3].trigger3description
            self.presentPopUp(fromBottom: true)
        case "dedNextTapped":
            self.popUpDescription.text = artObjects[3].nextconnection
            self.presentPopUp(fromBottom: false)
            
        case "mamay1tapped":
            self.popUpDescription.text = artObjects[4].trigger1description
            self.presentPopUp(fromBottom: true)
        case "mamay2tapped":
            self.popUpDescription.text = artObjects[4].trigger2description
            self.presentPopUp(fromBottom: true)
        case "mamay3tapped":
            self.popUpDescription.text = artObjects[4].trigger3description
            self.presentPopUp(fromBottom: true)
        case "mamay4tapped":
            self.popUpDescription.text = artObjects[4].trigger4description
            self.presentPopUp(fromBottom: true)
        case "mamayNextTapped":
            self.popUpDescription.text = artObjects[4].nextconnection
            self.presentPopUp(fromBottom: false)
            
        case "babushka1tapped":
            self.popUpDescription.text = artObjects[5].trigger1description
            self.presentPopUp(fromBottom: true)
        case "babushka2tapped":
            self.popUpDescription.text = artObjects[5].trigger2description
            self.presentPopUp(fromBottom: true)
        case "babushkaNextTapped":
            self.popUpDescription.text = artObjects[5].nextconnection
            self.presentPopUp(fromBottom: false)
            
        case "drunk1tapped":
            self.popUpDescription.text = artObjects[6].trigger1description
            self.presentPopUp(fromBottom: true)
        case "drunk2tapped":
            self.popUpDescription.text = artObjects[6].trigger2description
            self.presentPopUp(fromBottom: true)
        case "drunkNextTapped":
            self.popUpDescription.text = artObjects[6].nextconnection
            self.presentPopUp(fromBottom: false)
            
        case "monk1tapped":
            self.popUpDescription.text = artObjects[7].trigger1description
            self.presentPopUp(fromBottom: true)
        case "monk2tapped":
            self.popUpDescription.text = artObjects[7].trigger2description
            self.presentPopUp(fromBottom: true)
        case "monkNextTapped":
            self.popUpDescription.text = artObjects[7].nextconnection
            self.presentPopUp(fromBottom: false)
            
        case "love1tapped":
            self.popUpDescription.text = artObjects[8].trigger1description
            self.presentPopUp(fromBottom: true)
        case "love2tapped":
            self.popUpDescription.text = artObjects[8].trigger2description
            self.presentPopUp(fromBottom: true)
        case "loveNextTapped":
            self.popUpDescription.text = artObjects[8].nextconnection
            self.presentPopUp(fromBottom: false)
            
        case "forest1tapped":
            self.popUpDescription.text = artObjects[9].trigger1description
            self.presentPopUp(fromBottom: true)
        case "forest2tapped":
            self.popUpDescription.text = artObjects[9].trigger2description
            self.presentPopUp(fromBottom: true)
        case "forestNextTapped":
            self.popUpDescription.text = artObjects[9].nextconnection
            self.presentPopUp(fromBottom: false)
            
        case "winter1tapped":
            self.popUpDescription.text = artObjects[10].trigger1description
            self.presentPopUp(fromBottom: true)
        case "winter2tapped":
            self.popUpDescription.text = artObjects[10].trigger2description
            self.presentPopUp(fromBottom: true)
        case "winterNextTapped":
            self.popUpDescription.text = artObjects[10].nextconnection
            self.presentPopUp(fromBottom: false)
            
        case "triggerChurchNotif":
            self.notificationText.text = "Подивись на ікону попереду!"
            self.presentNotification()
            
        case "church1tapped":
            self.popUpDescription.text = "Церква Воздвиження - яскравий приклад української дерев’яної архітектури доби зрілого бароко. Була споруджена на місці старої церкви у 1759(61) році на замовлення громади чернігівської губернії. До нашого часу дійшли небагато церков такого типу через антирелігійну політику радянського союзу. Церква, що перед вами, була розібрана у 30-х роках 20 ст. Перед самим її знесенням дослідники зробили детальні заміри, замальовки та фото, щоб зберегти інформацію для майбутніх поколінь. Саме завдяки цим даним була створена 3д-модель."
            self.presentPopUp(fromBottom: true)
        case "church2tapped":
            self.popUpDescription.text = "Іконостас - це, буквально, стіна ікон, що відокремлює сакральну(вівтарну) частину церкви від прихожан. З 16-го ст. виникає класичний високий іконостас, який складався з 5-ти основних рядів або чинів (знизу вгору): Цокольний, де переважно зображували біблейські сцени Старого Заповіту. Намісний - парні ікони Ісуса Христа та Богоматері, а також святих, які пов’язані із  церквою. Празниковий, присвячений церковним святам Деісусний - головний чин іконостасу, на якому зображено Спасителя, Богоматір, Івана Предтечу та ряд апостолів. Та пророчий ряд. Ікони були збережені завдяки Жольлвському, який вивіз їх з храму до його зруйнування."
            self.presentPopUp(fromBottom: true)
        case "churchNextTapped":
            self.popUpDescription.text = "Окрім релігійного мистецтва у період бароко активно починає розвиватись і мистецтво світське."
            self.presentPopUp(fromBottom: false)
            
            
        case "fondsTapped":
            self.guideImageView.image = UIImage(named: "thanksGuy")
            self.guideTopLabel.text = "Сподіваємось, було цікаво :)"
            self.guideBottomLabel.text = "Ми старались, аби додаток був цікавим для вас. Але ви можете зробити його ще кращим ;) Для цього потрібно залишити свій відгук!"
            self.guideBottomLabel.font = UIFont(name: "NAMU-1960", size: 11.0)
            self.view.insertSubview(self.guideView, aboveSubview: self.sceneView)
            self.guideView.center = self.view.center
            self.guideView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.guideView.alpha = 0
                UIView.animate(withDuration: 0.5) {
                    self.guideView.alpha = 1
                    self.guideView.transform = CGAffineTransform.identity
                }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleThanksTap(_:)))
            self.guideView.addGestureRecognizer(tap)
            self.guideView.isUserInteractionEnabled = true

            
        default:
            break
        }
      
        
        print("Trigger \(trigger.name) fired")
        print("CURRENT SCENE IS \(self.loadedProject!.currentScene.name)")
    }
    
  }

    //MARK: ViewDidDisappear
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    // DID SOME SHIT
    //self.sceneView.session.pause()
  }
    //MARK: ViewDidLayoutSubviews
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // This gets called alot, use lastSize to only lock when needed.
    if self.view.frame.size != self.lastSize {
      self.viewLock.lock()
      self.viewCenter = CGPoint(x: self.view.frame.size.width * 0.5, y: self.view.frame.size.height * 0.5)
      self.viewLock.unlock()
      self.lastSize = self.view.frame.size
    }
  }

    //MARK: Renderer
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    guard self.projectAnchorManager == nil,
      let camTransform = self.sceneView.session.currentFrame?.camera.transform else {
      return
    }
    let dt = self.lastTime != 0 ? time - self.lastTime : 0
    self.lastTime = time
    self.viewLock.lock()
    let viewCenter = self.viewCenter
    self.viewLock.unlock()
    let hits = self.sceneView.hitTest(viewCenter, options: nil)
    let gazedNode: SCNNode? = !hits.isEmpty ? hits.first!.node : nil
    self.torchProject!.tick(delta: dt, cameraTransform: camTransform, currentGazedNode: gazedNode)
  }
    //MARK: SceneLightning
  func setupSceneLighting() {
    let envmapURL = Bundle.main.url(forResource: "envmap", withExtension: "png")!
    let envmapData = try! Data(contentsOf: envmapURL)
    let envmap = UIImage(data: envmapData)

    sceneView.automaticallyUpdatesLighting = false
    self.sceneView.autoenablesDefaultLighting = false
    self.sceneView.scene.lightingEnvironment.contents = envmap
    self.sceneView.scene.lightingEnvironment.intensity = 1.0
    let worldPlaneGeometry = SCNFloor()
    let worldPlaneNode = SCNNode(geometry: worldPlaneGeometry)
    let worldPlaneMaterial = SCNMaterial()
    worldPlaneGeometry.reflectivity = 0
    worldPlaneMaterial.diffuse.contents = UIColor.white
    worldPlaneMaterial.lightingModel = .physicallyBased
    worldPlaneMaterial.writesToDepthBuffer = true
    worldPlaneMaterial.colorBufferWriteMask = []
    worldPlaneGeometry.materials = [worldPlaneMaterial]
    worldPlaneNode.castsShadow = false
    //comment next line
    //self.sceneView.scene.rootNode.addChildNode(worldPlaneNode)
    let light = SCNLight()
    light.type = .directional
    light.shadowMode = .deferred
    light.intensity = 1000.0
    light.color = UIColor(white: 1.0, alpha: 1.0)
    //comment next line
    light.castsShadow = true
    light.shadowColor = UIColor.black.withAlphaComponent(0.5)
    light.shadowBias = 32
    light.shadowSampleCount = 4
    light.shadowRadius = 5.0
    light.shadowMapSize = CGSize(width: 4096, height: 4096)
    let directionalLightNode = SCNNode()
    directionalLightNode.eulerAngles = SCNVector3(x: GLKMathDegreesToRadians(-80.0), y: -GLKMathDegreesToRadians(-180.0), z: 0.0)
    directionalLightNode.light = light
    self.sceneView.scene.rootNode.addChildNode(directionalLightNode)
  }
    
    
    
//MARK: PopUp presentation
    
    func presentPopUp(fromBottom: Bool) {
        var attributes = EKAttributes()
     
        attributes.position = .bottom
        attributes.entryBackground = .color(color: .white)
        attributes.displayDuration = .infinity
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .forward
        attributes.positionConstraints.verticalOffset = 10
        attributes.roundCorners = .all(radius: 10)
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.9)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.intrinsic
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
        if !fromBottom {
            attributes.position = .top
            //attributes.entryBackground = .color(color: .init(light: UIColor(named: "nextPopUp")!, dark: UIColor(named: "nextPopUp")!))
        }
        
        SwiftEntryKit.display(entry: popUpView, using: attributes)
       
    }
    
    func presentNotification() {
        var attributes = EKAttributes()
        
        attributes.position = .top
        attributes.entryBackground = .color(color: .white)
        attributes.displayDuration = 5
        attributes.positionConstraints.verticalOffset = 10
        attributes.roundCorners = .all(radius: 10)
        let widthConstraint = EKAttributes.PositionConstraints.Edge.ratio(value: 0.9)
        let heightConstraint = EKAttributes.PositionConstraints.Edge.intrinsic
        attributes.positionConstraints.size = .init(width: widthConstraint, height: heightConstraint)
        
        
        SwiftEntryKit.display(entry: notificationView, using: attributes)
    }
    
    func presentNetworkNotification() {
        self.visualEffectView.isHidden = false
        self.visualEffectView.isUserInteractionEnabled = true
        self.view.insertSubview(self.guideView, aboveSubview: self.visualEffectView)
        self.guideView.center = self.visualEffectView.center
        self.guideView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.guideView.alpha = 0
    
        UIView.animate(withDuration: 0.5) {
            self.guideView.alpha = 1
            self.guideView.transform = CGAffineTransform.identity
        }
    }
    
    func removeNetworkNotification() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.guideView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.guideView.alpha = 0
            self.visualEffectView.isHidden = true
            self.visualEffectView.isUserInteractionEnabled = false
        }) { (success) in
            self.guideView.removeFromSuperview()
        }
        
    }
    
    @objc func handleThanksTap(_ sender: UITapGestureRecognizer) {
       print("Hello World")
        guideView.removeFromSuperview()
    }
    
    
    
    
    @IBAction func guideOKButtonPressed(_ sender: UIButton) {
    }
    
    
    
    @IBAction func popupCloseButtonPressed(_ sender: UIButton) {
        SwiftEntryKit.dismiss()
    }
    
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        let menuVC = storyboard?.instantiateViewController(withIdentifier: "menuVC") as! OtherViewController
        present(menuVC, animated: true, completion: nil)
        menuVC.torchProjDelegate = self
    }
    
    //To update UI on the main thread
    func UI(_ block: @escaping ()->Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  // MARK: - ARSessionDelegate

  func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    guard let frame = session.currentFrame else { return }
    self.updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
  }

  func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
    guard let frame = session.currentFrame else { return }
    self.updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
  }

  func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    self.updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
  }

  // MARK: - ARSessionObserver

  func sessionWasInterrupted(_ session: ARSession) {
    // Inform the user that the session has been interrupted, for example, by presenting an overlay.
    self.sessionInfoLabel?.text = "AR сессія перервана"
  }

  func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required.
    self.sessionInfoLabel?.text = "AR сессія оновлена"
    // DID SOME SHIT
    //self.resetTracking()
  }

  func session(_ session: ARSession, didFailWithError error: Error) {
    self.sessionInfoLabel?.text = "Сталась помилка: \(error.localizedDescription)"
    guard error is ARError else { return }

    let errorWithInfo = error as NSError
    let messages = [
      errorWithInfo.localizedDescription,
      errorWithInfo.localizedFailureReason,
      errorWithInfo.localizedRecoverySuggestion
    ]

    // Remove optional error messages.
    let errorMessage = messages.compactMap { $0 }.joined(separator: "\n")

    DispatchQueue.main.async {
      // Present an alert informing about the error that has occurred.
      let alertController = UIAlertController(title: "Помилка при запуску AR сесії.", message: errorMessage, preferredStyle: .alert)
      let restartAction = UIAlertAction(title: "Перезапустити", style: .default) { _ in
        alertController.dismiss(animated: true, completion: nil)
        self.resetTracking()
      }
      alertController.addAction(restartAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }

  private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
    // Update the UI to provide feedback on the state of the AR experience.
    let message: String

    switch trackingState {
    case .normal where frame.anchors.isEmpty:
      // No planes detected; provide instructions for this app's AR interactions.
      message = "Найди табличку Початок Експозиции"

    case .notAvailable:
      message = "Трекінг недоступний."

    case .limited(.excessiveMotion):
      message = "Будь ласка, рухайте пристроєм повільніше."

    case .limited(.insufficientFeatures):
      message = "Трекінг обмежений - Наведіть пристрій на ділянку з видимою деталізацією поверхні."

    case .limited(.initializing):
      message = "Загрузка AR сесії."

    default:
      // No feedback needed when tracking is normal and planes are visible.
      // (Nor when in unreachable limited-tracking states.)
      message = self.projectAnchorManager != nil ? "Tap a plane to set project anchor" : ""
    }
    self.sessionInfoLabel?.text = message
  }

  private func resetTracking() {
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = [.horizontal, .vertical]
    self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
  }

  class func emptyCoder() -> NSCoder {
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWith: data)
    archiver.finishEncoding()
    return NSKeyedUnarchiver(forReadingWith: data as Data)
  }
    
}

extension TorchProjectViewController: TorchProjectDelegate {
    func resetTorchProj() {
        loadedProject?.setScene(sceneName: "initial", resetCurrentScene: true)
        print("AR session started over")
    }
}
