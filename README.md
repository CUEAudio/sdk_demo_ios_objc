# CUE Live Implementation (iOS)
This demo project shows you how to integrate the CUE Audio Live Event SDK into your application.

## (1) Project Settings

Within your app target's `Build Phases`, add the following frameworks into `Link Binary With Libraries`:

     • Accelerate.framework
     • libc++.tbd

Within your Podfile, add the following:

### Download CUE Frameworks
In your local file system, locate the file `~/.netrc` (create if necessary) and insert your credentials, provided by CUE:

```
machine cueaudio.jfrog.io
login <myusername>
password <mypassword>
```

Next, navigate to your project root using the command line. Execute this command to get access to CUE Frameworks:

`pod repo-art add cocoapods-local "https://cueaudio.jfrog.io/cueaudio/api/pods/cocoapods-local"`

Next, add the following to your Podfile:

```
  pod "lottie-ios", '3.3.0'
  pod "CUELive-framework", '~> 3.0'
  pod "CUELive-bundle-Default", '~> 3.0'
  pod "engine", '~> 1.14'
  pod 'CUEBluetooth'
  pod 'TrueTime', '5.0.3'
  pod 'ReachabilitySwift', '5.0.0'
  pod 'MQTTClient', '0.15.3'
```

Now, add the following to the top of your Podfile:

```
plugin 'cocoapods-art', :sources => [
  'cocoapods-local'
]
```

Finally, add the follwing to the bottom of your Podfile (after the final `end`):

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == "lottie-ios"
      target.build_configurations.each do |config|
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      end
    end
  end
 end
```

In the future, to update pod versions, execute the following:

`pod repo-art update cocoapods-local`

`pod install`

If you do not use Pods, CUE can provide files directly.

### Build Settings

Next, in your target’s **Build Settings**, add `-ObjC` to **Other Linker Flags**.

![Linker Flags](https://s3.amazonaws.com/cue-sdk-integration/linker-flags.png)

## (2) Edit Info.plist

#### We require:
	• NSMicrophoneUsageDescription ("To sync to the music!")
	• NSPhotoLibraryUsageDescription ("To take photos and video of the show!")
	• NSPhotoLibraryAddUsageDescription ("To save photos and video of the show!")
	• NSCameraUsageDescription ("To take photos and video of the show!")
	
![Info.plist](https://s3.amazonaws.com/cue-sdk-integration/info-plist.png)	

##Integration

#### ***Swift***

Simply execute the following code:

```
// MARK: CUE Audio
    
    @IBAction func launchLightShowGUI(_ sender: Any) {
        let initialController = NavigationManager.initialController()
        initialController.modalPresentationStyle = .overFullScreen
        present(initialController, animated: true)
    }
```

#### ***Obj-C***

Add the `SwiftFile.swift` from the Obj-C Demo Project into your project. The contents consist of the following:

```
import Foundation
import CUELive

@objc class SwiftHelper: NSObject {

    @objc static func getInitialViewController() -> UIViewController {
        return NavigationManager.initialController()
    }
}
``` 

Next, in the `ViewController` from which you will launch the GUI, import the following:

```
#import "YourProjectName-Swift.h"
```

Next, execute the following code:

```
#pragma mark CUE Audio

//Launch Light Show W/ GUI
- (IBAction)launchLightShowGUI:(id)sender {
    UIViewController *initialController = [SwiftHelper getInitialViewController];
    initialController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:initialController animated:YES completion:NULL];
}

