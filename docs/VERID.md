<!-- Generated by documentation.js. Update this documentation by updating the source code. -->

### Table of Contents

-   [load](#load)
-   [unload](#unload)
-   [register](#register)
-   [authenticate](#authenticate)
-   [captureLiveFace](#captureliveface)
-   [getRegisteredUsers](#getregisteredusers)
-   [deleteUser](#deleteuser)
-   [Bearing](#bearing)
-   [LivenessDetection](#livenessdetection)
-   [SessionSettings](#sessionsettings)
    -   [prototype](#prototype)
-   [LivenessDetectionSessionSettings](#livenessdetectionsessionsettings)
    -   [prototype](#prototype-1)
-   [AuthenticationSessionSettings](#authenticationsessionsettings)
    -   [prototype](#prototype-2)
-   [RegistrationSessionSettings](#registrationsessionsettings)
    -   [prototype](#prototype-3)

## load

Load Ver-ID

**Parameters**

-   `apiSecret` **[string](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/String)?** API secret obtained at <https://dev.ver-id.com/admin/register>. If you omit this parameter you must specify the API secret in your app's Info.plist file (iOS) or manifest.xml (Android).
-   `callback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called when the Ver-ID load operation finishes. The callback has a boolean parameter `success` indicating the success of the load operation.
-   `errorCallback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called if the load operation fails.

## unload

Unload Ver-ID
Call this function to free resources when your app no longer requires Ver-ID.

## register

Register user

**Parameters**

-   `settings` **RegistrationSessionSettings** An instance of RegistrationSessionSettings or null to use default settings.
-   `callback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called if the registration session finishes.
-   `errorCallback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called if the registration session fails.

## authenticate

Authenticate user

**Parameters**

-   `settings` **AuthenticationSessionSettings** An instance of AuthenticationSessionSettings or null to use default settings. With the default settings the session will not use anti-spoofing.
-   `callback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called if the authentication session completes.
-   `errorCallback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called if the session fails.

## captureLiveFace

Capture live face

**Parameters**

-   `settings` **LivenessDetectionSessionSettings** An instance of LivenessDetectionSessionSettings or null to use default settings.
-   `callback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called if the liveness detection session completes.
-   `errorCallback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called if the session fails.

## getRegisteredUsers

Retrieve a list of registered users

**Parameters**

-   `callback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called if the opration succeeds. The response will be an array of objects with a string member "userId" and an array member "bearings" with int members corresponding to the user's registered bearings as defined by the Bearing constants.
-   `errorCallback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called if the operation fails.

## deleteUser

Delete a registered user

**Parameters**

-   `userId` **[string](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/String)** The id of the user to delete.
-   `callback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called if the operation succeeds.
-   `errorCallback` **[function](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Statements/function)** Function to be called if the operation fails.

## Bearing

Constants representing the bearing of a face looking at the camera

**Properties**

-   `STRAIGHT` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Facing the camera straight on
-   `UP` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Looking up
-   `RIGHT_UP` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Looking right and up
-   `RIGHT` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Looking right
-   `RIGHT_DOWN` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Looking right and down
-   `DOWN` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Looking down
-   `LEFT_DOWN` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Looking left and down
-   `LEFT` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Looking left
-   `LEFT_UP` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Looking left and up

## LivenessDetection

Constants representing liveness detection settings

**Properties**

-   `NONE` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** No liveness detection
-   `REGULAR` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Regular liveness detection
-   `STRICT` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Strict liveness detection (requires the user to register additional bearings)

## SessionSettings

**Parameters**

-   `expiryTime` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Seconds before the session expires (optional, default `30`)
-   `numberOfResultsToCollect` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Number of results (face images) to collect before the session returns (optional, default `1`)

### prototype

**Properties**

-   `expiryTime` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Seconds before the session expires
-   `numberOfResultsToCollect` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Number of results (face images) to collect before the session returns
-   `showGuide` **[boolean](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Boolean)** Show a session guide to the user before the face image collection begins
-   `showResult` **[boolean](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Boolean)** Show the result of the session to the user before returning it to your app

## LivenessDetectionSessionSettings

**Extends veridPlugin.SessionSettings**

**Parameters**

-   `numberOfResultsToCollect` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** Number of results (face images) to collect before the session returns (optional, default `2`)

### prototype

**Properties**

-   `bearings` **[Array](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Array)** The user will be prompted to assume one or more of these bearings
-   `segmentDuration` **[number](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Number)** The minimum duration of each segment where the user is asked to assume a bearing
-   `includeFaceTemplatesInResult` **[boolean](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Boolean)** Set to `true` if you plan using the result for face comparison

## AuthenticationSessionSettings

**Extends veridPlugin.LivenessDetectionSessionSettings**

**Parameters**

-   `userId` **[string](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/String)** The ID of the user to authenticate (must be previously registered)
-   `livenessDetection` **veridPlugin.LivenessDetection** Liveness detection settings

### prototype

**Properties**

-   `userId` **[string](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/String)** The ID of the user to authenticate (must be previously registered)
-   `livenessDetection` **veridPlugin.LivenessDetection** Liveness detection settings

## RegistrationSessionSettings

**Extends SessionSettings**

**Parameters**

-   `userId` **[string](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/String)** The ID of the user to register
-   `livenessDetection` **veridPlugin.LivenessDetection** Liveness detection settings
-   `showGuide` **[boolean](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Boolean)** Show a session guide to the user before the face image collection begins
-   `showResult` **[boolean](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Boolean)** Show the result of the session to the user before returning it to your app

### prototype

**Properties**

-   `userId` **[string](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/String)** The ID of the user to register
-   `livenessDetection` **veridPlugin.LivenessDetection** Liveness detection settings
-   `bearingsToRegister` **[Array](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Array)** Face bearings to register in this session
-   `appendIfUserExists` **[boolean](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/Boolean)** Append the registered faces to a user with the same ID if one exists