//
//  ChannelListViewController.swift
//  simpleChating
//
//  Created by iosdev on 9/30/17.
//  Copyright © 2017 ios3-umn. All rights reserved.
//

import UIKit
import Firebase

class ChannelListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var senderDisplayName: String?
    private var channels: [Channel] = []
    
    
    @IBAction func logoutBtnTapped(_ sender: Any) {
    
        print("poi")
        if Auth.auth().currentUser != nil{
            do{
                print("uio")
                try Auth.auth().signOut()
                let vc = storyboard?.instantiateViewController(withIdentifier: "SignUp") as! LoginViewController
                print("memew")
                present(vc, animated: true , completion : nil)
            }catch let error as NSError{
                print(error.localizedDescription)
            }
        }
    
    }
    
    private lazy var channelRef: DatabaseReference = Database.database().reference().child("channels")
    private var  channelRefHandle : DatabaseHandle?

    @IBOutlet weak var channelTableView: UITableView!
    
    private func observeChannel(){
    
        channelRefHandle =  channelRef.observe(.childAdded, with: {(snapshot) -> Void in
            
            let channelData =  snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            
            
            if let name = channelData["name"] as! String!, name.characters.count > 0{
                self.channels.append(Channel(id: id, name:name))
                self.channelTableView.reloadData()
            }else{
            print("Error plir")
            }
        
        })
        
        
        
    }
    
    deinit {
        if let refHandle = channelRefHandle{
        channelRef.removeObserver(withHandle: refHandle)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeChannel()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addBtnTapped(_ sender: Any) {
        let alert = UIAlertController(title:"Some Title",message: "Enter a Text", preferredStyle: .alert)
        
        alert.addTextField{(textField)in
            textField.placeholder =  "input new Channel"
        }
        alert.addAction(UIAlertAction(title: "Cancel" , style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            
        } ))
        
        alert.addAction(UIAlertAction(title: "Add" , style: .default, handler: {[weak alert] (_) in
        
            let textField = alert?.textFields![0]
            if let name = textField?.text{
                let newChannelRef = self.channelRef.childByAutoId()
                let channelItem = [
                "name":name
                ]
                newChannelRef.setValue(channelItem)
            }
            
        
        }))
        self.present(alert,animated: true, completion: nil)
    
    }

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(channels,"asdfghjkl")
        return channels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell",for: indexPath)
        cell.textLabel?.text = channels[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToChatSegue", sender: channels[indexPath.row])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let channel = sender as? Channel{
            let chatVc = segue.destination as! ChatViewController
            
            chatVc.senderDisplayName = senderDisplayName
            chatVc.channel = channel
            chatVc.channelRef = channelRef.child(channel.id)
            }
        }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