```

Make sure that the CUE ViewController is full screen. If it is not completely full screen, this can lead to crashes related to the CUE camera button and delegates.

## Configuration

The file `CUEConfig.plist` contains parameters that can be customized for your application. You can overwrite these parameters by including `CUEConfig.plist` in your project and including the keys and values you would like to overwrite. 

Note: If you include `CUEConfig.plist` in your project and also include a themed SDK other than `CUELiveBundle-Default`, your `CUEConfig.plist` will overwrite the `plist` file within `CUELiveBundle-MyTheme` and may cause incorrect behavior. Therefore, always ensure that, if you include `CUEConfig.plist` into your project and overwrite critical values like `apiKey` that these values are set correctly for your client. 

### API Key
The `apiKey` key is what uniquely identifies a client. It is 32 alpha-numeric characters. This API Key must be the same for a client on both iOS and Android platforms. 

The API Key also lets CUE modify the branding of a client remotely (on versions 2.3.1+). This way, if you are including the CUE SDK as a feature flag in multiple apps, you can simply use the `-Default` theme and do not need to provide custom branding in advance. Once a client purchases CUE services, we can update the SDK to a custom theme remotely. All you need to do is: 

(1) Ensure that the same unique API Key overwrites the default API Key within your `CUEConfig.plist` file within your project. 

(2) Fetch the CUE Theme associated with that API Key. You can do this by modifying `applicationDidFinishLaunching` within your `AppDelegate` file by including the line:


**If you hardcode your client API key:**
#### ***Swift***
``` swift
CUEMultiDownloader.fetchCUETheme()
```

#### ***Obj-C***
``` objectivec
[CUEMultiDownloader fetchCUETheme];
```

**If you set your API Key remotely:**
#### ***Swift***
``` swift
ApiKeyService.setup(apiKey: <#myClientApiKey#>)
CUEMultiDownloader.fetchCUETheme()
```

#### ***Obj-C***
``` objectivec
[ApiKeyService setupWithApiKey:<#myClientApiKey#>];
[CUEMultiDownloader fetchCUETheme];
```

Note: If you pull your client API Key from the server, it should be cached (e.g., `UserDefaults`) so that the user can access the light show even without a network connection. 

###Uses Microphone
The `usesMicrophone` flag determines if microphone access will be requsted. If set to `NO`, this portion of the onboarding is removed. Also, the `Demo` tab is removed from the Side Menu, since this requires microphone access.

###Has Exit
The `hasExit` flag determines if the `Exit` button will be included in the CUE navigation menu. 

###Has Exit On Homescreen
The `hasExitOnHomescreen` flag determines if there should be an `X` button in the top right-hand corner of the homescreen to exit the CUE portion of your app. This is separate from 

###Font
You can overwrite the CUE font by replacing the `preferredFontPostScriptName` value with the `Post Script Name` of the font you wish the CUE SDK to use. 

###Primary Color
`primaryColor` is the theme color of the CUE SDK. This can be configured by CUE remotely as long as this app utilizes a unique API Key. 

###Navigation Header Images
In `CUELive.bundle` there is both `headerImage.png` and an optional `headerBackgroundImage.jpg` both can be overwritten to change the apperence of the CUE navigation.

###Deprecated values
`secondaryColor` is deprecated as of version `2.0`.
`clientId` is deprecated as of version `2.0`.
`hasBackgroundImage` is deprecated as of version `2.0`.

## Demo Project
To run the demo project, simply open the project and run. If you get any compiler errors, you will be able to solve them by setting up repo-art using the implementation instructions above and running: 

```
rm -rf Pods/
rm -rf Podfile.lock
pod install
```

# QA

## Manual Script

* Once the CUE SDK is integrated and your project successfully compiles, launch the CUE portion of your app.

* On the homescreen, please press the camera button to take a photo. Next, hold the button for at least three seconds to take a video. The photo and video should save successfully to your photos. 

* In the navigation menu, make sure the correct menu items are listed. 
	* Live
	* Demo
	* Help
	* Info
	* Exit (iOS only)

* Next, go to `Demo`. Complete the demo for all the services listed, which can be up to three items: `Light Show`, `Selfie Cam`, and `Trivia`. 


## Update Instructions

Please use the latest version of CUELive-Framework (3.X), as well as the latest version of the engine. Now make sure your Pods are up to date (including CUE's private pods). You can do so by running the following:

```
rm -rf Pods/
rm -rf Podfile.lock
pod repo-art update cocoapods-local
pod install
```

