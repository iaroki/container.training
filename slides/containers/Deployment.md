# Deployment

In this chapter, we will start containers which should survive restarts.

---

## There are many ways to start containers

- `docker run --restart=always`

- `restart: always` in docker-compose

- write `container.service` file

- user container orchestrators

---

## --restart=always

Used in scripts and manual running:

```bash
docker run -d --restart=always --name=web -p 8080:80 nginx
```

After system restart and starting up Docker daemon container will be started

**Conflicts with `--rm` flag

---

## docker-compose

Using `restart: always` in docker-compose.yaml:

```yaml
version: '3'
services:
  web:
    image: nginx
    ports:
      - 8080:80
    expose:
      - "8080"
    restart: always
```

---

## Systemd .service file

We can create `/etc/systemd/system/web.service` file with contens:

```ini
[Unit]
Description=web container
After=docker.service
Requires=docker.service

[Service]
TimeoutStartSec=0
Restart=always
ExecStartPre=-/usr/bin/docker kill web
ExecStartPre=-/usr/bin/docker rm web
ExecStart=/usr/bin/docker run --rm \
                          --name web \
                          --p 8080:80 \
                          nginx
ExecStop=/usr/bin/docker stop web

[Install]
WantedBy=multi-user.target
```

Reload systemd daemon:
`# systemctl daemon-reload`

Start web.service:
`# systemctl start web.service`

Enable web.service:
`# systemctl enable web.service`

* Shortcut to start and enable service in one command:
`# systemctl enable --now web.service`


---

## Container orchestrators

- Docker Swarm

- Kubernetes

- Apache Mesos

- Hashicorp Nomad

- etc...

