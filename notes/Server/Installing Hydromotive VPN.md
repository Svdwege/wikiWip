# Installing Hydromotive OpenVPN

Welcome to this tutorial on how to install the Hydromotive OpenVPN certificates.
With the VPN you will have acces to the visualizations in Grafana

<!-- TOC -->
* [Installing Hydromotive OpenVPN](#installing-hydromotive-openvpn)
  * [Installation](#installation)
    * [Prerequisites](#prerequisites)
    * [Download and install OpenVPN GUI](#download-and-install-openvpn-gui)
    * [Install the Hydromotive certificate](#install-the-hydromotive-certificate)
    * [Connect to the Hydromotive VPN](#connect-to-the-hydromotive-vpn)
    * [Disconnect to the Hydromotive VPN](#disconnect-to-the-hydromotive-vpn)
  * [Contact](#contact)
<!-- TOC -->


## Installation

To install the OpenVPN certificates, you first need to install the OpenVPN.
This manual will guide you through this proces

### Prerequisites

- Hydromotive certificate 
- OpenVPN GUI

### Download and install OpenVPN GUI

1. Go to the OpenVPN website 
2. Click on _Community_.


   [Or use this link](https://openvpn.net/community-downloads/)

3. Download the latest release
4. Install the program using the `.MSI` executable


### Install the Hydromotive certificate

After the program is installed, it runs on the background.

1. In Windows 11, look at the hidden icons (Bottom right corner) to see if the program is running.
2. Right-click the OpenVPN GUI icon (Monitor with a lock), Select _Import --> import file..._
3. Retrieve the `ese-hydromotive.ovpn` from the Hydromotive.zip

Now the certificate is installed.

1. To verify that it works, locate the OpenVPN GUI.
2. Then right-click the OpenVPN GUI icon and click on _Connect._
3. You might need to login using the _client certificate secret_. this is located in the `readme.md` inside of the `Hydromotive.zip`. 


### Connect to the Hydromotive VPN

1. In Windows 11, look at the hidden icons (Bottom right corner) to see if the program is running.
2. Then right-click the OpenVPN GUI icon and click on _Connect._
3. After a successful connection, you ill get a notification that your connected to the VPN.


### Disconnect to the Hydromotive VPN

1. In Windows 11, look at the hidden icons (Bottom right corner).
2. Then right-click the OpenVPN GUI icon and click on _Close connection._


## Contact

Julian Janssen - [@GhostJulian](https://gitlab.com/GhostJulian)  - [jwr.janssen@student.han.nl](mailto:jwr.janssen@student.han.nl)

Project Link: https://gitlab.com/hydromotive/2425-acquistionmodule-dev