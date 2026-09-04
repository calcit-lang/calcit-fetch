# Limit workflow permissions

- Added an explicit read-only `contents` permission to the Linux test workflow.
- This keeps the setup and test jobs on the least privilege required to check out the repository.

# 限制工作流权限

- 为 Linux 测试工作流显式声明只读的 `contents` 权限。
- 让安装与测试任务仅保留检出仓库所需的最小权限。
