import 'package:firebase_core/firebase_core.dart';

/// Firebase options for web app required to access database
/// IMPORTANT: These data should not be reveal in public repo
///
/// Note: Web app required only for quick testing
const webFirebaseOption = FirebaseOptions(
    apiKey: 'AIzaSyCkhyM1Ebo6LhY0kWe2s9ed70hqoJb5NHo',
    authDomain: 'teachentapp.firebaseapp.com',
    databaseURL:
        'https://teachentapp-default-rtdb.europe-west1.firebasedatabase.app',
    projectId: 'teachentapp',
    storageBucket: 'teachentapp.appspot.com',
    messagingSenderId: '472666586305',
    appId: '1:472666586305:web:834e35e0a30111587a2840',
    measurementId: 'G-N1R9WC63JZ');

/// Firebase options for android app required to access database
/// IMPORTANT: These data should not be reveal in public repo
const androidFirebaseOption = FirebaseOptions(
    apiKey: 'AIzaSyCxqK28vbsmVe3aDWFqiKYhdqTNbvOO2Vo',
    databaseURL:
        'https://teachentapp-default-rtdb.europe-west1.firebasedatabase.app',
    projectId: 'teachentapp',
    storageBucket: 'teachentapp.appspot.com',
    messagingSenderId: '472666586305',
    appId: '1:472666586305:android:a63bc940607d07217a2840');
