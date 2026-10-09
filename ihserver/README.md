# Ivanhoe Handyman Services server

`ihserver` serves the website, enquiry email endpoint and HMB booking API. It
manages HTTPS certificates, reads Gmail and HMB credentials from a reVault
Lockbox, and exposes an HTTPS unlock page while those credentials are locked.
The `ihlaunch` supervisor starts the server and restarts it after a crash.

The deployment package contains the installer, compiled server and supervisor,
reVault native library, and `www_root` assets. Configuration, Lockboxes, booking
data and certificates are maintained separately on the server.

## Configuration

The application always reads `config/config.yaml` relative to its **working
directory**. There is no `--config` option. The installed service runs from
`/opt/handyman`, so its configuration is `/opt/handyman/config/config.yaml`.
For local development, run from the `ihserver` project directory.

`release/config.yaml` may be used as a local production template, but neither
build nor deploy copies it to the server. Edit the deployed configuration
explicitly, then restart the service to apply changes.

### Production example

```yaml
path_to_static_content: /opt/handyman/www_root
lets_encrypt_live: /opt/handyman/letsencrypt/live
fqdn: ivanhoehandyman.com.au
additional_fqdns:
  - hmb.ivanhoehandyman.com.au
domain_email: bsutton@onepub.dev
use_https: true
https_port: 443
http_port: 80
production: true
binding_address: '::'
logger_path: /var/log/ihserver.log
debug: false
booking_requests_path: /opt/handyman/config/booking_requests.json

lockbox_path: /opt/handyman/config/ihserver.lbox
lockbox_unlock_mode: agent
gmail_username_variable: /gmail_app_username
gmail_password_variable: /gmail_app_password
hmb_token_variable: /hmb_api_token
# Leave empty until you have created a Better Stack heartbeat.
lockbox_heartbeat_url: ''
```

Quote `'::'` in YAML. This binds HTTP and HTTPS to an IPv6 socket accepting both
IPv6 and IPv4. It continues serving IPv6 when IPv4 is disabled on the host.
An existing `binding_address: 0.0.0.0` overrides the default and remains IPv4-only.
The UDP collector independently binds to `::` on port 4040 after unlocking.

### Server settings

| Setting | Default | Purpose |
| --- | --- | --- |
| `path_to_static_content` | No usable default; set explicitly | Directory containing `index.html` and the website assets. |
| `fqdn` | No usable default; set explicitly | Primary HTTPS hostname and the origin accepted by the unlock form. |
| `additional_fqdns` | See below | Additional HTTPS hostnames, each with its own SNI certificate. Use `[]` to disable them. |
| `domain_email` | No usable default; set explicitly | Email address supplied to Let's Encrypt. |
| `use_https` | `false` | Enables HTTPS and HTTP-to-HTTPS redirects. Must be `true` for web unlocking. |
| `http_port` | `80` | HTTP listener. The CA must be able to reach HTTP challenges on public port 80. |
| `https_port` | `443` | HTTPS listener and redirect destination port. |
| `binding_address` | `'::'` | Local address for HTTP/HTTPS listeners. |
| `production` | `false` | `true` uses live Let's Encrypt certificates; `false` uses staging certificates. This is independent of `use_https`. |
| `lets_encrypt_live` | `/opt/ihs/letsencrypt/live` | Certificate storage. Set `/opt/handyman/letsencrypt/live` explicitly for this installation. |
| `logger_path` | `print` | Log file path, or `console`/`print` for console output. |
| `debug` | `false` | Skips the startup email. Credentials are still required. |
| `booking_requests_path` | `config/booking_requests.json` | Persistent booking-request JSON file. |

For `ivanhoehandyman.com.au` and `www.ivanhoehandyman.com.au`, the default
`additional_fqdns` includes `hmb.ivanhoehandyman.com.au`. Other primary hostnames
default to no additional domains. An explicit list overrides the default.
Relative paths resolve from the working directory, not from the YAML file's
parent directory.

### Lockbox settings

The server uses `revault_api` 0.4.x, which bundles the format-3 native engine
compatible with archives produced by reVault CLI 0.0.17. The dependency constraint
keeps updates within the 0.4.x compatibility line.

| Setting | Default | Purpose |
| --- | --- | --- |
| `lockbox_path` | `config/ihserver.lbox` | Path to the encrypted Lockbox file. |
| `lockbox_unlock_mode` | `agent` | `agent` reads an already-open Session Agent entry; `vault` uses the service account's default Vault and saved platform credential. |
| `gmail_username_variable` | `/gmail_app_username` | Secret variable containing the Gmail account name. |
| `gmail_password_variable` | `/gmail_app_password` | Secret variable containing the Gmail app password. |
| `hmb_token_variable` | `/hmb_api_token` | Secret variable containing the token used to authenticate HMB API requests. |
| `lockbox_heartbeat_url` | Empty; disabled | Better Stack heartbeat base URL, without `/fail`. Must be available before unlocking. |

