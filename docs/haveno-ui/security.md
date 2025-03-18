# Security tips

## Tor

#### Force Tor routing on monero traffic from RetoSwap:

Syncing your Monero wallet is using clearnet by default (transactions are broadcasted over Tor). If you want to do it over Tor to keep your complete haveno/monero traffic private:
Edit your *haveno.properties* file located at `{haveno-reto-path}/haveno.properties` and add<br>
**--useTorForXmr=ON** in a new line (**--useTorForXmr=AFTER_SYNC** is the default arg)
This setting is also in the GUI in the tab `Settings` -> `NETWORK INFO`.

#### Use RetoSwap with Tor running as a system process in background

Be sure to use in your tor configuration file:

```
PidFile {haveno-reto-path}/xmr_mainnet/tor/pid # Only on Linux
DataDirectory {haveno-reto-path}/xmr_mainnet/tor/
GeoIPFile {haveno-reto-path}/xmr_mainnet/tor/geoip
GeoIPv6File {haveno-reto-path}/xmr_mainnet/tor/geoip6
CookieAuthFile {haveno-reto-path}/xmr_mainnet/tor/.tor/control_auth_cookie
RunAsDaemon 1
AvoidDiskWrites 1
CookieAuthentication 1
ControlPort 9051
SOCKSPort 9050
```

And in your *haveno.properties* file:

```
torControlPort=9051
torControlUseSafeCookieAuth 1
torControlCookieFile={haveno-reto-path}/xmr_mainnet/tor/.tor/control_auth_cookie
useTorForXmr=ON
```

Now you can start Tor in first and then RetoSwap, the client will securely control Tor for all it's needs.

### Install and use RetoSwap on TailsOS

```
$ curl -fsSLO https://github.com/retoaccess1/haveno-reto/raw/master/scripts/install_tails/haveno-install.sh && bash haveno-install.sh https://github.com/retoaccess1/haveno-reto/releases/download/v(last-version)/haveno-linux-deb.zip <DAA24D878B8D36C90120A897CA02DAC12DAE2D0F>
```

To update your TailsOS Retoswap client, just run again this command and be sure you put the [last version](https://github.com/retoaccess1/haveno-reto/releases/latest) link.

## Monero wallet

You can set a wallet password for protecting access of your funds
![Image](../resources/img/haveno-ui/password_wallet.png)

## Monero node

#### Use a custom node on RetoSwap

Add in your *haveno.properties* file:
`xmrNode={IPv4/6, DNS, Tor hidden-service}:18081`

If your node haves RPC authentication, add:
```
xmrNodeUsername={username}
xmrNodePassword={password}
```

If the connection to the monero node is LAN based or inside a virtual/private network, make sure to add:
`useTorForXmr=OFF`

If the monero node is a Tor hidden-service:
`useTorForXmr=ON`

Configuring **one** custom node is usually only desired in your LAN. Custom remote nodes used for Monero as comma separated IP addresses:
`xmrNodes=<(IP|DNS|onion):PORT[,...]>`

!!! info
    `--xmrNode=` disables auto switching

#### Run a monero node using Tor

##### Tor config

Edit your existing Tor config and add:
```
SocksPort 9052 OnionTrafficOnly IsolateDestAddr
HiddenServiceDir {/path/to/hidden-service}
HiddenServicePort 18083 127.0.0.1:18083
HiddenServicePort 18081 127.0.0.1:18081
HiddenServiceEnableIntroDoSDefense 1
HiddenServiceEnableIntroDoSRatePerSec 10
HiddenServiceEnableIntroDoSBurstPerSec 20
HiddenServicePoWDefensesEnabled 1
HiddenServicePoWQueueRate 5
HiddenServicePoWQueueBurst 10
HiddenServiceMaxStreams 1000
HiddenServiceMaxStreamsCloseCircuit 1
```

??? tip
    It is recommended to separate different (onion) hidden services.<br>
    RPC, in particular, may allow unwanted access to 127.0.0.1
    
    ```
    HiddenServiceDir {/path/to/hidden-service}
    HiddenServicePort 18081 127.0.0.1:18081
    HiddenServiceEnableIntroDoSDefense 1
    HiddenServiceEnableIntroDoSRatePerSec 10	# (Default: 25)
    HiddenServiceEnableIntroDoSBurstPerSec 20	# (Default: 200)
    HiddenServicePoWDefensesEnabled 1
    HiddenServicePoWQueueRate 5		# (Default: 250)
    HiddenServicePoWQueueBurst 10	# (Default: 2500)
    HiddenServiceMaxStreams 1000
    HiddenServiceMaxStreamsCloseCircuit 1
    
    HiddenServiceDir {/path/to/other-hidden-service}
    HiddenServicePort 18083 127.0.0.1:18083
    HiddenServiceEnableIntroDoSDefense 1
    HiddenServiceEnableIntroDoSRatePerSec 10	# (Default: 25)
    HiddenServiceEnableIntroDoSBurstPerSec 20	# (Default: 200)
    HiddenServicePoWDefensesEnabled 1
    HiddenServicePoWQueueRate 5		# (Default: 250)
    HiddenServicePoWQueueBurst 10	# (Default: 2500)
    HiddenServiceMaxStreams 1000
    HiddenServiceMaxStreamsCloseCircuit 1
    ```

Start and stop Tor, now your hidden-service will be available at /path/to/hidden-service/hostname (it's a text-file)

##### Monero node config

Get the [last monero-cli version](https://www.getmonero.org/downloads/) and in bitmonero.conf add:
```
rpc-bind-ip=127.0.0.1
rpc-bind-port=18081
rpc-login=username:password
anonymous-inbound="yourhiddenservice.onion":18083,127.0.0.1:18083,25
tx-proxy=tor,127.0.0.1:9052,10
```
Now your monero node will be accessible from the Tor network for your wallet at: yourhiddenservice.onion:18081
