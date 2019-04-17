//
//  ViewController.swift
//  ItsAZooInThere
//
//  Created by Shengsheng Xu on 4/16/19.
//  Copyright © 2019 Shengsheng Xu. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    //MARK: Properties
    var animals: Array<Animal> = Array()
//    var photoimageviews = Array<UIImageView>([photoimageview1, photoimageview2, photoimageview3])
    @IBOutlet weak var ScrollBackGround: UIScrollView!
    @IBOutlet weak var ScrollLabel: UILabel!
    var animal_sound_effect: AVAudioPlayer?
    
    func create_animals() {
        let fox_path = Bundle.main.path(forResource: "fox", ofType: "wav")!
        let serval_path = Bundle.main.path(forResource: "serval", ofType: "wav")!
        let penguin_path = Bundle.main.path(forResource: "penguin", ofType: "wav")!
        
        
        let serval = Animal(name: "Nemo", species: "Serval", age: 3, image: UIImage(named: "serval")!, soundPath: serval_path)
        let penguin = Animal(name: "Pen pen", species: "Penguin", age: 5, image: UIImage(named: "penguin")!, soundPath: penguin_path)
        let fox = Animal(name: "Gray Fox", species: "Fox", age: 30, image: UIImage(named: "fox")!, soundPath: fox_path)
        
        animals.append(serval)
        animals.append(fox)
        animals.append(penguin)
        animals.shuffle()
    }
    
    func set_label() {
        ScrollLabel.text = animals[0].species
        ScrollLabel.textAlignment = .center
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //create list of animals and set the text of initial label
        create_animals()
        set_label()
        
        ScrollBackGround.delegate = self
        ScrollBackGround.contentSize = CGSize(width: 1125, height: 500)
        ScrollBackGround.isPagingEnabled = true
        
        var x_value = 125
        var x_animal = 0
        for i in 0...2 {
            let button = UIButton(type: .system)
            button.frame = CGRect(x: x_value, y: 50, width: 125, height: 50)
            button.setTitle(animals[i].name, for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            ScrollBackGround.addSubview(button)
            
            let animal_image = UIImageView(frame: CGRect(x: x_animal, y: 100, width: 375, height: 275))
            animal_image.image = animals[i].image
            ScrollBackGround.addSubview(animal_image)
            
            x_value += 375
            x_animal += 375
        }
    }
    //when button is tapped
    @objc func buttonTapped(sender: UIButton) {
        //show the alert
        let tag = sender.tag
        let animal = animals[tag]
        let alert_controller = UIAlertController(title: animal.name, message: "Age is \(animal.age), Species is \(animal.species)", preferredStyle: .alert)
        let animal_alert = UIAlertAction(title: "OK", style: .default) { (_) in
            print(animal)
        }
        alert_controller.addAction(animal_alert)
        self.present(alert_controller, animated: true, completion: nil)
        
        //play the audio
        let url = URL(fileURLWithPath: animal.soundPath)
        do {
            animal_sound_effect = try AVAudioPlayer(contentsOf: url)
            animal_sound_effect?.play()
        } catch {
            //do nothing
            print("No such file")
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        if offset < 187.0 {
            self.ScrollLabel.text = animals[0].species
            self.ScrollLabel.alpha = 1 - offset/187
        }
        else if offset >= 187 && offset < 562 {
            self.ScrollLabel.text = animals[1].species
            if offset <= 375 {
                self.ScrollLabel.alpha = (offset - 187)/187
            }
            else {
                self.ScrollLabel.alpha = 1 - (offset - 375)/187
            }
        }
        else if offset >= 562 {
            self.ScrollLabel.text = animals[2].species
            self.ScrollLabel.alpha = (offset - 562)/187
        }
    }
}
