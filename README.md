
# lpx_links

lpx_links is a utility to get the direct download links for the additional sample/sound content for Logic Pro X.

- It gets the most current links
- Creates a text file with all the links in them
- Importing the links file into a download manager like the DownThemAll addon for FireFox should work well

Includes Mandatory only list. Thanks to _Matteo Ceruti_ aka [Matatata](https://github.com/matatata) for the idea.
   
### Version  
0.0.9 - fixes issue where the install script attempted to re-download the pkg files 🤦‍

0.0.8 - adds logic to resolve relative parents in download URLs & Readme updates.

0.0.7 - added mandatory file list & refactor of code.

0.0.6 - added version detection. Any version of Logic Pro X should work now.

## Usage

Simply open the terminal and paste the command below. 
  
```sh  
 cd ~/Downloads; mkdir -p lpx_links/app ; cd lpx_links/app ; curl -#L https://goo.gl/nUrpPi | tar -xzv --strip-components 1 ; ./lpx_links.rb  
  
```  
  
To download I recommend using *aria2*
- Download & install - [aria2 ver1.33.0 installer](https://github.com/aria2/aria2/releases/download/release-1.33.0/aria2-1.33.0-osx-darwin.dmg)  

- Then in the Terminal  

To only download the mandatory files (32)
```shell  

aria2c -c --auto-file-renaming=false -i ~/Desktop/lpx_download_links/mandatory_download_links.txt -d ~/Downloads/logic_content
```
To download all the packages
```shell
aria2c -c --auto-file-renaming=false -i ~/Desktop/lpx_download_links/all_download_links.txt -d ~/Downloads/logic_content
```

 - -c tells aria2 to continue/resume downloads
 - --auto-file-renaming=false ensures that files will never be redownloaded if they already exist in the target directory
 - -i is the path to the file with list of downloads
 - -d is the path to where you want the downloaded files
     
  ![aria2 download example](https://github.com/davidteren/lpx_links/blob/master/images/aria2_example.png?raw=true)
### Install All  
  
To install all the downloaded packages use the following command:  

For mandatory files
```sh
 sudo ~/Downloads/lpx_links/app/install.sh ~/Downloads/logic_content
```

For all the packages
```sh
 sudo ~/Downloads/lpx_links/app/install.sh ~/Downloads/logic_content
```

### Development  
  
Want to contribute? Fork and let me know.  
  
License  
----  

GNU General Public License, version 3 (GPL-3.0)  
(http://opensource.org/licenses/GPL-3.0)
