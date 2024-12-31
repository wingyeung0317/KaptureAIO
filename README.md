<div align='center'>

![Logo](https://github.com/wingyeung0317/KaptureAIO/blob/master/flutter/kapture_aio/android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png?raw=true)

<h1>KaptureAIO : 港攝ＡＩＯ</h1>
<p>This is a project that aim to build an android app that provide different photographic informations for Hong Konger, such as Weather, Place, Forum etc. </p>

[![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/wingyeung0317) [![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/wingyeung0317) [![Patreon](https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white)](https://patreon.com/wingyeung0317) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/wingyeung0317) 

![KaptureAIO Poster](https://github.com/wingyeung0317/KaptureAIO/assets/121206892/fe800e46-d69e-4c00-a1aa-bf27d79d5bec)


<p>

**Tag:**
![Android project (Flutter)](https://img.shields.io/badge/Flutter-black?style=plastic&logo=android&label=Android&labelColor=1c5b2d&color=34a853)
&emsp;
![Python with Flask](https://img.shields.io/badge/Flask-black?style=plastic&logo=python&label=Python&labelColor=1e415e&color=3776ab)
&emsp;
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-black?style=plastic&logo=postgresql&label=Database&labelColor=1b3151&color=36609e)
&emsp;
![Docker](https://img.shields.io/badge/Docker-black?style=plastic&logo=docker&labelColor=1865a0&color=2496ed)
</p>

<h4> <a href=https://github.com/wingyeung0317/KaptureAIO/releases>Release</a> <span> · </span> <a href="https://github.com/wingyeung0317/KaptureAIO/blob/master/README.md"> Documentation </a> <span> · </span> <a href="https://github.com/wingyeung0317/KaptureAIO/issues/new?labels=bug"> Report Bug </a> <span> · </span> <a href="https://github.com/wingyeung0317/KaptureAIO/issues/new?labels=enhancement"> Request Feature </a> </h4>


</div>

# :notecamera_with_decorative_cover: Table of Contents

- [About the Project](#star2-about-the-project)
- [Roadmap](#compass-roadmap)
- [FAQ](#grey_question-faq)
- [License](#warning-license)
- [Contact](#handshake-contact)
- [Acknowledgements](#gem-acknowledgements)


## :star2: About the Project
### :space_invader: Tech Stack
![Android project (Flutter)](https://img.shields.io/badge/Flutter-black?style=plastic&logo=android&label=Android&labelColor=1c5b2d&color=34a853)

![Python with Flask](https://img.shields.io/badge/Flask-black?style=plastic&logo=python&label=Python&labelColor=1e415e&color=3776ab)

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-black?style=plastic&logo=postgresql&label=Database&labelColor=1b3151&color=36609e)

![Docker](https://img.shields.io/badge/Docker-black?style=plastic&logo=docker&labelColor=1865a0&color=2496ed)
### :dart: Features
- `TODO: (WIP)`


<!-- ### :art: Color Reference
| Color | Hex |
| --------------- | ---------------------------------------------------------------- |
| Primary Color | ![#fdd055](https://via.placeholder.com/10/fdd055?text=+) #fdd055 |
| Secondary Color | ![#52fced](https://via.placeholder.com/10/52fced?text=+) #52fced |
| Accent Color | ![#00ADB5](https://via.placeholder.com/10/00ADB5?text=+) #00ADB5 |
| Text Color | ![#b9762e](https://via.placeholder.com/10/b9762e?text=+) #b9762e | -->

### :key: Environment Variables
To run this project, you will need to add the following environment variables to your .env file

`HOST` : Already in templete

`DATABASE` : Already in templete

`USER` : Already in templete

`PASSWORD` : **Needed to be change**

## :toolbox: Getting Started

### :bangbang: Prerequisites

- Flutter [Here](https://docs.flutter.dev/release/archive?tab=windows)
```bash
ADD PATH
```
- Docker or Local
  - Docker [Here](https://www.docker.com/products/docker-desktop/)
  - <details> <summary>Local</summary>
  
    - Python [Here](https://www.anaconda.com/download) <!-- I just love using anaconda, LOL. I don't believe there is anyone don't know how to install the original python. -->
    ```bash
    pip install -r ./server/requirements.txt
    ```
    - PostgreSQL<a href="https://www.postgresql.org/download/"> Here</a>
    </details>


### :gear: Installation

1. Docker
    ```bash
    cd ./server/
    docker compose up
    ```
2. Flutter Pub Get
    ```bash
    cd ../flutter/kapture_aio
    flutter pub get
    ```
3. Gen i18n
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4. Choose
   - APK Build (build release apk)
    ```bash
    flutter build apk
    ```
    - or Split (build split apk)
    ```bash
    flutter build apk --split-per-abi
    ```
5. Profit…?

### :triangular_flag_on_post: Deployment

- Choose
  - Docker
    ```bash
    docker compose up
    ```
  - Local
    1. Run your PostgreSQL
    2. 
        ```bash
        cd ./server
        flask run
        ``` 

## :compass: Roadmap

* [x] Weather fetch
* [x] Marketplace
* [x] Forum
* [x] Recommend location
* [ ] Golden Hour
* [ ] Moon Phase


## :wave: Contributing

<a href="https://github.com/wingyeung0317/KaptureAIO/graphs/contributors"> <img src="https://contrib.rocks/image?repo=wingyeung0317/KaptureAIO" /> </a>

Contributions are always welcome!

<!-- see `contributing.md` for ways to get started -->

<!-- ### :scroll: Code of Conduct

Please read the [Code of Conduct](https://github.com/wingyeung0317/KaptureAIO/new/master?filename=README.md/blob/master/CODE_OF_CONDUCT.md) -->

## :grey_question: FAQ

- Do I need to run the server on my side?
- Most likely yes, I don't have enough money to maintain the server. I already build a docker file. It shouldn't be hard to run the server. Make sure you create the password in .env (of cause, for security reason...)

## :warning: License

<svg aria-hidden="true" focusable="false" role="img" class="Octicon-sc-9kayk9-0" viewBox="0 0 24 24" width="18" height="18" fill="currentColor" style="display: inline-block; user-select: none; vertical-align: text-bottom; overflow: visible;"><path d="M12.75 2.75V4.5h1.975c.351 0 .694.106.984.303l1.697 1.154c.041.028.09.043.14.043h4.102a.75.75 0 0 1 0 1.5H20.07l3.366 7.68a.749.749 0 0 1-.23.896c-.1.074-.203.143-.31.206a6.296 6.296 0 0 1-.79.399 7.349 7.349 0 0 1-2.856.569 7.343 7.343 0 0 1-2.855-.568 6.205 6.205 0 0 1-.79-.4 3.205 3.205 0 0 1-.307-.202l-.005-.004a.749.749 0 0 1-.23-.896l3.368-7.68h-.886c-.351 0-.694-.106-.984-.303l-1.697-1.154a.246.246 0 0 0-.14-.043H12.75v14.5h4.487a.75.75 0 0 1 0 1.5H6.763a.75.75 0 0 1 0-1.5h4.487V6H9.275a.249.249 0 0 0-.14.043L7.439 7.197c-.29.197-.633.303-.984.303h-.886l3.368 7.68a.75.75 0 0 1-.209.878c-.08.065-.16.126-.31.223a6.077 6.077 0 0 1-.792.433 6.924 6.924 0 0 1-2.876.62 6.913 6.913 0 0 1-2.876-.62 6.077 6.077 0 0 1-.792-.433 3.483 3.483 0 0 1-.309-.221.762.762 0 0 1-.21-.88L3.93 7.5H2.353a.75.75 0 0 1 0-1.5h4.102c.05 0 .099-.015.141-.043l1.695-1.154c.29-.198.634-.303.985-.303h1.974V2.75a.75.75 0 0 1 1.5 0ZM2.193 15.198a5.414 5.414 0 0 0 2.557.635 5.414 5.414 0 0 0 2.557-.635L4.75 9.368Zm14.51-.024c.082.04.174.083.275.126.53.223 1.305.45 2.272.45a5.847 5.847 0 0 0 2.547-.576L19.25 9.367Z"></path></svg>&emsp;<b style="font-size:18px;">Apache License 2.0</b> \
A permissive license whose main conditions require preservation of copyright and license notices. Contributors provide an express grant of patent rights. Licensed works, modifications, and larger works may be distributed under different terms and without source code.

## :handshake: Contact

Discord: https://discord.gg/GkdrUmSEdH

Project Link: https://github.com/wingyeung0317/KaptureAIO

## :gem: Acknowledgements

Section to mention useful resources and libraries.

[i18n](https://yiichenhi.medium.com/flutter-%E8%BC%95%E9%AC%86%E5%AF%A6%E4%BD%9C-i18n-%E4%BD%BF%E7%94%A8-easy-localization-generator-%E5%B0%B1%E5%B0%8D%E4%BA%86-20a91d8b4f2a) · [Flask](https://flask.palletsprojects.com/en/3.0.x/) · [SQLAlchemy](https://www.sqlalchemy.org) · [flutter_map](https://docs.fleaflet.dev) · [webview_flutter](https://pub.dev/packages/webview_flutter) · [flutter_markdown](https://pub.dev/packages/flutter_markdown) · [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) · [Docker](https://www.youtube.com/results?search_query=docker+tutorial) · [Sublime Merge](https://www.sublimemerge.com) · [VSCode](https://code.visualstudio.com)

## 💰 You can help me by Donating
[![BuyMeACoffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-ffdd00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black)](https://buymeacoffee.com/wingyeung0317) [![PayPal](https://img.shields.io/badge/PayPal-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/wingyeung0317) [![Patreon](https://img.shields.io/badge/Patreon-F96854?style=for-the-badge&logo=patreon&logoColor=white)](https://patreon.com/wingyeung0317) [![Ko-Fi](https://img.shields.io/badge/Ko--fi-F16061?style=for-the-badge&logo=ko-fi&logoColor=white)](https://ko-fi.com/wingyeung0317) 
