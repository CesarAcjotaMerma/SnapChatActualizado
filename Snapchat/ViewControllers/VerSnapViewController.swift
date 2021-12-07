//
//  VerSnapViewController.swift
//  Snapchat
//
//  Created by Cesar Augusto Acjota Merma on 11/10/21.
//  Copyright © 2021 deah. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import FirebaseDatabase
import AVFoundation

class VerSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMensaje: UILabel!
    @IBOutlet weak var lblnombreAudio: UILabel!
    
    var snap = Snap()
    
    var grabarAudio: AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMensaje.text = "Mensaje: " + snap.descrip
        imageView.sd_setImage(with: URL(string: snap.imagenURL), completed: nil)
        lblnombreAudio.text = snap.audioName
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").child(snap.id).removeValue()
        
        Storage.storage().reference().child("imagenes").child("\(snap.imagenID).jpg").delete { (error) in
                print("Se elimino la imagen correctamente")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
