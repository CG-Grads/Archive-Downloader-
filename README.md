*****************************************************************************
                   NASA ARCHIVE DOWNLOADER 1.0 - INTRODUCTION
*****************************************************************************


Nasa Archive Downloader is a program that allows us to download the data of 
RXTE, XMM-Newton and Swift satellites to the local server.

The program runs on the terminal screen in Unix-based operating systems.Linux 
should be preferred to provide the best experience.

The first time you run the program, it asks you for a new download path.This 
entered download path is recorded in the program. It shows you the current 
download path for the next usage. It then allows you to enter a 
new download location.

After that, you need to choose which satellite you want to download data from. 
The program is prepared to download the data of RXTE, XMM-Newton and Swift 
satellites.

After that, it asks you for an object name. The next step is the observation 
start date information. If you pass the start date blank, it will not ask you 
for the end date. When you pass this section blank,you will have selected all 
observation dates.

The next step is the data limit you want to download. If you pass this section 
blank, you will have selected all the observations.

After entering this information, your data will begin to download instead of 
the download you specified. Before the download process starts, it is checked 
whether each ObsId is on NASA's ftp server. This part appears when the program 
is running as Pointing Check.


*****************************************************************************
                BUILDING AND INSTALLING NASA ARCHIVE DOWNLOADER
*****************************************************************************

There are two software that must be present on the local server for the program to 
use. These are "curl" and "wget".

You will need the following to build this software ( Ubuntu ) :

	* curl 	:	

		$ sudo apt update

		$ sudo apt upgrade

		$ sudo apt install curl

	* wget	:

		$ sudo apt update

		$ sudo apt upgrade

		$ sudo apt install wget

After completing the requirements, you have a few steps of installation process.

	* If you are not a super user in the server, we should run it like this;
	
	$ . install.sh 

	* If you are a super user in the server, we should run it like this; 
	
	$ sudo bash install.sh 
	$ source /etc/bash.bashrc 

	* After this, there is no other action you need to do. You can start using 
	the program by typing " archive_downloader " on the terminal.

There is one step you need to do to delete the program.

	* You can delete all the adjustments made with the command;
	
	$ archive_downloader -purge
	
	*Alias command will be deleted, Nasa_Archive folder will be deleted. After 
	that, you can reinstall the program if you want.
	

*****************************************************************************
                 NASA ARCHIVE DOWNLOADER 1.0 - FOLDER ARCHITECTURE
*****************************************************************************


Three folders are created under the download location you entered. Under these 
folders, the folder of the satellite you selected is created.

	1 - pure: This folder contains the raw data of the source you want to 
download.A folder belonging to the resource name has been made in this folder.

	2 - tmp: In this folder, there are catalogs of the source you want to 
download.A folder belonging to the resource name has been made in this folder.

	3 - log: This folder contains information about the source you want to 
download and your download process.Log files are stored in this folder. The 
file names are set based on the source name and download date.

These three folders are always created for a download location that you are using 
for the first time.


*****************************************************************************
                            CONTACT INFORMATION
*****************************************************************************

* Manager

    Dr. Can Güngör			:	gungor.can@istanbul.edu.tr

* Programmers

    Hürkan Mert Duran		:	hurkanmertd@gmail.com

    Mustafa Turan Sağlam	:	mustafaturansaglam@ogr.iu.edu.tr


You can contact us if you encounter an unexpected problem using the script.


