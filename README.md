# kanban_tracker

## About
App uses clean architecture approach, so you could replace your api layer or any layer on your demand. For ease of use app api based on Firebase services. 
It provides us a realtime database (we dont need to create our own crdt for ex.), pushes, analytics. For a MVP its more than enogh, but for larger projects i prefer to use our own inplementations for db, servers like self-hosted supabase.

In another way, we can use only needed firebase services, such as database, pushes, crashlytics and analytics with our own small proxy server with graphql protocol in it, to make sure that we have a single source of truth for data models.

## Getting Started

1. Install nodejs
2. install firebase cli
    
    ```bash
    npm install -g firebase-tools
    ```
    
    ```bash
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    ```
    
3. Install flutterfire cli and activate it
    
    ```bash
    dart pub global activate flutterfire_cli
    ```
    
    [https://firebase.flutter.dev/docs/cli](https://firebase.flutter.dev/docs/cli)
    
4. Login into your account
    
    ```bash
    firebase login
    ```
    
5. Init firebase project and select your project
    
    ```bash
    flutterfire configure
    ```
    
6. In your firebase project enable authentication and create any user (for now no sign up logic is presented, so you need to create account manually)
7. Run codegen
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
8. After sign in, select or create new board and then go into it.

## Project features
1. Authentication - user can create an account and login to different boards, invitations functionality could be added easily.
2. Kanban - tasks, grouped by statuses, task time tracking.
3. RealTime editing - While editing task it have real-time changes, so if other user in board changes it, then it will display in detailed page to  other users. 
4. Export - Export data to csv.
5. Translations - app could be translated easily, add new translation into assets/localization and into ios project runner.
6. Dynamic themes - could change themes, for now they aren't stored anywhere so default theme will be applied after restart. Theme saving can be done easy as well.

## How to export data
1. Create a task via plus button
2. Start time tracking and then finish it
3. You have to see total task duration.
4. Open left drawer on home page and select ‘History’
5. Export data, it will be saved into your local phone storage
    1. iOS - Files > kanban tracker > your_file.csv
    2. Android - Android > data > kanban_tracker > files
    
## Roadmap
1. Flavors/ Env - better to user flutter_env, take some time to implement corrent environments to work with different firebases, different launcher icons and splash screens.
2. Graphql - its better to use gql to be sure about data and types to working with, it can be implemented via new board api layer with something like supabese in backend part.
3. Local and secure storage - for now there is no local storage for data, like user settings, cached task etc, right now it fetches them via firebase firestore api. Caching is crucial in production apps, so it must be there as well with secure storage for sensetive information.
4. Tests - at least some unit test must cover core functionality at some degree, as well as widget tests to prevent new changes breaking old things.
5. CI/CD - just dont have to explain it, run tests, build, tell us if soemthing went wrong and auto deploy app to stores.

