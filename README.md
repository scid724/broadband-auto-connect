# 开机自动连接宽带

这是一个适用于 Windows 的 PowerShell 小工具。它会在用户登录后，自动连接已经保存的 PPPoE 宽带连接，并在网络服务尚未准备好时自动重试。

## 项目名称和简介

- 项目名称：开机自动连接宽带
- GitHub 仓库建议名称：`开机自动连接宽带`
- 功能：登录 Windows 后自动拨号连接宽带
- 适用系统：Windows 10 / Windows 11

## 隐私和账号安全

- 本仓库不包含任何宽带用户名、密码、日志或个人电脑路径。
- 每台电脑都要运行 `save-credentials.cmd`，在本机输入宽带账号和密码。
- 密码使用 Windows DPAPI 加密，只能由保存它的当前 Windows 用户解密。
- 加密凭据保存在 `%LOCALAPPDATA%\BroadbandAutoConnect`，不会提交到 Git。
- 严禁上传 `credential.xml` 和 `connect.log`。

## 安装步骤

1. 确认 Windows 已经存在宽带拨号连接。默认连接名称是 `宽带连接`。
2. 双击运行 `save-credentials.cmd`。
3. 在黑色窗口中输入宽带用户名和密码。密码只在本机输入，不要发送给任何人，也不要上传到 GitHub。
4. 双击运行 `install-admin-task.cmd`。
5. Windows 弹出管理员权限确认时，点击“是”。
6. 注销或重启电脑。登录后程序会自动连接宽带。

如果连接名称不是“宽带连接”，请在命令提示符中运行：

```text
install-admin-task.cmd "你的宽带连接名称"
```

## 卸载步骤

双击运行 `uninstall-admin-task.cmd`，即可删除自动连接计划任务。

## 查看日志

日志位置：

```text
%LOCALAPPDATA%\BroadbandAutoConnect\connect.log
```

## 常见问题

### 每次都弹出密码框

重新运行 `save-credentials.cmd`，确认账号密码输入正确，并重新运行 `install-admin-task.cmd`。

### 没有自动连接

确认连接名称完全一致，并检查日志文件中的错误信息。

## 许可证

MIT