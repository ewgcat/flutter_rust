# flutter_rust

## Android 篇
### 1.配置rust环境
- Rust安装：https://rustup.rs/

### 2.配置ndk环境
- 必须要安装cargo-ndk ：它能够将代码编译到适合的 JNI 而不需要额外的配置
```
https://github.com/bbqsrc/cargo-ndk
```
- 添加cargo的android编译工具
```
rustup target add aarch64-linux-android
rustup target add armv7-linux-androideabi
rustup target add x86_64-linux-android
rustup target add i686-linux-android
```
### 3.编写rust 代码
编译  2种方式
-方式一 执行
```
cargo ndk -t  arm64-v8a   build --release
```
-方式二
android app build.gradle最下面加配置
```

[
        new Tuple2('Debug', ''),
        new Tuple2('Profile', '--release'),
        new Tuple2('Release', '--release')
].each {
    def taskPostfix = it.first
    def profileMode = it.second
    tasks.whenTaskAdded { task ->
        if (task.name == "javaPreCompile$taskPostfix") {
            task.dependsOn "cargoBuild$taskPostfix"
        }
    }
    tasks.register("cargoBuild$taskPostfix", Exec) {
        // Until https://github.com/bbqsrc/cargo-ndk/pull/13 is merged,
        // this workaround is necessary.

        def ndk_command = """cargo ndk \
            -t arm64-v8a  \
            -o ../android/app/src/main/jniLibs build $profileMode"""

        workingDir "../../rust"
        environment "ANDROID_NDK_HOME", "$ANDROID_NDK"
        if (DefaultNativePlatform.currentOperatingSystem.isWindows()) {
            commandLine 'cmd', '/C', ndk_command
        } else {
            commandLine 'sh', '-c', ndk_command
        }
    }
}
```
### 4.配置Flutter项目和rust项目flutter_rust_bridge依赖
pubspec.yaml
```yaml
name: flutter_rust
description: A new Flutter project.
version: 1.0.0+1

environment:
  sdk: ">=2.17.0 <3.0.0"
dependencies:
  flutter:
    sdk: flutter
  ffi: ^2.0.1
  flutter_rust_bridge: ^1.61.0
  cupertino_icons: ^1.0.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  ffigen: ^6.1.0
  flutter_lints: ^1.0.0

flutter:
  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

```
Cargo.toml
```
[package]
name = "rust_http"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
jni = { version = "0.19.0", default-features = false }
tokio = { version = "1", features = ["full"] }
reqwest-middleware = "0.1.6"
reqwest = "0.11.12"
reqwest-retry = "0.1.5"
reqwest-tracing = "0.2.3"
anyhow = "1.0"
openssl-sys = "0.9"
openssl = {version = "0.10.35", features = ["vendored"]}
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
flutter_rust_bridge = "1.61.0"
[profile.release]
lto = true
[lib]
# 编译的动态库名字
name = "rust_http"
# 编译类型 cdylib 指定为动态库 staticlib指定为静态库
crate-type = ["cdylib","staticlib"]

```

### 5.安装代码生成插件
```
cargo install flutter_rust_bridge_codegen
```
### 6.执行生成代码命令
```
flutter_rust_bridge_codegen --rust-input path/xx.rs --dart-output path/xx_generated.dart
```
