`TODO: (WIP)`

<div align='center'>

![Logo](https://github.com/wingyeung0317/KaptureAIO/blob/master/flutter/kapture_aio/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png?raw=true)

<h1>This is a project that aim to build an android app that provide different photographic informations for Hong Konger, such as Weather, Place, Forum etc.</h1>
<p>an Android project with Python and PostgreSQL server</p>

<h4> <a href=https://github.com/wingyeung0317/KaptureAIO/releases>View Demo</a> <span> · </span> <a href="https://github.com/wingyeung0317/KaptureAIO/blob/master/README.md"> Documentation </a> <span> · </span> <a href="https://github.com/wingyeung0317/KaptureAIO/issues"> Report Bug </a> <span> · </span> <a href="https://github.com/wingyeung0317/KaptureAIO/issues"> Request Feature </a> </h4>


</div>

# :notebook_with_decorative_cover: Table of Contents

- [About the Project](#star2-about-the-project)
- [Roadmap](#compass-roadmap)
- [FAQ](#grey_question-faq)
- [License](#warning-license)
- [Contact](#handshake-contact)
- [Acknowledgements](#gem-acknowledgements)


## :star2: About the Project
### :space_invader: Tech Stack
<details> <summary>Client</summary> <ul>
<li><a href="package:kapture_aio/">Flutter</a></li>
</ul> </details>
<details> <summary>Server</summary> <ul>
<li><a href="localhost:5000">Python Flask</a></li>
</ul> </details>
<details> <summary>Database</summary> <ul>
<li><a href="localhost:5432">PostgreSQL</a></li>
</ul> </details>
<details> <summary>DevOps</summary> <ul>
<li><a href="n/a">n/a</a></li>
</ul> </details>

### :dart: Features
- N/A


### :art: Color Reference
| Color | Hex |
| --------------- | ---------------------------------------------------------------- |
| Primary Color | ![#fdd055](https://via.placeholder.com/10/fdd055?text=+) #fdd055 |
| Secondary Color | ![#52fced](https://via.placeholder.com/10/52fced?text=+) #52fced |
| Accent Color | ![#00ADB5](https://via.placeholder.com/10/00ADB5?text=+) #00ADB5 |
| Text Color | ![#b9762e](https://via.placeholder.com/10/b9762e?text=+) #b9762e |

### :key: Environment Variables
To run this project, you will need to add the following environment variables to your .env file
`FLASK`

`POSTGRESQL_PASSWORD`

`hostname`

`database_name`

`user`

`password`



## :toolbox: Getting Started

### :bangbang: Prerequisites

- Flutter<a href="https://docs.flutter.dev/release/archive?tab=windows"> Here</a>
```bash
ADD PATH
```
- Python<a href="https://www.anaconda.com/download"> Here</a>
```bash
pip install -r ./server/requirements.txt
```
- PostgreSQL<a href="https://www.postgresql.org/download/"> Here</a>


### :gear: Installation

Docker
```bash
docker compose up
```
Flutter Pub Get
```bash
flutter pub get
```
APK Build
```bash
flutter build apk
```
APK Split
```bash
flutter build apk --split-per-abi
```
Gen i18n
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```


### :triangular_flag_on_post: Deployment

Docker
```bash
docker compose up
```
APK build
```bash
flutter build apk
```
APK Split
```bash
flutter build apk --split-per-abi
```


## :compass: Roadmap

* [x] Weather fetch
* [x] Marketplace
* [x] Forum
* [x] Recommend location
* [ ] Golden Hour
* [ ] Moon Phase


## :wave: Contributing

<a href="https://github.com/wingyeung0317/KaptureAIO/new/master?filename=README.md/graphs/contributors"> <img src="https://contrib.rocks/image?repo=Louis3797/awesome-readme-template" /> </a>

Contributions are always welcome!

see `contributing.md` for ways to get started

### :scroll: Code of Conduct

Please read the [Code of Conduct](https://github.com/wingyeung0317/KaptureAIO/new/master?filename=README.md/blob/master/CODE_OF_CONDUCT.md)

## :grey_question: FAQ

- Do I need to run the server on my side?
- Most likely yes, I don't have enough money to maintain the server. I already build a docker file. It shouldn't be hard to run the server. Make sure you create the SQL variables in `./server/localconst.py` and .env variables


## :warning: License

Distributed under the no License. See LICENSE.txt for more information.

## :handshake: Contact

Wing - - wingyeung0317@hotmail.com

Project Link: [https://github.com/wingyeung0317/KaptureAIO/new/master?filename=README.md](https://github.com/wingyeung0317/KaptureAIO/new/master?filename=README.md)

## :gem: Acknowledgements

Use this section to mention useful resources and libraries that you have used in your projects.

- [i18n](https://yiichenhi.medium.com/flutter-%E8%BC%95%E9%AC%86%E5%AF%A6%E4%BD%9C-i18n-%E4%BD%BF%E7%94%A8-easy-localization-generator-%E5%B0%B1%E5%B0%8D%E4%BA%86-20a91d8b4f2a)
- [Flask](https://flask.palletsprojects.com/en/3.0.x/)
- [SQLAlchemy](https://www.sqlalchemy.org)
- [flutter_map](https://docs.fleaflet.dev)
- [webview_flutter](https://pub.dev/packages/webview_flutter)
- [flutter_markdown](https://pub.dev/packages/flutter_markdown)
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- [Docker](https://www.youtube.com/results?search_query=docker+tutorial)
- [Sublime Merge](https://www.sublimemerge.com)
- [VSCode](https://code.visualstudio.com)
