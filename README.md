# delta-force-recoil

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Windows-green.svg)]()
[![Language](https://img.shields.io/badge/language-Lua-orange.svg)]()

基于 [Soldier76](https://github.com/kiccer/Soldier76) 精简改造的 **三角洲行动（Delta Force）压枪辅助**，适配 **Logitech G HUB** 脚本环境，提供相对精准的自动压枪功能。

> ⚠️ 本项目仅用于技术学习与交流，禁止用于任何违反游戏规则的行为。使用本项目产生的一切后果由使用者自行承担。

---

## ✨ 功能特点
- 🎯 适配 **Logitech G HUB** 环境（Lua 脚本）
- 🔧 针对 **三角洲行动** 优化压枪参数与步进
- 📦 从 Soldier76 精简，只保留必要的识别与压枪逻辑
- ⚙️ 支持自定义枪械参数
- 🛑 可通过注释或条件开关 **禁用压枪功能（只屏息）**

---

## 📥 安装方法
1. 克隆或下载本项目：
2. 打开 **Logitech G HUB**。
3. 在 G HUB 中进入你要绑定脚本的设备（如鼠标）→ 脚本（Scripting）面板：
   - 新建一个脚本（New Script），或编辑已有脚本文件。
   - 将本仓库中的 `.lua` 脚本文件内容复制并粘贴到 G HUB 的脚本编辑器中，或使用 G HUB 的导入功能将 `.lua` 文件导入（视版本而定）。
4. 保存脚本并应用到对应的配置（profile）。根据需要设置热键或切换开关。

---

## 🚀 使用方法
1. 使用**管理员权限**打开G HUB
2. 在 G HUB 中确保脚本已启用并绑定到正确的设备/配置文件。
3. 启动游戏 **三角洲行动**（Delta Force）。
4. 按脚本中预设的热键启动压枪辅助（在脚本顶部配置区修改）。

---

## 🛠 禁用压枪（仅检测/不移动鼠标）
若你不想执行自动压枪，只希望脚本不移动鼠标，可以把移动鼠标的调用注释掉：
```lua
-- MoveMouseRelative(data.dx, data.dy)
```
---

## ❓ 常见问题

### 我可以不使用压枪吗？
可以——如上所示，注释 `MoveMouseRelative`即可。

### 会不会导致封号？
会。使用压枪宏或自动化脚本通常违反游戏服务条款，存在封号风险。**请自行承担所有风险。**

---

## 📚 参考来源
- 原始仓库： [Soldier76](https://github.com/kiccer/Soldier76)
- Logitech G HUB 脚本文档（请参考官方文档以了解你当前 G HUB 版本的导入/编辑方式）

---

## 📜 许可
本项目采用 MIT 许可证（见 LICENSE 文件）。允许修改与分发，但使用产生的后果由使用者承担。
