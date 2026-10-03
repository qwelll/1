# Liquid Glass Alerts（仅系统弹窗）

从 `ngkoi/liquidass-27` 裁剪出的**只剩弹窗功能**的源码树。

## 已删除的内容

| 删除项 | 原体积 | 说明 |
|---|---|---|
| `Tweak.x` | 17 KB | 安全模式弹窗、注销/重启后台进程、崩溃日志打包 |
| `Hooks/*.x` 除 `Alerts.x` | 约 620 KB | 资源库、文件夹、Dock、键盘、控制中心、TabBar、Spotlight、小组件、锁屏封面、密码界面、通知横幅、音量 HUD、开关/滑条等 |
| `Hooks/Clock/` | 100 KB+ | 锁屏液态时钟 |
| `LGFramework/` | 40 KB | 无人引用的死代码 |
| `LiquidAssPrefs/` | 约 500 KB | 设置面板（含 4.3 MB 字体与图片资源） |
| `LiquidAssBackboardd/` | 92 KB | backboardd 注入 |
| `LiquidAssRWB/` | 119 KB |  wallpaper/窗口后台注入 |

保留文件：`Hooks/Alerts.x`、`Shared/`（`LGGlassKit`、`LGLiveBackdropView`、`LGFramework`、`LGSharedSupport` 及依赖头文件）。

编译进去的功能只剩一个：`UIAlertController` 液态玻璃弹窗。

## 云端编译（推荐，不需要 Mac）

1. 在 GitHub 新建一个空仓库。
2. 把本目录内容推上去：

```bash
git init
git add .
git commit -m "alerts only"
git branch -M main
git remote add origin git@github.com:<你的用户名>/<仓库名>.git
git push -u origin main
```

3. 仓库会自带 `.github/workflows/build.yml`，推送后自动开始编译。
4. 编译完成后，在仓库的 **Actions → 对应 run → Artifacts** 下载：
   - `rootless-deb`（普通越狱）
   - `roothide-deb`（roothide 越狱，真正的 roothide 格式，无需再用 Patcher 转换）

也可以在 **Actions → build → Run workflow** 里手动选择只编译 `rootless` 或 `roothide`。

## 本地编译（需要 macOS + Theos）

```bash
export THEOS=~/theos
make package ARCHS="arm64 arm64e" TARGET="iphone:clang:16.5:14.0" FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless
# roothide 需要 roothide/theos 分支
make clean
make package ARCHS="arm64 arm64e" TARGET="iphone:clang:16.5:14.0" FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=roothide
```

产物在 `packages/` 目录。

## 包信息

```
Package: com.qwelll.liquidglassalerts
Name: Liquid Glass Alerts
Maintainer: qwelll
Author: qwelll
```

## 运行开关

弹窗功能由宿主开关控制，`Alerts` 默认开启：

```
Global.Enabled = true
Alerts.Enabled = true
```

因为源码里已不存在其它模块，所以不再依赖 `dylv.liquidassprefs.plist` 去关闭它们。如果设备上还残留旧版的 `dylv.liquidassprefs.plist`，建议装完后删除：

```bash
rm -f /var/jb/var/mobile/Library/Preferences/dylv.liquidassprefs.plist
```

然后注销（respring）。

## 预期体积

裁剪后动态库约为原来的三分之一，`.deb` 预计在 **150–300 KB**（原完整包 3.6 MB，之前用开关做的版本 512 KB）。

实际数字以 Actions 构建日志里的 `du -h packages/*.deb` 为准。
