# sftpgo-data-retention-perm-bug

SFTPGo does not seem to honor `ignore_user_permissions=true` for sub folders of the folder which is configured in the data retention action.

It logs `user <some-user> does not have permissions to check retention on <some-subfolder>, retention check skipped`.

## How to Reproduce

### 1. Start SFTPGo and minio:
```
docker compose up
```

SFTPGo admin web interface: http://localhost:8080/web/admin/
username: `admin`.
password: `nimda`.

SFTPGo user:
username: `user1`
password: `pass1`

Minio web interface:
http://localhost:9001/
username: `miniouser`
password: `ciugRTdpMTEhC/GITBpmi/GjXwumZnPdkoEzvSiT`

### 2. Trigger Retention Check:
```
./trigger-retention-check.sh
```

### 3. Check SFTPGo Logs
```
{"level":"debug","time":"2024-03-13T12:23:42.669","sender":"eventmanager","message":"executing on demand rule \"delete-old-files-user1\""}
{"level":"debug","time":"2024-03-13T12:23:42.670","sender":"eventmanager","message":"on-demand rule \"delete-old-files-user1\" started"}
{"level":"info","time":"2024-03-13T12:23:42.672","sender":"DataRetention","connection_id":"data_retention_user1","message":"retention check started"}
{"level":"debug","time":"2024-03-13T12:23:42.672","sender":"DataRetention","connection_id":"data_retention_user1","message":"start retention check for folder \"/files\", retention: 100 hours, delete empty dirs? true, ignore user perms? true"}
{"level":"info","time":"2024-03-13T12:23:42.681","sender":"DataRetention","connection_id":"data_retention_user1","message":"user \"user1\" does not have permissions to check retention on \"/files/1999-01-01\", retention check skipped"}
{"level":"info","time":"2024-03-13T12:23:42.682","sender":"DataRetention","connection_id":"data_retention_user1","message":"user \"user1\" does not have permissions to check retention on \"/files/2024-03-13\", retention check skipped"}
{"level":"debug","time":"2024-03-13T12:23:42.682","sender":"DataRetention","connection_id":"data_retention_user1","message":"retention check completed for folder \"/files\", deleted files: 0, deleted size: 0 bytes"}
{"level":"info","time":"2024-03-13T12:23:42.682","sender":"DataRetention","connection_id":"data_retention_user1","message":"retention check completed"}
{"level":"debug","time":"2024-03-13T12:23:42.682","sender":"eventmanager","message":"executed action \"delete-old-files-user1\" for rule \"delete-old-files-user1\", elapsed 11.743027ms"}
```

### 4. Stop and Remove Volumes
```
docker compose rm --force --volumes
```
(to have a clean start next time)