
import ARKit
import Metal
import SceneKit
import TorchKit
import UIKit
import OnboardKit
import SwiftEntryKit

class TorchProjectViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet var sessionInfoLabel: UILabel?
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var popUpDescription: UILabel!
    
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var notificationText: UILabel!
    
    
    let onboardingVC = OnboardingViewController.shared
    let popUpContentManager = PopUpContentManager.shared
    
 //MARK: Project URL
  var projectURL = Bundle.main.url(forResource: "NAMUU", withExtension: "torchkitproj")!
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
    }
   
    
    if UserDefaults.standard.bool(forKey: "OnboardingComplete") == false {
        let onbVC = onboardingVC.createOnboardingVC()
        onbVC.modalPresentationStyle = .overFullScreen
        onbVC.presentFrom(self, animated: true)
    }
    
    
    //MARK: Catching triggers
    
    print("CURRENT SCENE IS \(loadedProject!.currentScene.name)")
    
    torchProject?.triggerFired = { trigger in
        
        switch trigger.name {
            
        case "heorhi1tapped":
            self.popUpDescription.text = artObjects[0].trigger1Description
            self.presentPopUp(fromBottom: true)
        case "heorhi2tapped":
            self.popUpDescription.text = artObjects[0].trigger2Description
            self.presentPopUp(fromBottom: true)
        case "heorhi3tapped":
            self.popUpDescription.text = artObjects[0].trigger3Description
            self.presentPopUp(fromBottom: true)
        case "heorhi4tapped":
            self.popUpDescription.text = artObjects[0].trigger4Description
            self.presentPopUp(fromBottom: true)
        case "heorhiNextTapped":
            self.popUpDescription.text = artObjects[0].nextConnection
            self.presentPopUp(fromBottom: false)
            
        case "horse1tapped":
            self.popUpDescription.text = artObjects[1].trigger1Description
            self.presentPopUp(fromBottom: true)
        case "horse2tapped":
            self.popUpDescription.text = artObjects[1].trigger2Description
            self.presentPopUp(fromBottom: true)
        case "horse3tapped":
            self.popUpDescription.text = artObjects[1].trigger3Description
            self.presentPopUp(fromBottom: true)
        case "horse4tapped":
            self.popUpDescription.text = artObjects[1].trigger4Description
            self.presentPopUp(fromBottom: true)
        case "horse5tapped":
            self.popUpDescription.text = artObjects[1].trigger5Description
            self.presentPopUp(fromBottom: true)
        case "horseNextTapped":
            self.popUpDescription.text = artObjects[1].nextConnection
            self.presentPopUp(fromBottom: false)
            
        case "velyk1tapped":
            self.popUpDescription.text = artObjects[2].trigger1Description
            self.presentPopUp(fromBottom: true)
        case "velyk2tapped":
            self.popUpDescription.text = artObjects[2].trigger2Description
            self.presentPopUp(fromBottom: true)
        case "velyk3tapped":
            self.popUpDescription.text = artObjects[2].trigger3Description
            self.presentPopUp(fromBottom: true)
        case "velykNextTapped":
            self.popUpDescription.text = artObjects[2].nextConnection
            self.presentPopUp(fromBottom: false)
            
        case "ded1tapped":
            self.popUpDescription.text = artObjects[3].trigger1Description
            self.presentPopUp(fromBottom: true)
        case "ded2tapped":
            self.popUpDescription.text = artObjects[3].trigger2Description
            self.presentPopUp(fromBottom: true)
        case "ded3tapped":
            self.popUpDescription.text = artObjects[3].trigger3Description
            self.presentPopUp(fromBottom: true)
        case "dedNexttapped":
            self.popUpDescription.text = artObjects[3].nextConnection
            self.presentPopUp(fromBottom: false)
            
        case "mamay1tapped":
            self.popUpDescription.text = artObjects[4].trigger1Description
            self.presentPopUp(fromBottom: true)
        case "mamay2tapped":
            self.popUpDescription.text = artObjects[4].trigger2Description
            self.presentPopUp(fromBottom: true)
        case "mamay3tapped":
            self.popUpDescription.text = artObjects[4].trigger3Description
            self.presentPopUp(fromBottom: true)
        case "mamay4tapped":
            self.popUpDescription.text = artObjects[4].trigger4Description
            self.presentPopUp(fromBottom: true)
        case "mamayNextTapped":
            self.popUpDescription.text = artObjects[4].nextConnection
            self.presentPopUp(fromBottom: false)
            
            
        case "triggerChurchNotif":
            self.notificationText.text = "Подивись на ікону попереду!"
            self.presentNotification()
            
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
    //self.sceneView.scene.rootNode.addChildNode(worldPlaneNode)
    let light = SCNLight()
    light.type = .directional
    light.shadowMode = .deferred
    light.intensity = 1000.0
    light.color = UIColor(white: 1.0, alpha: 1.0)
    //light.castsShadow = true
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
            attributes.entryBackground = .color(color: .init(light: UIColor(named: "nextPopUp")!, dark: UIColor(named: "nextPopUp")!))
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
    self.sessionInfoLabel?.text = "Session was interrupted"
  }

  func sessionInterruptionEnded(_ session: ARSession) {
    // Reset tracking and/or remove existing anchors if consistent tracking is required.
    self.sessionInfoLabel?.text = "Session interruption ended"
    // DID SOME SHIT
    //self.resetTracking()
  }

  func session(_ session: ARSession, didFailWithError error: Error) {
    self.sessionInfoLabel?.text = "Session failed: \(error.localizedDescription)"
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
      let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
      let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
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
      message = "Tracking unavailable."

    case .limited(.excessiveMotion):
      message = "Tracking limited - Move the device more slowly."

    case .limited(.insufficientFeatures):
      message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."

    case .limited(.initializing):
      message = "Initializing AR session."

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
