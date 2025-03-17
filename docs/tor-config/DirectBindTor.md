# Haveno using OS provided tor aka little-t-tor

Since Haveno v1.0.10 there is the [DirectBindTor](https://github.com/haveno-dex/haveno/commit/3d44f3777c7bdf56707ca5d0768877535ac854c5) option.
This means that we can create and use a HiddenService (aka Onion Service) with portforward 9999 with tor (the network daemon) provided by the operating system.

## Debian

Ubuntu and other Debian based as well as almost any OS with systemd

#### 1. Configure a HiddenService in: `/etc/tor/torrc`

```
# Haveno incoming anonymity connections
HiddenServiceDir /var/lib/tor/haveno_service/
HiddenServicePort 9999 127.0.0.1:9999
HiddenServicePort 9999 [::1]:9999
# Rate limiting at the Introduction Points (protects the entire Tor network)
HiddenServiceEnableIntroDoSDefense 1
```

??? info "HiddenService options"
    Not needed for Haveno-desktop daemon. Useful for seednodes or your own monerod.<br>
    ```
    # HiddenService options are per onion service:
    ##
    ## Rate limiting at the Introduction Points
    HiddenServiceEnableIntroDoSDefense 1
    #HiddenServiceEnableIntroDoSRatePerSec 25       # (Default: 25)
    #HiddenServiceEnableIntroDoSBurstPerSec 200     # (Default: 200)

    # Number of introduction points the hidden service will have. You can’t have more than 20.
    #HiddenServiceNumIntroductionPoints 3           # (Default: 3)

    ## https://onionservices.torproject.org/technology/pow/#configuring-an-onion-service-with-the-pow-protection
    ## Proof of Work (PoW) before establishing Rendezvous Circuits
    ## The lower the queue and burst rates, the higher the puzzle effort tends to be for users.
    HiddenServicePoWDefensesEnabled 1
    #HiddenServicePoWQueueRate 200          # (Default: 250)
    #HiddenServicePoWQueueBurst 1000        # (Default: 2500)
    #CompiledProofOfWorkHash auto           # (Default: auto)

    ## Stream limits in the established Rendezvous Circuits
    HiddenServiceMaxStreams 10
    HiddenServiceMaxStreamsCloseCircuit 1
    ```

- Reload Tor config to create the HiddenService with: `sudo systemctl reload tor`
- Get *Your_HiddenService_address*: `sudo cat /var/lib/tor/haveno_service/hostname`

#### 2. Start Haveno with *Your_HiddenService_address*

`/opt/haveno/bin/Haveno --hiddenServiceAddress=Your_HiddenService_address.onion --nodePort=9999`

## Whonix

On Whonix systems we need to configure 2 files. In the different Whonix types, the two files to be edited are in different places. Further details please see the two Whonix Wiki links.<br>
If you use Qubes-Whonix, read there how to get your `TARGET` IP! `qubesdb-read /qubes-ip`

1. [Create a HiddenService on Whonix-Gateway](https://www.whonix.org/wiki/Onion_Services#Step_2:_Edit_Tor_Configuration)
2. [Open Whonix-Workstation Firewall Port 9999](https://www.whonix.org/wiki/Onion_Services#Step_2:_Open_Whonix-Workstation_Firewall_Port)

### 1. Create a HiddenService on the Whonix-Gateway

File paths are of non-Qubes Whonix running in VirtualBox or KVM - Whonix with Xfce graphical user interface (GUI)

!!! note
    There is a provided `Tor Examples` Button for *torrc.examples* &<br>
    `Tor User Config` in the Whisker Menu `Application` -> `System`<br>
    Please open *torrc.examples* in your Whonix VM and check the IP in web server example!<br>
    You may need to adjust the TARGET IP<br>
    You can use the `Tor User Config` Button or `sudoedit` in Terminal to edit `50_user.conf`

`sudoedit /usr/local/etc/torrc.d/50_user.conf`

```
# Haveno incoming anonymity connections
HiddenServiceDir /var/lib/tor/haveno_service/
HiddenServicePort 9999 10.152.152.11:9999
# Rate limiting at the Introduction Points (protects the entire Tor network)
HiddenServiceEnableIntroDoSDefense 1
```
and save the file.

??? info
    `HiddenServiceVersion 3` as in the examples of the Whonix wiki is **not** required, this is the Tor default.<br>
    Hidden (Onion) services version 2 is deprecated and is no longer supported since the 0.4.6.1-alpha Tor release, in 2021!

- Reload Tor config to create the HiddenService with: `sudo systemctl reload tor`<br>
Alternatively, there's even a GUI button for: `Reload Tor`
- Get *Your_HiddenService_address* with: `sudo cat /var/lib/tor/haveno_service/hostname`
- **Copy it for your Whonix-Workstation.**

Whonix-Gateway is ready, switch to Whonix-Workstation.

### 2. Edit Whonix-Workstation firewall configuration to open port 9999

!!! info
    There is `Global Firewall Settings` in the Whisker Menu `Application` -> `System` whith examples & notes.<br>
    You can use the `User Firewall Settings` Button or `sudoedit` in Terminal to edit `50_user.conf`

`sudoedit /etc/whonix_firewall.d/50_user.conf`

```
# Open TCP port on all network interfaces,
# gateway as well as (if any) tunnel (VPN) interfaces.
EXTERNAL_OPEN_PORTS+=" 9999 "
```
and save the file.

Reload Whonix Firewall using: `sudo /usr/bin/whonix_firewall`<br>
There's even a GUI button for: `Reload Firewall` ;-)


That was all to configure a HiddenService for our Haveno app in Whonix.

### 3. Download & Install Haveno on Whonix-Workstation

1. Download the latest version of the .deb & .sig version of Haveno-reto (now renamed RetoSwap) from https://github.com/retoaccess1/haveno-reto/releases/ or https://RetoSwap.com <br>
(eg: for RetoSwap v1.0.18, download https://github.com/retoaccess1/haveno-reto/releases/download/v1.0.18/haveno-linux-deb.zip & https://github.com/retoaccess1/haveno-reto/releases/download/v1.0.18/haveno-linux-deb.zip.sig).<br>
It should download automatically to `/home/user/.tb/tor-browser/Browser/Downloads/`

!!! tip
    If you want to check the SHA checksum of the zipped binary file you can either open `*-hashes.txt` online or download and verify `*-hashes.txt` and `*-hashes.txt.sig`.


2. Verify the signature<br>
Download RetoSwap's Public Key `wget https://retoswap.com/reto_public.asc`<br>
List Fingerprint: `gpg --show-keys --with-fingerprint reto_public.asc`<br>
**TODO:** RetoSwap arbs should publish fingerprint on their website and SimpleX chat welcome message!<br>
`gpg --import reto_public.asc`<br>
Downloading & verifying keys is a one-time thing. Binaries are verified after each download.<br>
Verify if the downloaded file is signed with RetoSwap key:<br>
`cd /home/user/.tb/tor-browser/Browser/Downloads/`<br>
`gpg --verify haveno-linux-deb.zip.sig haveno-linux-deb.zip`<br>
Who wants: Check if the hash **&** binary file is signed with the RetoSwap key and compare with shasum in hashes.txt<br>
`gpg --verify v*-hashes.txt.sig v*-hashes.txt`<br>
`gpg --verify haveno-linux-deb.zip.sig && sha512sum haveno-linux-deb.zip`

3. Extract the archive: right-click on the downloaded .zip (eg: /home/user/.tb/tor-browser/Browser/Downloads/haveno-linux-deb.zip), click “Extract Here”<br>
4. Install the .deb: open the newly extracted folder<br>
`/home/user/.tb/tor-browser/Browser/Downloads/haveno-linux-deb/` and in a terminal window, type sudo dpkg -i (with a trailing space) and then drag the .deb installer from the folder into the terminal to complete the filepath (eg: for Haveno-reto v1.0.18, it should be:<br>
`sudo dpkg -i '/home/user/.tb/tor-browser/Browser/Downloads/haveno-linux-deb/haveno-v1.0.18-linux-x86_64-installer.deb`<br>
Press ++enter++, Haveno-reto should be installed to /opt/haveno/. If it fails because of missing dependencies, run the command `sudo apt install -f` to download and install the missing dependencies and then try the original `sudo dpkg -i '[...].deb'` command again.

??? info "Alternative install in a terminal window"
    `cd /home/user/.tb/tor-browser/Browser/Downloads/`<br>
    `gpg --verify haveno-linux-deb.zip.sig haveno-linux-deb.zip`<br>
    Hint: I prefer to have everything in the User Downloads folder<br>
    `unzip haveno-linux-deb.zip -d /home/user/Downloads/Haveno`<br>
    `sudo dpkg -i /home/user/Downloads/Haveno/haveno-v*-linux-x86_64-installer.deb`<br>
    `rm /home/user/.tb/tor-browser/Browser/Downloads/haveno-linux-deb*`


Haveno Launcher should be in `Applications` -> `Internet` You must edit it to:<br>
`/opt/haveno/bin/Haveno --hiddenServiceAddress=Your_HiddenService_address.onion --nodePort=9999`

??? info "Reminder"
    **Your_HiddenService_address** is the saved output from Whonix-Gateway<br>
    `sudo cat /var/lib/tor/haveno_service/hostname`

If not create a desktop shortcut: copy (or drag) `/opt/haveno/lib/haveno-Haveno.desktop` to your desktop and add the cmdline options like in the launcher above.

You can list all available haveno-desktop options for cmdline:<br>
`/opt/haveno/bin/Haveno -h`<br>
or to use in `/home/user/.local/share/Haveno-reto/haveno.properties`

## Qubes OS

For Qubes/Whonix there are installation scripts for using Haveno in 2 ways:<br>
with DirectBindTor (static HiddenService) or [ExternalTor](external-tor-usage.md) (dynamic HiddenService) with the help of Netlayer/jtorctl.

- [Haveno on Qubes/Whonix](https://github.com/haveno-dex/haveno/tree/master/scripts/install_whonix_qubes)
- [Install Haveno on Qubes/Whonix](https://github.com/haveno-dex/haveno/blob/master/scripts/install_whonix_qubes/README.md)
- [Documentation Haveno on Qubes/Whonix](https://github.com/haveno-dex/haveno/blob/master/scripts/install_whonix_qubes/INSTALL.md)

## Every OS

Backup your Tor Hidden (Onion) Service Private Key

!!! remember "Reminder"
    You may backup the onion service key. This is necessary in order to restore it on another machine, after HDD/SSD failure, etc. to recover or reuse your Haveno ID.

Root permission is required to access it ('su -' or sudo)

`cp /var/lib/tor/hidden_service/hs_ed25519_secret_key /home/user/hs_ed25519_secret_key`

Although only the private key is needed to restore a HiddenService, I prefer to back up the entire HiddenService folder:
`cp -r /var/lib/tor/hidden_service/ /home/user/hidden_service/`

Then save the key or folder in a secure location. Best together with your Haveno wallet seed and backup.
