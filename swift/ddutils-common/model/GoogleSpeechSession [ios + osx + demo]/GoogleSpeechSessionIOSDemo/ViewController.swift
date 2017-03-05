import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet var textView: UITextView!
    
    var googleSpeechSession = GoogleSpeechSession(languageCode: "de-DE")
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        stopAudio(sender)

        googleSpeechSession.recordNewAudio { (started) in
            self.view.backgroundColor = started ? .red : .white
            
            self.recordBtn.isHidden = true
            self.playBtn.isHidden = false
            self.cancelBtn.isHidden = false
            self.sendBtn.isHidden = false
        }
    }

    @IBAction func playAudio(_ sender: AnyObject) {
        googleSpeechSession.playCachedAudio { (started) in
            self.view.backgroundColor = started ? .green : .white
        }
    }
    
    @IBAction func stopAudio(_ sender: AnyObject) {
        googleSpeechSession.stopAllAudio()
        self.view.backgroundColor = .white

        self.recordBtn.isHidden = false
        self.playBtn.isHidden = true
        self.cancelBtn.isHidden = true
        self.sendBtn.isHidden = true
    }

    @IBAction func processAudio(_ sender: AnyObject) {
        self.recordBtn.isHidden = true
        self.playBtn.isHidden = true
        self.cancelBtn.isHidden = true
        self.sendBtn.isHidden = true

        self.view.backgroundColor = .blue
        googleSpeechSession.send { (text, confidence) in
            self.view.backgroundColor = .white
            if let text = text,
                let confidence = confidence {
                self.textView.text = "=> \(text)\nconfidence: \(confidence)"
            }
            self.recordBtn.isHidden = false
        }
    }
}
