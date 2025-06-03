# How to Copy files to the Hydromotive server

This how-to instruction uses the program [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/). The required programs can be downloaded from [Here](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)

## Table of contents
<!-- TOC -->
* [How to Copy files to the Hydromotive server](#how-to-copy-files-to-the-hydromotive-server)
  * [Table of contents](#table-of-contents)
  * [Prerequisites](#prerequisites)
  * [Shell command](#shell-command)
    * [Basic syntax](#basic-syntax)
  * [Command for Hydromotive server](#command-for-hydromotive-server)
    * [Parameters](#parameters)
  * [Contact](#contact)
<!-- TOC -->

## Prerequisites
 - A `.ppk` key _(PuTTY Private Key)_
 - `pscp` _(a command-line tool, often installed alongside PuTTY)_
 - File(s) to upload/download
 
 
 ## Shell command
 The `pscp` command is similar to the `scp` command but uses a `.ppk` key instead of an OpenSSH key like `.pem`.
 
 ### Basic syntax
 
 ```bash
 pscp source user@hosname:path/to/location
 ```
 > "**Note:** If your path contains spaces, enclose it in double quotes (`"`). "
 
 ## Command for Hydromotive server

To send files to the Hydromotive server, use this command:

 ```bash
 pscp -p -C -scp -i Your_PuTTY_key.ppk source user@hosname:path/to/location/
 ``` 
 > "**Note:** If you don't define the path (i.e., you only specify `username@hostname:`), the files will be uploaded to the home directory of the user."

It is also possible to receive files from the Hydromotive server. This is done using the following syntax:
 ```bash
 pscp -p -C -scp -i Your_PuTTY_key.ppk user@hosname:path/of/the/to/be/send/file destination_on_your_system
 ``` 

### Parameters
- `p:` 		Preserve the attributes (e.g., permissions, date of file creation, date of last time edited, etc.)
- `C:`		Enable compression
- `scp:`	Force the SCP protocol (Secure Copy Protocol)


## Contact

Julian Janssen - [@GhostJulian](https://gitlab.com/GhostJulian)  - [jwr.janssen@student.han.nl](mailto:jwr.janssen@student.han.nl)

Project Link: https://gitlab.com/hydromotive/2425-acquistionmodule-dev