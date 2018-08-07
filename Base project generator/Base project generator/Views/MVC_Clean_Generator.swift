//
//  MVC_Clean_Generator.swift
//  Base project generator
//
//  Created by Ahmad Mahmoud on 8/6/18.
//  Copyright © 2018 Ahmad Mahmoud. All rights reserved.
//

import Cocoa

class MVC_Clean_Generator: BaseViewController {

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
                " : BaseView {\n\n" +
                "    private var controller : " + viewControllerNameTextField.stringValue + "Controller!\n\n" +
                "    override func viewDidLoad() {\n" +
                "        super.viewDidLoad()\n" +
                "        controller = " + viewControllerNameTextField.stringValue + "Controller(view: self)\n" +
                "        //\n" +
                "    }\n\n}"
            try? viewFile??.write(string: viewClassStr)
            //
            let controllerFile = try? folder?.createFile(named:  viewControllerNameTextField.stringValue + "Controller" + ".swift")
            let controllerClassStr = helpers.buildClassIHeaderText(className: viewControllerNameTextField.stringValue + "Controller" + ".swift") + helpers.buildImportHeader() +
                "class " + viewControllerNameTextField.stringValue + "Controller : BaseController<" +
                viewControllerNameTextField.stringValue + "Controller> {\n\n" +
            "    required init(view: " + viewControllerNameTextField.stringValue + "View) {\n" +
                "        super.init(view: view)\n" +
            "    }\n\n}"
            try? controllerFile??.write(string: controllerClassStr )
        }
    }
    
}
