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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        log("viewDidLoad")
        
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        
        guard let extensionItems = self.extensionContext!.inputItems as? [NSExtensionItem] else {
            self.showAlert(title: "Error", message: "No extension items.")
            return
        }

        let attachments = extensionItems
            .map { $0.attachments }
            .filter { $0 != nil }
            .flatMap { $0! }
        
        let imageProviders = attachments
            .map { $0 as? NSItemProvider }
            .filter { $0 != nil }
            .map { $0! }
            .filter { $0.hasItemConformingToTypeIdentifier(kUTTypeImage as String) }
        
        guard let provider = imageProviders.first else {
            self.showAlert(title: "Error", message: "No image provider.")
            return
        }

        provider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil) { item, error in
            self.loadImage(from: item)
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
    
    
    private func loadImage(from item: NSSecureCoding?) {
        let image: UIImage?
        
        if let imageURL = item as? URL {
            image =  UIImage(data: try! Data(contentsOf: imageURL))
            
        } else if let theImage = item as? UIImage {
            image = theImage
            
        } else if let data = item as? Data {
            image = UIImage(data: data)
            
        } else {
            image = nil
        }
        
        guard image != nil else {
            showAlert(title: "Error", message: "Cannot convert item into an image.")
            return
        }
        
        OperationQueue.main.addOperation {
            if let strongImageView = self.imageView
            {
                strongImageView.image = image
            }
        }
    }
}

extension ActionViewController: ConsoleLogging {
    var appID: String {
        return "ActionExtensionDemo"
    }
}

extension ActionViewController {
    private func showAlert(title: String, message: String, shouldCloseExtensionWithAlertDismissal: Bool = true) {
        
        let alert = UIAlertController(title: title,
                                      message: String(message.prefix(40)),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if shouldCloseExtensionWithAlertDismissal {
                self.done()
            }
            
            self.dismiss(animated: true)
        })
        
        self.present(alert, animated: true)
    }
}
