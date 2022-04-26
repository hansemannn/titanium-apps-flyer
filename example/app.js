import AppsFlyer from 'ti.appsflyer';

AppsFlyer.initialize({ devKey: 'xxx', appID: 'yyy' /* iOS-only */ });
AppsFlyer.start();

AppsFlyer.logEvent('event_name', { key1: 'value1', key2: 'value2', /* ... */ });