All three credential variables must exist as **secret variables**, including the
Gmail username, and contain nonblank values. The old `gmail_app_username`,
`gmail_app_password` and `hmb_api_token` YAML fields are ignored. All three are
required even if you do not use the enquiry endpoint or enable `debug`.

Provision the Lockbox separately with reVault and copy it to `lockbox_path`.
For browser unlocking, give it a password access slot. Enter real credentials
locally through reVault, rather than in shell arguments or source files. A Gmail
app password can be managed in your [Google account](https://myaccount.google.com/apppasswords).
Remove legacy plaintext YAML credentials after verifying the Lockbox.

## First-time server setup

The current installer targets Linux at `/opt/handyman`. It runs the service as
root, installs a cron boot entry, and assigns the website directory to the
hard-coded account `bsutton:bsutton`. That account must exist; adapt the installer
before using a different account on another host.

1. Create `/opt/handyman` and give the SSH deployment user permission to create
   temporary upload directories inside it. For the current account:

   ```console
   sudo mkdir -p /opt/handyman/config
   sudo chown bsutton:bsutton /opt/handyman
   ```

2. Create `/opt/handyman/config/config.yaml` using the production example and
   provision `/opt/handyman/config/ihserver.lbox`. Ensure root can read both.
   Restrict access to these files, especially the heartbeat URL in the YAML.
3. Configure each HTTPS hostname to reach this server. Allow inbound TCP 80/443;
   allow UDP 4040 if HMB startup collection is required. Preserve the certificate
   storage directory across deployments. With Cloudflare, use HTTPS to the origin
   (Full/strict with a trusted origin certificate) for the unlock page.
4. Build and deploy from the development machine as described below.
5. Open the primary hostname's `/unlock` page and verify service startup.

Use staging certificates when testing ACME configuration. Staging certificates
are not publicly trusted; use `production: true` for the live site.

## Build and deploy from the development machine

Run the following from the `ihserver` project directory, **without sudo**.
You need Dart 3.10 or newer with `dart build cli` support, access to the project's
package repositories, and an authenticated Google Cloud CLI with SSH/SCP access
to the target instance. The remote account must be able to run the installer
with sudo; the tool retains a terminal so sudo can prompt.

```console
cd ihserver
dart pub get
tool/build --help
```

Set the deployment target in `tool/build.yaml`:

```yaml
target_server: handyman
target_directory: /opt/handyman
project: production-365402
zone: us-west4-a
```

| Setting | Meaning |
| --- | --- |
| `target_server` | GCP instance name used for SSH and SCP. |
| `target_directory` | Must be `/opt/handyman`; installation paths are fixed. |
| `project` | GCP project containing the instance. |
| `zone` | GCP instance zone. |

### Normal deployment

```console
tool/build
```

This builds the server and supervisor as native CLI bundles, packs the website
and native runtime, builds the installer, uploads its entire bundle, installs
it on the target with sudo, and restarts the service. **No reboot is needed.**

### Build and deploy separately

```console
tool/build --local
tool/deploy
```

`tool/deploy` uploads the existing `build/install/bundle`; it does not rebuild.
Run `tool/build --local` again after source or website changes. The shell wrappers
run Dart source, so the local build/deploy/reload tools themselves do not need
to be compiled separately.

Uploads are staged under `/opt/handyman/.install-<timestamp>/bundle`. Deployment
runs the uploaded `bin/install`, then removes the staging directory on success.
A failed installation leaves the uploaded bundle for diagnosis. The tools use
`gcloud compute scp --dry-run` to obtain authentication and host-key options,
then bracket IPv6 destinations before executing SCP.

Installation replaces the packaged binaries, native library and website assets.
It preserves the deployed configuration, Lockbox, booking data and certificates.
Do not keep custom files only in `www_root`, which the installer recreates.
The server needs its adjacent `lib` directory; do not deploy only its executable.

## CLI reference

### Development-machine commands

| Command | Action |
| --- | --- |
| `tool/build` | Build, upload, install and restart. |
| `tool/build --local` | Build only; no remote operations. |
| `tool/build --help` or `-h` | Show build usage. |
| `tool/deploy` | Upload and install the existing build, then restart. |
| `tool/deploy --reload` | Restart the remote installed service without uploading. |
| `tool/deploy --help` or `-h` | Show deployment usage. |
| `tool/reload` | Shortcut for `tool/deploy --reload`; no build or upload. |
| `tool/reload --help` or `-h` | Show the delegated deployment usage. |

The equivalent source entry points are `dart run tool/build.dart`,
`dart run tool/deploy.dart`, and `dart run tool/reload.dart` with the same options.

### Commands on the server

| Command | Action |
| --- | --- |
| `/opt/handyman/bin/ihserver --help` or `-h` | Show server usage. |
| `/opt/handyman/bin/ihserver` | Run the server in the foreground; run from `/opt/handyman`. |
| `/opt/handyman/bin/ihlaunch --help` or `-h` | Show supervisor usage. |
| `sudo /opt/handyman/bin/ihlaunch --reload` | Restart the installed supervisor and server, then exit. |
| `/opt/handyman/bin/ihlaunch` | Run the supervisor in the foreground; run from `/opt/handyman`. |
| `<bundle>/bin/install --help` or `-h` | Show installer usage without installing. |
| `sudo <bundle>/bin/install` | Install packaged resources and restart. |
| `sudo <bundle>/bin/install --verbose` or `-v` | Install with verbose output. `--no-verbose` disables it. |
| `sudo <bundle>/bin/install --restart` | Restart the installed service without unpacking resources. |

Replace `<bundle>` with the uploaded or manually copied installer bundle path.
The normal remote workflow invokes it for you. `install` is the server-side
installer; `tool/deploy` is the development-machine uploader. `ihserver` itself
has no restart option—use `ihlaunch`.

Help does not require application credentials. Restart stops this installation's
supervisor before its server and starts the supervisor in `/opt/handyman`.
A successful restart message confirms the launcher was started and prints unlock
instructions using the installed configuration. The application may still need
unlocking. Do not start a second foreground server or supervisor
while the installed service is running.

## Unlock after deployment or reboot

When credentials are unavailable, HTTP/HTTPS starts in locked mode. Normal
application routes return `503`; the UDP collector and startup email wait.
The startup log prints unlock instructions before attempting automatic credential
loading, and reports `Unlock required` if that attempt fails. With HTTPS enabled,
the instructions include the configured unlock URL and any nonstandard port.
Visit **https://ivanhoehandyman.com.au/unlock** (or your configured `fqdn`, with
the HTTPS port if nonstandard) and enter the **Lockbox password**, not the Vault
passphrase. Use the primary hostname: the form checks that origin, even when
additional HTTPS hostnames are configured.

