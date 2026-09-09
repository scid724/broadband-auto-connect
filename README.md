# Windows Broadband Auto Connect

A small PowerShell utility that automatically dials a saved Windows PPPoE
broadband connection after the current user logs on.

## Privacy and credentials

- No username, password, local path, log, or personal identifier is included
  in this repository.
- Run `save-credentials.cmd` on each computer. The password is entered locally
  and exported with Windows DPAPI encryption for the current Windows user.
- The encrypted credential file is stored under
  `%LOCALAPPDATA%\BroadbandAutoConnect` and is ignored by Git.
- Never commit `credential.xml` or `connect.log`.

## Install

1. Make sure Windows already has a PPPoE connection profile. The default
   profile name is `宽带连接`.
2. Double-click `save-credentials.cmd` and enter the broadband username and
   password locally. Do not paste the password into GitHub or send it to anyone.
3. Double-click `install-admin-task.cmd`. Approve the administrator prompt.
   To use another profile name, run:

   ```text
   install-admin-task.cmd "Your connection name"
   ```

4. Sign out or restart Windows. The task starts at logon and retries quickly
   if the network service is not ready yet.

## Uninstall

Double-click `uninstall-admin-task.cmd`.

## Troubleshooting

The log is stored at:

```text
%LOCALAPPDATA%\BroadbandAutoConnect\connect.log
```

If the connection name is wrong, list the profile in Windows' Network
settings and reinstall with the exact name.

## License

MIT
