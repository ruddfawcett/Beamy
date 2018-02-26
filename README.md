# beamy-swift
Swift implementation (for iOS and macOS) of the beamy Bluetooth LE device framework. Beamy is a cross platform framework that allows for the sending of text, files, and other signals from one device to another using Bluetooth LE technology.

## Installation

To install Beamy, simply build the project in Xcode and drag the Beamy.framework file to your project. CocoaPods/Carthage support coming soon.

## Use

Getting up and running with Beamy is easy. Simply start a shared instance of Beamy in your AppDelegate.

```swift
// Start Beamy with a unique UUID. You can generate one using `uuidgen` in your Terminal.
Beamy.initiate(UUID: "2C22299E-6C85-4268-B25D-029DF577CA3D")
```

Anywhere you would like to use Beamy in your app, make sure to designate that class as the responder class for Beamy's Bluetooth manager:

```swift
Beamy.sharedInstance.manager!.delegate = self
```

You can then implement any of the following delegate methods in your class:

```swift
func manager(didDiscover device: BeamyDevice)
func manager(didDiscover message: BeamyMessage, fromDevice device: BeamyDevice)
func manager(didReceiveMessage message: BeamyMessage, fromDevice device: BeamyDevice)
func manager(didBeginAdvertising advertising: Bool, withError error: Error?)
func manager(didUpdateState state: CBManagerState, fromPeripheral peripheral: CBPeripheralManager)
```

Take a look through the Beamy framework folder for thorough documentation, or check out the Demo project for a sample use case.

## Testing
In order to test the Bluetooth capabilities of Beamy, you will need to have two iPhones connected to your computer with Xcode.

## The Future

### Goals
This alpha version of Beamy completes many of the initial goals of the project.

- [x] Connect to devices across Bluetooth LE using existing APIs.
- [x] Wrap around native APIs in order to send and receive beams cross platform.
- [x] Start with iOS and macOS, but look to develop cross platform libraries.
- [x] Start with sending plain text, but work up to sending photos/files.
- [ ] Send native device feedback (vibrations, etc.) from one device to another.

### Future APIs
Ideally, this project aspires to include the following API's:

- **Specific Device**: Using a Bluetooth ID, beamy will be able to send beams to specific devices in the nearby area.

- **Accepting/Rejecting Beams**: Beamy will also implement methods for accepting/rejecting beams that will in turn tell the sender that the beam has been accepted/rejected.


## Contributors
Beamy was conceived and created by [Rudd Fawcett (@ruddfawcett)](https://github.com/ruddfawcett). Special thanks to [Nalu Concepcion (@naluconcepcion)](https://github.com/naluconcepcion) for help with documentation

## Contributing
For guidelines and suggestions on how to contribute to this repository, please see the [Code of Conduct](https://github.com/ruddfawcett/beamy-swift/blob/master/CODE_OF_CONDUCT.md).

## License
Beamy is available under the MIT license. See the [LICENSE](https://github.com/ruddfawcett/beamy-swift/blob/master/LICENSE) file for more info.
