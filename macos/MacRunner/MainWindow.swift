import Cocoa
import FlutterEmbedderMac


class MainWindow: NSWindow {
  @IBOutlet weak var flutterViewController: FLEViewController!

  override func awakeFromNib() {
    let assets = NSURL.fileURL(withPath: "flutter_assets", relativeTo: Bundle.main.resourceURL)
//    flutterViewController.add(FLEColorPanelPlugin())
//    flutterViewController.add(FLEFileChooserPlugin())
//    flutterViewController.add(FLEMenubarPlugin())
    flutterViewController.launchEngine(
      withAssetsPath: assets,
      asHeadless: false,
      commandLineArguments: [CommandLine.arguments[0], "--dart-non-checked-mode"])

    super.awakeFromNib()
  }
}

