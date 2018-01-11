//
//  ActionViewController.swift
//  ActionExtension
//
//  Created by Andrew Eades on 11/01/2018.
//  Copyright © 2018 Andrew Eades. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    private func loadImage(from imageURL: NSSecureCoding?) {
        OperationQueue.main.addOperation {
            weak var weakImageView = self.imageView

            if let strongImageView = weakImageView {
                if let imageURL = imageURL as? URL {
                    strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        log("viewDidLoad")
        
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        var imageFound = false
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! as! [NSItemProvider] {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                    // This is an image. We'll load it, then place it in our image view.
                    provider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil, completionHandler: { (imageURL, error) in
                        
                        self.loadImage(from: imageURL)
                    })
                    
                    imageFound = true
                    break
                }
            }
            
            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        log("done tapped")
        
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
}

extension ActionViewController: ConsoleLogging {
    var appID: String {
        return "ActionExtensionDemo"
    }
}
