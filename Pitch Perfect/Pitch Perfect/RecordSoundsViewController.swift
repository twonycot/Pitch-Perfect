//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Terry Wonycott on 12/18/16.
//  Copyright © 2016 Terry Wonycott. All rights reserved.
//

import UIKit
import AVFoundation //contains audioRecorder


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    @IBOutlet weak var r: NSLayoutConstraint!
 
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false // Disables recording at start
            // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setUIState(isRecording:Bool, recordingText:String) {
        recordingLabel.text = recordingText
        if isRecording {
            recordButton.isEnabled = false
             stopRecordingButton.isEnabled = true
        } else {
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
        }
    }
    


    @IBAction func recordAudio(_ sender: AnyObject) {
            // Changes text to "Recording in Progress after the record button is pressed.
        setUIState(isRecording: true, recordingText: "Recording in Progress")
            //Creates file and path for audio to be stored
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
            //Opens a sharedd instance session that can be used for recording.
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
            //Starts recording
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self // recordSoundsViewController as the delegate.
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    
    
    @IBAction func stopRecording(_ sender: AnyObject) {
            // Changes text back to "Tap to Record"
       setUIState(isRecording: false, recordingText: "Tap to Record")
        audioRecorder.stop()  //Stops audio recording
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false) //set the session to inactive
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        //moves from one viewcontroller to another.
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successfull")
        }
        

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // checks to make sure its the right segue
        if segue.identifier == "stopRecording" {
            // grabs the correct viewcontroller
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            //grabs the sender
            let recordedAudioURL = sender as! URL
            //sets the recorded audio url in the playSoundsViewController
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

