# Ver-ID Person Plugin for Cordova

## Introduction

Ver-ID gives your users the ability to authenticate using their face.

## Adding Ver-ID Person Plugin to Your Cordova App

1. [Request an API secret](https://dev.ver-id.com/admin/register) for your app.
1. Install the plugin.

    ~~~bash
    cordova plugin add https://github.com/AppliedRecognition/Ver-ID-Person-Cordova-Plugin.git
    ~~~ 
3. If your app includes iOS platform:
    - Open Cordova app's iOS project in Xcode.
    - Ensure the project's deployment target is iOS 11 or newer.
    - In build settings specify Swift version as 4.2.
    - Open your app's **Info.plist** file and and ensure it contains an entry for `NSCameraUsageDescription`.
    - Still in the **Info.plist** file add the following entry, substituting `[your API secret]` for the API secret obtained after registration in step 1:

        ~~~xml
        <key>com.appliedrec.verid.apiSecret</key>
        <string>[your API secret]</string>
        ~~~
4. If your app includes Android platform:
    - Ensure your app targets Android API level 18 or newer.
    - Open your app's **AndroidManifest.xml** file and add the following tag in `<application>` replacing `[your API secret]` with the API secret your received in step 1:

        ~~~xml
        <meta-data 
           android:name="com.appliedrec.verid.apiSecret" 
           android:value="[your API secret]" />
        ~~~
    - Your application must use **Theme.AppCompat** theme (or its descendant).
    - In your manifest's `<manifest>` element ensure that the `android:minSdkVersion` attribute of `<uses-sdk>` element is set to `"18"` or higher.

## Loading Ver-ID

Ver-ID is loaded implicitly with all API calls. The load operation may take up to a couple of seconds. You may wish to load Ver-ID before calling the API if you want to minimise the delay between issuing the API call and the Ver-ID Credentials user interface appearing.

You may also load Ver-ID using the `load` call if you are unable to specify your API secret in your app's plist or manifest file.

~~~javascript
verid.load(function() {
    // Ver-ID loaded successfully
    // You can now run registration, authentication or liveness detection
}, function() {
    // Ver-ID failed to load
});
~~~
Or if you prefer to specify the API secret in your code instead of your app's manifest or plist:

~~~javascript
var apiSecret = "..."; // Alternative way to set your Ver-ID API secret

verid.load(apiSecret, function(){
    // Ver-ID loaded successfully
    // You can now run registration, authentication or liveness detection
}, function(){
    // Ver-ID failed to load
});
~~~
    
## Register and Authenticate User From Javascript

The Ver-ID Person plugin module will be available in your script as a global variable `verid`.

~~~javascript
var userId = "myUserId"; // String with an identifier for the user

// Registration
function register() {
    var settings = new verid.RegistrationSessionSettings(userId);
    settings.showResult = true; // If you wish the plugin to show the result of the session to the user

    verid.register(settings, function(response) {
        if (response.outcome == verid.SessionOutcome.SUCCESS) {
            // User registered
            // Run an authentication session
            authenticate();
        }
    }, function() {
        // Handle the failure
    });
}

// Authentication
function authenticate() {
    var settings = new verid.AuthenticationSessionSettings(userId);
    settings.showResult = true; // If you wish the plugin to show the result of the session to the user
    
    verid.authenticate(settings, function(response) {
        if (response.outcome == verid.SessionOutcome.SUCCESS) {
            // User authenticated
        }
    }, function() {
            // Handle the failure
    });
}

// Load Ver-ID before running registration or authentication
verid.load(function(){
    // Ver-ID loaded successfully
    // Run a registration session
    register();  
}, function(){
    // Ver-ID failed to load
});
~~~

## Liveness Detection

In a liveness detection session the user is asked to asume a series of random poses in front of the camera.

Liveness detection sessions follow he same format as registration and authentication.

### Extracting face templates for face comparison
~~~javascript
// Load Ver-ID before running liveness detection
verid.load(function(){
    // Ver-ID loaded successfully  
    // Run a liveness detection session  
    var settings = verid.LivenessDetectionSessionSettings();
    settings.includeFaceTemplatesInResult = true;
    verid.captureLiveFace(settings, function(response) {
        // Session finished
        if (response.outcome == verid.SessionOutcome.SUCCESS) {            
            var faceTemplates = response.getFaceComparisonTemplates(verid.Bearing.STRAIGHT);
            // You can use the above templates to compare the detected face to faces from other sessions (see Comparing Faces section below)
        }
    }, function() {
        // Session failed
    });
}, function(){
    // Ver-ID failed to load  
});
~~~

### Face detection session without asking for poses
~~~javascript
// Load Ver-ID before running liveness detection
verid.load(function(){
    // Ver-ID loaded successfully  
    // Run a liveness detection session  
    var settings = verid.LivenessDetectionSessionSettings();
    // We only want to collect one result
    settings.numberOfResultsToCollect = 1;
    // Ask the user to assume only one bearing (straight)
    settings.bearings = [verid.Bearing.STRAIGHT];
    verid.captureLiveFace(settings, function(response) {
        // Session finished
    }, function() {
        // Session failed
    });
}, function(){
    // Ver-ID failed to load  
});
~~~

### Liveness detection session defining the bearings (poses) the user may be asked to assume
~~~javascript
// Load Ver-ID before running liveness detection
verid.load(function(){
    // Ver-ID loaded successfully  
    // Run a liveness detection session  
    var settings = verid.LivenessDetectionSessionSettings();
    // The user will be asked to look straight at the camera and then either left or right
    settings.bearings = [verid.Bearing.STRAIGHT, verid.Bearing.LEFT, verid.Bearing.RIGHT];
    verid.captureLiveFace(settings, function(response) {
        // Session finished
    }, function() {
        // Session failed
    });
}, function(){
    // Ver-ID failed to load  
});
~~~

## Session Response Format

The callback of a successful session will contain [an object](./module-verid.SessionResult.html) that represents the result of the session.

## Comparing Faces

After collecting two templates as outlined in the Liveness Detection section above run:

~~~javascript
var score = veridutils.compareFaceTemplates(template1, template2);
~~~

The `score` variable will be a value between `0` and `1`:

 - `0` no similarity between the two face templates 
 - `1` templates are identical

## Module API Reference

 - [Ver-ID](./module-verid.html)
