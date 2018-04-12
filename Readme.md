# Panasonic IP setup
macOS application to discover and configure network settings of Panasonic cameras. Alternative to the *windows only* [Easy IP Setup Tool](https://security.panasonic.com/download/tools/#easy).

![Screenshot of the application](Graphics/Screenshot.jpg)

## Development setup
To start developing clone this repo with all its submodules
```shell
git clone --recurse-submodules git@github.com:dPro-Software/Panasonic-IP-setup.git
```
Generate the Xcode project for the BlueSocket SPM module
```
cd framework
swift package generate-xcodeproj
```
