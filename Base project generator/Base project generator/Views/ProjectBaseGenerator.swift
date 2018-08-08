//
//  ProjectBaseGenerator.swift
//  Base project generator
//
//  Created by Ahmad Mahmoud on 8/2/18.
//  Copyright © 2018 Ahmad Mahmoud. All rights reserved.
//

import Cocoa

class ProjectBaseGenerator: BaseViewController {
    //
    @IBOutlet weak var projectNameTextField: NSTextField!
    @IBOutlet weak var errorLabel: NSTextField!
    
    @IBAction func proceedButton(_ sender: NSButton) {
        if (projectNameTextField.stringValue.isEmpty) {
            errorLabel.stringValue = "Project name field can not be empty !"
        }
        else {
            errorLabel.stringValue = ""
            helpers = Helpers(projectNameString: projectNameTextField.stringValue)
            //
            // Create root folder
            let mainFolder = try? fileSystem.createFolder(at: helpers.getUserDesktopPath() + "/" + projectNameTextField.stringValue)
            // Assets, strings files, etc..
            let resourcesFolder = try? mainFolder?.createSubfolder(named: FileNames.resources.rawValue)
            let localizableFile = try? resourcesFolder??.createFile(named: FileNames.localizable.rawValue + ".strings")
            let localizableStr = helpers.buildClassIHeaderText(className: FileNames.localizable.rawValue + ".strings")
            try? localizableFile??.write(string: localizableStr)
            //
            let uiFolder = try? mainFolder?.createSubfolder(named: FileNames.ui.rawValue)
            //
            let navigatorFile = try? uiFolder??.createFile(named: FileNames.navigator.rawValue + ".swift")
            let navigatorClassStr = helpers.buildClassIHeaderText(className: FileNames.navigator.rawValue + ".swift") + helpers.buildImportHeader() +
            "class" + FileNames.navigator.rawValue + " : BaseNavigationCoordinator  {\n\n" +
            "    //\n" +
            "    func startInitialView() {\n" +
            "        // Write initial (first) view controller navigation here\n" +
            "    }\n\n" + "}"
            try? navigatorFile??.write(string: navigatorClassStr)
            //
            let reusableViews = try? uiFolder??.createSubfolder(named: FileNames.reusableViews.rawValue)
            let _ = try? reusableViews??.createSubfolder(named: FileNames.customCells.rawValue)
            let _ = try? uiFolder??.createSubfolder(named: FileNames.viewsPlusControllers.rawValue)
            let _ = try? uiFolder??.createSubfolder(named: FileNames.storyboards.rawValue)
            //
            let networkingFolder = try? mainFolder?.createSubfolder(named: FileNames.networking.rawValue)
            //
            let APISFile = try? networkingFolder??.createFile(named: FileNames.apis.rawValue + ".swift")
            let networkClassStr = helpers.buildClassIHeaderText(className: FileNames.apis.rawValue + ".swift") + helpers.buildImportHeader() +
            "enum " + FileNames.apis.rawValue + " {\n\n" +
            "    case refreshToken()\n\n" +
                "}\n\n" +
            "extension " + FileNames.apis.rawValue + ": GenericAPIs {\n\n" +
            "    // override default url building behavior\n" +
            "    var baseURL: URL {\n" +
            "        return " + "URL(string:" + "" + ")!" +
            "\n    }" +
            "\n\n    // method + path\n" +
            "    var route: Route {\n" +
            "        return .post(\"\")" + "\n    }" +
            "\n\n" +
            "    var headers: [String: String]? {\n" +
            "        return nil\n    }" +
            "\n\n" +
            "    // Encoding + Parameters\n" +
            "    // Use `URLEncoding()` as default when not specified\n" +
            "    var parameters: Parameters? {\n" +
            "        return nil\n    }" +
            "\n\n" +
            "    var sampleData: Data { return Data() }" + "\n\n}"
            try? APISFile??.write(string: networkClassStr)
            //
            let errorHandlerFile = try? networkingFolder??.createFile(named: FileNames.humanReadableErrorHandler.rawValue + ".swift")
            let errorHandlerClassStr = helpers.buildClassIHeaderText(className: FileNames.humanReadableErrorHandler.rawValue + ".swift") + helpers.buildImportHeader() +
            "class " + FileNames.humanReadableErrorHandler.rawValue + " : GenericErrorHandler {\n\n" +
            "    override func statusCodeError(_ statusCode: Int, errorBody: String?, request: URLRequest?, response: URLResponse?) -> String {\n" +
            "        switch statusCode {\n" +
            "        case 401:\n" +
            "            errorMessage = \"Not authorised ! \" + errorBody!\n" +
            "        case 404:\n" +
            "            errorMessage = \"Not found !\"\n" +
            "        default:\n" +
            "            errorMessage = \"Unknown error !\"\n" +
            "            break\n" +
            "        }\n" +
            "        return errorMessage!\n" +
            "    }\n\n" +
            "    override func networkingError(_ error: LucidMoyaNetworkingError) -> String {\n" +
            "        return \"\"\n" +
            "    }\n\n" +
            "    override func moyaError(_ error: MoyaError) -> String {\n" +
            "        return \"\"\n    }\n\n}"
            try? errorHandlerFile??.write(string: errorHandlerClassStr)
            //
            let connectorFile = try? networkingFolder??.createFile(named: FileNames.apiConnector.rawValue + ".swift")
            let connectorClassStr = helpers.buildClassIHeaderText(className: FileNames.apiConnector.rawValue + ".swift") + helpers.buildImportHeader() +
            "class " + FileNames.apiConnector.rawValue + " : GenericConnector {\n\n" +
            "    private final var apiProvider : APIsProvider<APIs>!\n\n" +
            "    required override init() {\n" +
            "        super.init()\n" +
            "        //" +
            "        GenericErrorConfigurator.defaultErrorHandler(" + FileNames.humanReadableErrorHandler.rawValue + "())\n" +
            "        // With formatted output\n" +
            "        let networkLogger = NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)\n" +
            "        //\n" + "        let plugins : [PluginType] = [networkLogger]\n" +
            "        apiProvider = APIsProvider<APIs>(plugins: plugins)\n" +
            "    }\n\n" +
            "    override func getTokenRefreshService() -> Single<Response> {\n" +
            "        return apiProvider.rx.request(.refreshToken())\n" +
            "    }\n\n" +
            "    // Write your network calls here\n\n" +
            "}"
            try? connectorFile??.write(string: connectorClassStr)
            //
            let globalConfFolder = try? mainFolder?.createSubfolder(named: FileNames.globalConf.rawValue)
            //
            let enviromentsConfFile = try? globalConfFolder??.createFile(named: FileNames.environments.rawValue + ".swift")
            let enviromentsConfClassStr = helpers.buildClassIHeaderText(className: FileNames.environments.rawValue + ".swift") + helpers.buildImportHeader() +
            "public enum " + FileNames.environments.rawValue + " : String {\n\n" +
            "    // Modes\n" +
            "    case Debug\n" +
            "    case Staging\n" +
            "    case Release\n\n" +
            "    // Variables\n" +
            "    var baseURL: String {\n" +
            "        switch self {\n" +
            "        case .Debug:\n" +
            "            return \"https://debug-api.myservice.com\"\n" +
            "        case .Staging:\n" +
            "            return \"https://staging-api.myservice.com\"\n" +
            "        case .Release:\n" +
            "            return \"https://api.myservice.com\"\n" +
            "        }\n" +
            "    }\n\n" +
            "}"
            try? enviromentsConfFile??.write(string: enviromentsConfClassStr)
            //
            let storyboardFile = try? globalConfFolder??.createFile(named: FileNames.storyboard.rawValue + ".swift")
            let storyboardClassStr = helpers.buildClassIHeaderText(className: FileNames.storyboard.rawValue + ".swift") + helpers.buildImportHeader() +
            "// The unified place where we state all the storyboards we have in our application]\n" +
                "enum " + FileNames.storyboard.rawValue + " : String {\n\n" +
                "    case main\n\n" + "}"
            try? storyboardFile??.write(string: storyboardClassStr)
            //
            let globalKeysFile = try? globalConfFolder??.createFile(named: FileNames.globalKeys.rawValue + ".swift")
            let globalKeysClassStr = helpers.buildClassIHeaderText(className: FileNames.globalKeys.rawValue + ".swift") + helpers.buildImportHeader() +
            "struct " + FileNames.globalKeys.rawValue + " : BuildVariantService {\n\n" +
            "    static let getEnvironmentVariables: Environment = {\n" +
            "        return getEnvironment(Environment.self)\n" +
            "    }()\n\n" + "}"
            try? globalKeysFile??.write(string: globalKeysClassStr)
            //
            let _ = try? mainFolder?.createSubfolder(named: FileNames.models.rawValue)
            //
            let _ = try? mainFolder?.createSubfolder(named: FileNames.adapters.rawValue)
            //
            let _ = try? mainFolder?.createSubfolder(named: FileNames.utils.rawValue)
            //
            let _ = try? mainFolder?.createSubfolder(named: FileNames.supportingFiles.rawValue)
            //
            let podFile = try? mainFolder?.createFile(named: FileNames.podFile.rawValue)
            let podFileStr = "platform :ios, '9.1'\n" + "use_frameworks!\n\n" +
                "target '" + projectNameTextField.stringValue + "' do\n" +
                "  # Add your pods below\n\n" + "\nend\n\n\n" +
                "# The purpose of the following code is to solve a bug in Cocoapods that prevent the storyboard to render when a Designable &/or Inspetable component(s) from a different module is used\n\n" +
                "# Ref : https://github.com/CocoaPods/CocoaPods/issues/7606#issuecomment-381279098\n" +
                "post_install do |installer|\n" +
                "    installer.pods_project.targets.each do |target|\n" +
                "        target.build_configurations.each do |config|\n" +
                "            config.build_settings.delete('CODE_SIGNING_ALLOWED')\n" +
                "            config.build_settings.delete('CODE_SIGNING_REQUIRED')\n" +
                "        end\n" +
                "    end\n" +
                "    installer.pods_project.build_configurations.each do |config|\n" +
                "        config.build_settings.delete('CODE_SIGNING_ALLOWED')\n" +
                "        config.build_settings.delete('CODE_SIGNING_REQUIRED')\n" +
                "    end\n" + "end\n"
            try? podFile??.write(string: podFileStr)
        }
    }

}