HTTPS must be enabled and its certificate available or obtainable through ACME.
Plain HTTP password submission is rejected. The page uses CSRF protection,
disables caching and framing, limits body size, serializes password operations,
and permits at most five attempts per five minutes across all clients.
Sanitized failure messages identify configuration or unlock problems without
returning credential values or raw native errors.

Successful unlocking validates all three secrets and enables application routes.
The password is not saved to YAML, logs, the Vault or the Session Agent.
Credentials remain in process memory until exit; a web-unlocked service needs
another unlock after restart. Changing the Lockbox does not update credentials
already in memory—restart and unlock again.

Local unlocking is also supported in `agent` mode. The server checks the Session
Agent every ten seconds while locked. Unlock using the same OS account as the
service (currently root):

```console
sudo lbx /opt/handyman/config/ihserver.lbox open
```

Opening another user's agent does not unlock root's service. Agent expiry does
not revoke credentials already loaded by a running server. With `vault` mode,
automatic opening instead requires the service account's default Vault and saved
platform credential to be available in the actual boot environment. A desktop
user's interactive credential store does not automatically provide root's cron
job with access.

## Better Stack heartbeat alerts

1. In Better Stack, open **Heartbeats → Create heartbeat**.
2. Name it **Handyman Lockbox**. Set the expected interval to **2 minutes** and
   the grace period to **1 minute**.
3. Configure on-call escalation to notify you, then create the heartbeat.
4. Copy its secret base URL into the deployed YAML, without `/fail`:

   ```yaml
   lockbox_heartbeat_url: 'https://uptime.betterstack.com/api/v1/heartbeat/REPLACE_WITH_TOKEN'
   ```

5. Restart with `tool/reload` from your development machine, or
   `sudo /opt/handyman/bin/ihlaunch --reload` on the server.
6. Check that the locked state alerts you, open `/unlock`, and confirm recovery
   after unlocking. Add that page URL to your incident instructions.

