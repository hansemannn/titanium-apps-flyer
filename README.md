# Titanium AppsFlyer SDK

<img src="./.github/apps-flyer-logo.png" height="80" />

Use the native AppsFlyer SDK's (iOS/Android) in Titanium!

## Requirements

- [x] iOS 12 or later
- [x] Android 5 or later
- [x] Titanium SDK 9.2.0 or later
- [x] An AppsFlyer account

## APIs

### initialize(params)
```js
AppsFlyer.initialize({
  devKey: 'YOUR_DEV_KEY',
  appID: 'idXXXXXXXXX', // iOS only, set to your App Store ID
  authorizationTimeout: 60, // iOS only, used to defer the start() process
  debug: true
 });
```

### start()
```js
AppsFlyer.start();
```

### requestTrackingAuthorization(callback) (iOS only)
```js
AppsFlyer.requestTrackingAuthorization({ status }) => {
  // For example, status === 3 is "authorized"
});
```

### trackingAuthorizationStatus
```js
console.warn('AUTHORIZED: ', AppsFlyer.trackingAuthorizationStatus === 3);
```

### fetchAdvertisingIdentifier(callback)
```js
AppsFlyer.fetchAdvertisingIdentifier({ idfa }) => {
  // Use the IDFA (iOS) or AID (Android)
});
```

### logEvent(params)
```js
AppsFlyer.logEvent('my_event', { param1: 'hello', param2: 'world' });
```

## Example

See the example/app.js for details

## License

MIT

## Author

Hans Knöchel
