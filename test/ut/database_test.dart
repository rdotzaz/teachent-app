import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:teachent_app/common/data_manager.dart';
import 'package:teachent_app/database/database.dart';
import 'package:teachent_app/view/teachent_app.dart';

/// Based on https://github.com/firebase/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart
/// Use setupFirebaseAuthMocks implementation to handle Firebase Database
void setFirebaseDatabase() {
    MethodChannelFirebase.channel.setMockMethodCallHandler((function) async {
        if (function.method == 'Firebase#initializeCore') {
            return [
                {
                    'name': defaultFirebaseAppName,
                    'options': {
                        'apiKey': 'AIzaSyCkhyM1Ebo6LhY0kWe2s9ed70hqoJb5NHo',
                        'authDomain': 'teachentapp.firebaseapp.com',
                        'databaseURL':
                            'https://teachentapp-default-rtdb.europe-west1.firebasedatabase.app',
                        'projectId': 'teachentapp',
                        'storageBucket': 'teachentapp.appspot.com',
                        'messagingSenderId': '472666586305',
                        'appId': '1:472666586305:web:834e35e0a30111587a2840',
                        'measurementId': 'G-N1R9WC63JZ'
                    },
                    'pluginConstants': {}
                }
            ];
        }
        if (function.method == 'DatabaseReference#set') {
            return [{}];
        }
        if (function.method == 'Query#observe') {
            return [{}];
        }
        return null;
    });
}

Future<DataManager> initDatabase() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setFirebaseDatabase();
    await MainDatabase().init(DBMode.testingUnitTests);

    final dataManager = DataManagerCreator.create();
    return dataManager;
}

Future<void> setFakeData(DataManager dm) async {
    final fakeData = {
        'levels': {'High School': false, 'Primary': false, 'University': false},
        'places': {'Warsaw': false, 'Wroclaw': false},
        'topics': {'Computer Science': false, 'Math': false, 'English': false},
        'tools': {'Discord': false, 'Google Meet': false},
        'users': {
            'kowalski': {
                'isDarkMode': false,
                'isTeacher': false,
                'password': 'admin1'
            },
            'conor': {
                'isDarkMode': false,
                'isTeacher': false,
                'password': 'conor'
            },
        },
        'teachers': {
            'kowalski': {
                'averageRate': -1,
                'description': '',
                'name': 'Jan Kowalski',
                'places': {'Warsaw': true},
                'topics': {'Computer Science': true}
            }
        },
        'students': {
            'conor': {
                'name': 'John Conor',
                'educationLevel': 'University',
            }
        }
    };
    //await dm.database.setFirebaseInitialData(fakeData);
}


void main() async {
  late DataManager dm;
  setUp(() async {
      dm = await initDatabase();
      await setFakeData(dm);
  });

  test('[TEST 1] Check if teacher exists', () async {
      final teacher = await dm.database.getTeacher('kowalski');

      assert(teacher != null);
      expect(teacher!.toMap(), {
        'averageRate': -1,
        'description': '',
        'name': 'Jan Kowalski',
        'places': {'Warsaw': true},
        'topics': {'Computer Science': true}
      });
  });
}
