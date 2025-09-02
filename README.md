
# TodoApp (Flutter + Firebase) 📝

Demo en ligne : **[https://web-sepia-three-58.vercel.app](https://web-sepia-three-58.vercel.app?utm_source=chatgpt.com)**

Application Todo minimaliste bâtie avec **Flutter Web**, **Firebase Auth** et **Cloud Firestore**.  
Gestion d’état via **provider** et persistance offline Firestore activée.


### Prérequis

-   **Flutter** (canal stable) installé :
    
    `flutter --version` 
    
-   **Node.js** (pour les CLI Firebase/FlutterFire).
    
-   (Optionnel mais recommandé) **Firebase CLI** & **FlutterFire CLI** :
    
    `npm i -g firebase-tools
    dart pub global activate flutterfire_cli` 
    

### 1 Cloner le dépôt

`git clone https://github.com/julienESN/flutter_project`

### 2 Installer les dépendances

`flutter pub get` 


### 3 Lancer en local (Allez sur du web)

`flutter run ` 

**Avec émulateurs Firebase** (ports codés : Auth 9099, Firestore 8080) :

`flutter run -d chrome --dart-define=USE_EMULATORS=true` 

Dans un autre terminal (optionnel si tu veux de “vrais” émulateurs) :

`firebase emulators:start --only auth,firestore`

📦 Scripts utiles

**Installer/mettre à jour les paquets**

    flutter pub get
    flutter pub upgrade --major-versions

**Lancer l’appli sur Chrome**

    flutter run -d chrome

**Mode émulateurs (voir plus haut)**

    flutter run -d chrome --dart-define=USE_EMULATORS=true

**Build web (sortie dans build/web)**

    flutter build web

**Build web sans PWA/service worker (utile pour éviter des soucis de cache)**

    flutter build web --pwa-strategy=none

**Lancer les tests**

    flutter test

**Analyse statique / formatage**

    flutter analyze
    dart format .

## 🔧 Stack & structure

 -   **Flutter Web**
    
 -   **firebase_core**, **firebase_auth**, **cloud_firestore**
    
 -   **provider** (MultiProvider + StreamProvider pour `authStateChanges`)
    
 -   **shared_preferences**, **http**
    
 -   (Présent au `pubspec`) **go_router**
    
 - Entrée principale : `lib/main.dart`   
 - Écrans : `lib/screens/` (`home_screen.dart`, `login_screen.dart`, `register_screen.dart`)  
  - State : `lib/providers/todo_provider.dart`
## 🔗 Liens

-   **Demo** : [https://web-sepia-three-58.vercel.app](https://web-sepia-three-58.vercel.app?utm_source=chatgpt.com)
    
-   **Flutter** : [https://flutter.dev](https://flutter.dev?utm_source=chatgpt.com)
    
-   **Firebase** : https://firebase.google.com
    
-   **FlutterFire** : https://firebase.flutter.dev