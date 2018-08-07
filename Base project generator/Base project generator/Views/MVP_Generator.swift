//
//  MVP_Generator.swift
//  Base project generator
//
//  Created by Ahmad Mahmoud on 8/6/18.
//  Copyright © 2018 Ahmad Mahmoud. All rights reserved.
//

import Cocoa

class MVP_Generator: BaseViewController {
    //
    @IBOutlet weak var viewControllerNameTextField: NSTextField!
    @IBOutlet weak var errorLabel: NSTextField!
    
    @IBAction func buttonAction(_ sender: NSButton) {
        if (viewControllerNameTextField.stringValue.isEmpty) {
            errorLabel.stringValue = "View controller name can not be empty !"
        }
        else {
            errorLabel.stringValue = ""
            helpers = Helpers(projectNameString: viewControllerNameTextField.stringValue)
            //
            // Create root folder
            let folder = try? fileSystem.createFolder(at: helpers.getUserDesktopPath() + "/" + viewControllerNameTextField.stringValue)
            //
            let viewFile = try? folder?.createFile(named:  viewControllerNameTextField.stringValue + "View" + ".swift")
            let viewClassStr = helpers.buildClassIHeaderText(className: viewControllerNameTextField.stringValue + "View" + ".swift") + helpers.buildImportHeader() +
                "class " + viewControllerNameTextField.stringValue + "View" +
                " : BaseViewController<" +
                viewControllerNameTextField.stringValue + "Presenter, " +
                viewControllerNameTextField.stringValue + "Delegator>, " +
                viewControllerNameTextField.stringValue + "Delegator {\n\n" +
                "    override func viewDidLoad() {\n" +
                "        super.viewDidLoad()\n" +
                "        // Do any additional setup after loading the view.\n\n" +
                "    }\n\n" +
                "    override func viewWillAppear(_ animated: Bool) {\n" +
                "        super.viewWillAppear(animated)\n" +
                "        // Set context\n" +
                "        AppDelegate.setContext(context: self)\n" +
                "        //\n\n" +
                "    }\n\n}"
            try? viewFile??.write(string: viewClassStr)
            //
            let presenterFile = try? folder?.createFile(named:  viewControllerNameTextField.stringValue + "Presenter" + ".swift")
            let presenterClassStr = helpers.buildClassIHeaderText(className: viewControllerNameTextField.stringValue + "Presenter" + ".swift") + helpers.buildImportHeader() +
                "class " + viewControllerNameTextField.stringValue + "Presenter : BasePresenter<" +
            viewControllerNameTextField.stringValue + "Delegator> {\n\n" +
            "    required init(contract: " + viewControllerNameTextField.stringValue + "Delegator) {\n" +
            "        super.init(contract: contract)\n" +
            "    }\n\n}"
            try? presenterFile??.write(string: presenterClassStr)
            //
            let delegatorFile = try? folder?.createFile(named:  viewControllerNameTextField.stringValue + "Delegator" + ".swift")
            let delegatorClassStr = helpers.buildClassIHeaderText(className: viewControllerNameTextField.stringValue + "Delegator" + ".swift") + helpers.buildImportHeader() +
                "public protocol " +
                viewControllerNameTextField.stringValue + "Delegator" +
            " : BaseViewDelegator {\n\n}"
            try? delegatorFile??.write(string: delegatorClassStr)
        }
    }
}
