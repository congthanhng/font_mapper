# Font Mapper 🧩

A Dart CLI tool to scan font files and auto-generate the `fonts:` section in your `pubspec.yaml`.

## 🔧 Installation

```sh
dart pub global activate font_mapper
```

## 🚀 Usage

### 🔧 Basic
```sh
font_mapper
```
This scans `assets/fonts` and updates the `fonts:` section in `pubspec.yaml`.

### 🛠 With options

```sh
font_mapper -t pubspec.yaml -d assets/my_fonts
```

`-t` / --target: Target YAML file (**default**: `pubspec.yaml`)

`-d` / --dir: Directory containing font files (**default**: `assets/fonts`)

`-h` / --help: Show help


## 📂 Supported Fonts
`.ttf`, `.otf` formats

Supports multi-family directories

## 📄 Output Example

If you have:

```text
assets/fonts/
├── SF-Pro-Display-BoldItalic.ttf
├── SF-Pro-Display-Regular.ttf
├── Inter-Light.otf

```

Running font_mapper generates:

```yaml
flutter:
  fonts:
    - family: SF-Pro-Display
      fonts:
        - asset: assets/fonts/SF-Pro-Display-BoldItalic.ttf
          weight: 700
          style: italic
        - asset: assets/fonts/SF-Pro-Display-Regular.ttf
          weight: 400
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Light.otf
          weight: 300
```
## 🔐 License
MIT License. See LICENSE.

## 🧑‍💻 Contributing
Feel free to open PRs or issues on GitHub!
