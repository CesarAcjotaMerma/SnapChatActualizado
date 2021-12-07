import UIKit
import Firebase
import FirebaseStorage
import AVFoundation

class ImagenViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var audioID = NSUUID().uuidString
    var audioName = NSUUID().uuidString

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var elegirContactoBoton: UIButton!
    @IBOutlet weak var btnGrabarAudio: UIButton!
    @IBOutlet weak var nombreAudioTextField: UITextField!
    @IBOutlet weak var btnReproducirAudio: UIButton!
    
    var grabarAudio: AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        imagePicker.delegate = self
        elegirContactoBoton.isEnabled = false
        
        btnGrabarAudio.layer.cornerRadius = 15.0
        btnReproducirAudio.layer.cornerRadius = 15.0
        btnReproducirAudio.isEnabled = false
    }
    
    
    @IBAction func mediaTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion:  nil)
    }
    
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true,completion: nil)
    }
    
    
    @IBAction func grabarAudioTapped(_ sender: Any) {
        if grabarAudio!.isRecording{
                  //detener grabacion
                  grabarAudio?.stop()
                  //cambiar text del boton grabar
                  btnGrabarAudio.setTitle("GRABAR", for: .normal)
                  btnReproducirAudio.isEnabled = true
                  //agregarButton.isEnabled = true
              }else{
                  //empezar a grabar
                  grabarAudio?.record()
                  //cambiar el texto del boton grabar a detener
                  btnGrabarAudio.setTitle("DETENER", for: .normal)
                  btnReproducirAudio.isEnabled = false
                  //controlVolumen.isHidden = false
              }
    }
    
    @IBAction func reproducirAudioTapped(_ sender: Any) {
        do {
            try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
            reproducirAudio!.prepareToPlay()
            reproducirAudio!.currentTime = 0
            let audioAsset = AVURLAsset.init(url: audioURL!, options: nil)
            let duracion = audioAsset.duration
            let duracionSecond = CMTimeGetSeconds(duracion)
            print("Duracion del audio: \(duracionSecond)")
            
//            Slider.maximumValue = Float(reproducirAudio!.duration)
//            Timer.scheduledTimer(timeInterval: 0.1, target:self,selector: Selector(("updateSlider")), userInfo: nil, repeats: true)
//           lblDispay.text = "\(reproducirAudio!.currentTime)"
//           Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
//               self.lblDispay.text = "\(round(self.reproducirAudio!.currentTime*10)/10)"
//             })
            reproducirAudio!.play()
            print("Reproduciendo")
            //btnPausar.isEnabled = true
            //btnStop.isEnabled = true
            //Slider.isEnabled = true
        } catch {}
    }
    
    
    @IBAction func elegirContactoTapped(_ sender: Any) {
        self.elegirContactoBoton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("imagenes")
        let audiosFolder = Storage.storage().reference().child("audios")
        //let audioData = reproducirAudio
        let cargarAudio = audiosFolder.child("\(audioID).m4a")
//            cargarAudio.putData(reproducirAudio!, metadata: nil){ (metadata, error) in
//                   if error != nil {
//                       self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen, Verifique su conexion a internet y vuelva a intentarlo", accion: "Aceptar")
//                       self.elegirContactoBoton.isEnabled = true
//                       print("Ocurrio un error al subir imagen: \(String(describing: error))")
//                   }else{
//                    cargarImagen.downloadURL(completion: {(url,error) in
//                        guard let enlaceURL = url else{
//                            self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen", accion: "Cancelar")
//                            self.elegirContactoBoton.isEnabled = true
//                            print("Ocurrio un error al obtener informacion de imagen \(String(describing: error))")
//                            return
//                        }
//
//                        self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
//                     })
//                   }
//               }
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
            cargarImagen.putData(imagenData!, metadata: nil){ (metadata, error) in
                   if error != nil {
                       self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen, Verifique su conexion a internet y vuelva a intentarlo", accion: "Aceptar")
                       self.elegirContactoBoton.isEnabled = true
                       print("Ocurrio un error al subir imagen: \(String(describing: error))")
                   }else{
                    cargarImagen.downloadURL(completion: {(url,error) in
                        guard let enlaceURL = url else{
                            self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen", accion: "Cancelar")
                            self.elegirContactoBoton.isEnabled = true
                            print("Ocurrio un error al obtener informacion de imagen \(String(describing: error))")
                            return
                        }
                    
                        self.performSegue(withIdentifier: "seleccionarContactoSegue", sender: url?.absoluteString)
                     })
                   }
               }
        /*
        let alertaCarga = UIAlertController(title: "Cargando Imagen ...", message: "0%", preferredStyle: .alert)
        let procesoCarga : UIProgressView = UIProgressView(progressViewStyle: .default)
        cargarImagen.observe(.progress) { (snapshot) in
            let porcentaje = Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(porcentaje)
            procesoCarga.setProgress(Float(porcentaje), animated: true)
            procesoCarga.frame = CGRect(x: 10, y: 70, width: 250, height: 0)
            alertaCarga.message = String(round(porcentaje*100.0)) + " %"
            if porcentaje>=1.0 {
                alertaCarga.dismiss(animated: true, completion: nil)
            }
        }
        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alertaCarga.addAction(btnOK)
        alertaCarga.view.addSubview(procesoCarga)
        present(alertaCarga, animated: true, completion: nil)
         */
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        elegirContactoBoton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! ElelgirUsuarioViewController
        siguienteVC.imagenURL = sender as! String
        siguienteVC.descrip = descripcionTextField.text!
        siguienteVC.audioName = nombreAudioTextField.text!
        siguienteVC.imagenID = imagenID
    }
    
    func configurarGrabacion(){
        do {
            let session = AVAudioSession.sharedInstance()
            
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            //
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            let pathComponents = [basePath,"audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("*****************")
            print(audioURL!)
            print("*****************")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            //
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings: settings)
            grabarAudio!.prepareToRecord()
        } catch let error as NSError {
            print(error)
        }
    }

}
