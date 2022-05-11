# Zensho HSC flutter app

## Getting Started

### 1. Setup Flutter

#### 1.1. Install [fvm](https://fvm.app/docs/getting_started/installation)

#### 1.2. Install Flutter latest

    fvm install 2.10.5
    fvm global 2.10.5

### 2. Config files

Copy file `.env.example` và đổi tên thành `.env`, sửa đổi các config cần thiết bên trong `.env`

### 3. Generate code

Sử dụng 1 trong 2 cách sau để generate code (json serialization, localization, ..)

    flutter pub run build_runner build # generate code 1 lần rồi dừng lại
    flutter pub run build_runner watch # generate code và tiếp tục monitor các thay đổi

### 4. Chạy app bằng lệnh

flutter run
