# Installing Hydromotive OpenVPN

Welcome to this step-by-step tutorial on how to gain access to the Hydromotive server.
In this guide, we will walk you through the process of installing the OpenVPN GUI and the necessary certificates to
establish a Virtual Private Network (VPN) connection.
By the end of this tutorial, you will have successfully set up your VPN and gained access to the visualizations in
Grafana.

Let's get started!

## Table of contents

<!-- TOC -->
* [Installing Hydromotive OpenVPN](#installing-hydromotive-openvpn)
  * [Table of contents](#table-of-contents)
  * [Installation](#installation)
    * [Prerequisites](#prerequisites)
    * [Download and install OpenVPN GUI](#download-and-install-openvpn-gui)
    * [Install the Hydromotive certificates](#install-the-hydromotive-certificates)
  * [Connect to the Hydromotive VPN](#connect-to-the-hydromotive-vpn)
  * [Disconnect from the Hydromotive VPN](#disconnect-from-the-hydromotive-vpn)
  * [Contact](#contact)
<!-- TOC -->

## Installation

### Prerequisites

To successfully complete this tutorial, you need to have the OpenVPN GUI installed. This tutorial will guide you through
the installation process.
Additionally, you will need the OpenVPN certificates, which can be obtained from your server administrator.

- hydromotive.zip (Certificate files)
- OpenVPN GUI

### Download and install OpenVPN GUI

> "**Note:** Ensure that you install the community edition and not the commercial (paid) edition."

1. Go to the OpenVPN website.
2. Click on _Community_.

   [Or use this link](https://openvpn.net/community-downloads/)

3. Download the latest release.
4. Install the program using the `.MSI` executable.

### Install the Hydromotive certificates

> "**Note:** Before proceeding, ensure that you have the hydromotive.zip folder!"

1. **Unpack the** `hydromotive.zip` **folder** on your system.
2. **Check the contents of the unzipped folder**, probably named `hydromotive`.

   It should contain the following files:
    - ese-hydromotive.ovpn
    - hydromotive_ca-cert.crt
    - hydromotive_client-cert.crt
    - hydromotive_client-cert.key
    - readme.md
    - secret_hydromotive.txt

> "**Note**: Proceed with this tutorial after checking that every file is present in the unzipped folder."
> 
> "**Note**: Also verify that the OpenVPN GUI is successfully installed."

3. **Copy all the above-named files** to `C:\Users\<YOURNAME>\OpenVPN\config`.

Now the Hydromotive certificates are successfully installed. Let's verify that this is indeed the case.

4. **In Windows 11**, look at the hidden icons (Bottom right corner) to see if the program is running.
5. **Right-click the OpenVPN GUI icon** (Monitor with a lock). There should be a option labeled **_Connect_**.
6. **Click on _Connect_**. Most likely, you need to log in using a _client certificate secret_ password. This password
   is present in the `readme.md` file.

## Connect to the Hydromotive VPN

1. **In Windows 11**, look at the hidden icons (Bottom right corner) to see if the program is running.
2. Then **right-click the OpenVPN GUI icon** and **click on _Connect_**.
3. After a successful connection, you will get a notification that you are connected to the VPN.

## Disconnect from the Hydromotive VPN

1. **In Windows 11**, look at the hidden icons (Bottom right corner).
2. Then **right-click the OpenVPN GUI icon** and click on **_Close connection_**.
3. After a successful disconnection, you will get a notification that you are disconnected from the VPN.

## Contact

Julian
Janssen - [@GhostJulian](https://gitlab.com/GhostJulian)  - [jwr.janssen@student.han.nl](mailto:jwr.janssen@student.han.nl)

Project Link: https://gitlab.com/hydromotive/2425-acquistionmodule-dev