# beamy-swift
Swift implementation (for iOS and macOS) of the beamy Bluetooth LE device framework. Beamy is a cross platform framework that allows for the sending of text, files, and other signals from one device to another using Bluetooth LE technology.

## Testing the code
In order to test the software, you will need to have two iPhones connected to your computer using the USB ports.

## Contributing
For guidelines and suggestions on how to contribute to this repository, please see the [Code of Conduct](https://github.com/ruddfawcett/beamy-swift/blob/master/CODE_OF_CONDUCT.md).

## License
This software is certified under the MIT License. Refer to the [license file](https://github.com/ruddfawcett/beamy-swift/blob/master/LICENSE) for details.

### Anticipated APIs

This project aspires to include the following API's:

- **Nearby Devices**: As beamy will rely on Bluetooth, it will be reliant on surrounding devices having their Bluetooth enabled. Thus, functionalities will be implemented to allow developers to filter devices by distance.

- **Sending Beams**: Beamy will have an API for sending various signals across Bluetooth. These methods will all have callbacks for success, failure, etc. on the sender's device.

- **Specific Device**: Using a Bluetooth ID, beamy will be able to send beams to specific devices in the nearby area.
- **Broadcasts**: Beamy will also be able to send beams to all devices in the surrounding area/radius as detected by a `nearbyDevices` method.

- **Accepting/Rejecting Beams**: Beamy will also implement methods for accepting/rejecting beams that will in turn tell the sender that the beam has been accepted/rejected.

### Goals

- [ ] Connect to devices across Bluetooth LE using existing APIs.
- [ ] Wrap around native APIs in order to send and receive beams cross platform.
- [ ] Start with iOS and macOS, but look to develop cross platform libraries.
- [ ] Start with sending plain text, but work up to sending photos/files.
- [ ] Send native device feedback (vibrations, etc.) from one device to another.
