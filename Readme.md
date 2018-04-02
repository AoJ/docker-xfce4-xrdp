# About

Alpine linux xfce4 rdp server with jDownloader

# Usage

Start the server
```bash
docker run -d --shm-size 1g --name rdp -p 3389:3389 aooj/xfce4-xrdp
```

*note --shm-size 1g is for firefox, without it it crashes

Connect with your favorite rdp client

User: alpine
Pass: alpine
