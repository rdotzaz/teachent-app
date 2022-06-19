import 'package:firebase_core/firebase_core.dart';

/// Firebase options for web app required to access database
///
/// Note: Web app required only for quick testing
const webFirebaseOption = FirebaseOptions(
    apiKey: 'WEB_API_KEY',
    authDomain: 'AUTH_DOMAIN',
    databaseURL:
        'DATABASE_URL',
    projectId: 'PROJECT_ID',
    storageBucket: 'STORAGE_BUCKET',
    messagingSenderId: 'MESSAGING_ID',
    appId: 'WEB_API_ID');

/// Firebase options for android app required to access database
const androidFirebaseOption = FirebaseOptions(
    apiKey: 'ANDROID_API_KEY',
    databaseURL:
        'DATABASE_URL',
    projectId: 'PROJECT_ID',
    storageBucket: 'STORAGE_BUCKET',
    messagingSenderId: 'MESSAGING_ID',
    appId: 'ANDROID_API_ID');
