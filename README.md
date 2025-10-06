# CUE Live Demo Objective C
This demo project shows you how to integrate the CUE Audio Live Event SDK into your application.

## Installation 
### Install **CocoaPods**, and the CocoaPods *Artifactory* plugin:

```
brew install cocoapods
gem install cocoapods-art
```

### Download CUE Frameworks
In your local file system, locate the file `~/.netrc` (create if necessary) and insert your credentials, provided by CUE:

```
machine cueaudio.jfrog.io
login <myusername>
password <mypassword>
```

Next, navigate to your project root using the command line. Execute this command to get access to CUE Frameworks and install the pod:

`pod repo-art add cocoapods-local "https://cueaudio.jfrog.io/cueaudio/api/pods/cocoapods-local"`

`pod install`

### How to update pod versions later
In the future, to update pod versions, execute the following:

`pod repo-art update cocoapods-local`

`pod install`

## Demo Project
To run the demo project, please open **CUEControllerDemo.xcworkspace** in XCode and run. 

### Build Settings

Please check your target’s **Build Settings**, item **Other Linker Flags**, it should contain `-ObjC`flag.

![Linker Flags](https://s3.amazonaws.com/cue-sdk-integration/linker-flags.png)

### Possible signing issue
When demo project is built first time the signing issue may be occured: *"Signing for "CUELive-bundle-Default-CUELive" requires a development team. Select a development team in the Signing & Capabilities editor."*

In this case:
1. Select "Pods" item in Project Navigator.
2. Select for target "CUELive-bundle-Default-CUELive" tab "Signing and Capabilities".
3. Choose correct "Team" value for code signing.

![Linker Flags](https://s3.amazonaws.com/cue-sdk-integration/code-signing.png)

***Now the demo project is ready to be used!***

## Integration

Simply execute the following code:

```
//Launch Light Show W/ GUI    

    - (IBAction)launchLightShowGUI:(id)sender {
        UIViewController *initialController = [SwiftHelper getInitialViewController];
        initialController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:initialController animated:YES completion:NULL];
    }
```

Make sure that the CUE ViewController is **full screen**. If it is not completely full screen, this can lead to crashes related to the CUE camera button and delegates.

## Associated Domains

In your project settings, you should add two Associated Domains as shown here:

<img width="771" height="150" alt="Screenshot 2025-10-06 at 12 07 52 PM" src="https://github.com/user-attachments/assets/f44a487b-5ffe-41b3-81ca-e9898d570baf" />


## Using PRIVACY flag

You can pass optional PRIVACY flag to prevent collecting and sending to the server any user information. SDK initialization in this case looks like that:

```
    - (IBAction)launchLightShowGUI:(id)sender {
        NSDictionary *params = @{@"PRIVACY" : @YES};
        UIViewController *initialController = [SwiftHelper getInitialViewController:params];
        initialController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:initialController animated:YES completion:NULL];
    }
```

## Configuration

The file `CUEConfig.plist` contains parameters that can be customized for your application. You can overwrite these parameters by including `CUEConfig.plist` in your project and including the keys and values you would like to overwrite. 

Note: If you include `CUEConfig.plist` in your project and also include a themed SDK other than `CUELiveBundle-Default`, your `CUEConfig.plist` will overwrite the `plist` file within `CUELiveBundle-MyTheme` and may cause incorrect behavior. Therefore, always ensure that, if you include `CUEConfig.plist` into your project and overwrite critical values like `apiKey` that these values are set correctly for your client. 

### API Key
The `apiKey` key is what uniquely identifies a client. It is 32 alpha-numeric characters. This API Key must be the same for a client on both iOS and Android platforms. 

The API Key also lets CUE modify the branding of a client remotely (on versions 2.3.1+). This way, if you are including the CUE SDK as a feature flag in multiple apps, you can simply use the `-Default` theme and do not need to provide custom branding in advance. Once a client purchases CUE services, we can update the SDK to a custom theme remotely. All you need to do is: 

(1) Ensure that the same unique API Key overwrites the default API Key within your `CUEConfig.plist` file within your project. 

(2) Fetch the CUE Theme associated with that API Key. You can do this by modifying `applicationDidFinishLaunching` within your `AppDelegate` file by including the line:


**If you hardcode your client API key:**
``` objectivec
[CUEMultiDownloader fetchCUETheme];
```

**If you set your API Key remotely:**
``` objectivec
[ApiKeyService setupWithApiKey:<#myClientApiKey#>];
[CUEMultiDownloader fetchCUETheme];
```

Note: If you pull your client API Key from the server, it should be cached (e.g., `UserDefaults`) so that the user can access the light show even without a network connection. 

# QA

## Manual Script

* Once the CUE SDK is integrated and your project successfully compiles, launch the CUE portion of your app.

* On the homescreen, please press the camera button to take a photo / start capture video. The photo and video should save successfully to your photos. 

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