The server sends `/fail` while locked and the normal success heartbeat while
unlocked, repeating every 60 seconds. Missing heartbeats also alert after the
configured interval and grace period. Better Stack leaves new heartbeats pending
until the first request. Keep your external website monitor enabled too: the
heartbeat reports credential state, not end-to-end website availability.

The URL must be available before unlocking and therefore belongs in the bootstrap
configuration, not the locked Lockbox. Treat it as a credential; do not commit or
log the real URL. An empty/omitted setting disables delivery. The implementation
accepts only HTTPS URLs on `uptime.betterstack.com` with the base heartbeat path,
without query parameters or fragments. Delivery errors are logged without the
URL or response body. Gmail is not needed to send these alerts.

See [Better Stack's heartbeat setup and failure reporting](https://betterstack.com/docs/uptime/cron-and-heartbeat-monitor/).

## Verify a deployment

On the server:

```console
sudo tail -n 80 /var/log/ihserver.log
sudo ss -lntp '( sport = :80 or sport = :443 )'
sudo ss -lnup 'sport = :4040'
```

Startup logs report the configuration path, working directory, configured/default
settings, required file presence, and sanitized credential failures. Secret values
and the heartbeat URL are excluded. Confirm the binding is `::`, then unlock.
The collector appears only after credentials load.

Test HTTPS directly on the server, bypassing Cloudflare while retaining the
certificate hostname:

```console
curl --noproxy '*' \
  --resolve 'ivanhoehandyman.com.au:443:[::1]' \
  -sS -o /dev/null -w 'IPv6 status: %{http_code}\n' \
  https://ivanhoehandyman.com.au/

curl --noproxy '*' \
  --resolve 'ivanhoehandyman.com.au:443:127.0.0.1' \
  -sS -o /dev/null -w 'IPv4 status: %{http_code}\n' \
  https://ivanhoehandyman.com.au/
```

Expect `503` while locked and `200` after unlocking with `index.html` present.
Test IPv4 only while that stack is enabled. Connection refusal indicates no
listener at that address/port; check startup logs and the actual deployed YAML.
An unlock-origin error means you should open the primary configured HTTPS origin
in a fresh tab. Heartbeat delivery errors warrant checking the configured URL and
outbound connectivity without printing the secret URL.

## Logs, certificates and request limits

The launcher and server share the configured log file. The first write after
midnight rotates the previous log to `<logger_path>.YYYY-MM-DD`. Startup and
daily cleanup retain today and the preceding 29 calendar days. Cleanup waits
until a log write if idle. A persistent `<logger_path>.lock` coordinates writers.

HTTPS selects certificates by SNI for the primary and additional hostnames.
Certificates are checked hourly and renewed when fewer than 15 days remain.
TLS logs include hostnames, public certificate paths, issuer and UTC expiry;
private keys are not logged.

Failed/interrupted certificate requests reserve a cooldown on disk before
contacting Let's Encrypt: one hour, then two, four, eight, sixteen and at most
24 hours after consecutive failures. Success clears the failure count. State
lives under `.acme-retry/production` or `.acme-retry/staging` inside
`lets_encrypt_live`. Preserve it across deployments and restarts. Correct the
validation problem before the next logged retry time; deleting state bypasses
this installation's protection against repeated requests.

Application routes allow 100 requests per client IP per minute. Exceeding this
limit, or receiving a route-specific `429`, blocks that client for 30 minutes.
Blocked requests return `429` and `Retry-After`. HTTP and HTTPS share the in-memory
state, which resets on restart. The unlock form has its separate limit described
above. Client addresses use the same Cloudflare/forwarded-header handling as logs.

The supervisor backs off short-lived crashes from ten seconds to five minutes.
A run lasting at least five minutes resets that delay. The installer creates
`/etc/cron.d/ihserver` to launch the supervisor as root after reboot.

## Local development

Create `config/config.yaml` under `ihserver`. A minimal HTTP example is:

```yaml
path_to_static_content: www_root
fqdn: localhost
domain_email: developer@example.com
additional_fqdns: []
use_https: false
http_port: 1080
binding_address: '::'
production: false
logger_path: console
debug: true
lockbox_path: config/ihserver.lbox
lockbox_unlock_mode: agent
```

Provision all three synthetic credentials in a development Lockbox and open it
in your own Session Agent before starting. HTTP mode cannot accept web unlocks.
Run the server directly from the project directory:

```console
dart run bin/ihserver.dart
```

For HTTPS/ACME development, use a real hostname, enable HTTPS, select staging
certificates and set unprivileged listener ports such as 8080/8443. Arrange DNS
and public port forwarding so HTTP challenges reach that instance. Use separate
certificate and Lockbox storage from production.

Run automated tests with:

```console
dart test
```
