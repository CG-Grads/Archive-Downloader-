#!/usr/bin/bash

#Programmer : Hürkan Mert DURAN

username=$(whoami)

echo -e "\n##########################################################################"
echo -e "##########################################################################"
echo -e "######################### NASA Archive Installer #########################"
echo -e "##########################################################################"
echo -e "##########################################################################\n"

#Progress Bar

function ProgressBar {
    let _progress=(${1}*100/${2}*100)/100
    let _done=(${_progress}*4)/10
    let _left=40-$_done
    _fill=$(printf "%${_done}s")
    _empty=$(printf "%${_left}s")

printf "\rProgress : [${_fill// /#}${_empty// /-}] ${_progress}%%"

}
_start=1
_end=100

if [ "$EUID" -eq 0 ];then
	
	bashrc="/etc/bash.bashrc"
	save_path="/usr/local/Nasa_Archive"
	mkdir -p ${save_path}
	chmod 777 ${save_path}
	file="$PWD/scripts"
	cp -r "${file}" "${save_path}"
	chmod 777 ${save_path}/scripts

	echo -e "\n--------------------------------------------------------------------------"
	echo -e ">> The folders are being set up. Path : /usr/local/Nasa_Archive"
	echo -e ">> Warning : Please don't delete this folder. Otherwise it will not work."
	echo -e ">>"
        echo -e ">> Please contact us if you have any questions or bugs." 
	echo -e ">> Email:  gungor.can@istanbul.edu.tr"
	echo -e "--------------------------------------------------------------------------\n"
	sleep 1
	for number in $(seq ${_start} ${_end})
	do
	    sleep 0.06
	    ProgressBar ${number} ${_end}
	done
	echo -e "\n--------------------------------------------------------------------------"
	echo -e ">> Folders have been set up and created!"
	echo -e "--------------------------------------------------------------------------\n"
	echo -e "\n--------------------------------------------------------------------------"
	echo -e ">> Alias are being adjusted. "
	echo -e "--------------------------------------------------------------------------\n"
	sleep 1

	echo 'alias sudo="sudo "' >> ${bashrc}
	echo 'alias archive_downloader="bash '${save_path}'/scripts/nasa_archive.sh"' >> ${bashrc}
	echo -e '\nsource_path='${save_path}'/scripts/\n' | cat - ${save_path}/scripts/nasa_archive.sh > temp && mv temp ${save_path}/scripts/nasa_archive.sh
	#source ${bashrc}

	for number in $(seq ${_start} ${_end})
	do
	    sleep 0.06
	    ProgressBar ${number} ${_end}
	done
	sleep 1
	echo -e "\n--------------------------------------------------------------------------"
	echo -e '>> Finished. Alias set in "/etc/bash.bashrc"'
	echo -e ">>"
	echo -e '>> to source the alias "source /etc/bash.bashrc"'
	echo -e '>> And later, you can start using the script by typing "archive_downloader"'
	echo -e "--------------------------------------------------------------------------\n"




else
	
	bashrc="/home/${username}/.bashrc"
	save_path="/home/${username}/Nasa_Archive"
	mkdir -p ${save_path}
	chmod 777 ${save_path}
	file="$PWD/scripts"
	cp -r "${file}" "${save_path}"
	chmod 777 ${save_path}/scripts

	# echo -e "--------------------------------------------------------------------------\n"
	# echo -e "NOTE : The place where the program codes will be hosted."
	# echo -e "Recommended : /home/user/folder"

	# while [ -z "${save_path}" ];do read -ep ">> Will Be Hosted Place : " save_path ; done
	# echo -e "--------------------------------------------------------------------------\n"

	# end_of_path=${save_path: -1}
	# head_of_path=${save_path::1}

	# if [ ${end_of_path} == "/" ]; then
	# 	download_path=$(echo ${save_path} | sed 's/\/$//')
	# fi
	# if [ ${head_of_path} != "/" ]; then
	# 	download_path=""/"${save_path}"
	# fi
	# if [ ${end_of_path} != "/" ]; then
	# 	download_path="${save_path}"
	# fi

	# download_path="${download_path}/Nasa_Archive"

	# mkdir -p "${download_path}"

	# chmod 777 ${download_path}

	# file="$PWD/scripts"

	# cp -r "${file}" "${download_path}"

	# chmod 777 ${download_path}/scripts

	echo -e "\n--------------------------------------------------------------------------"
	echo -e ">> The folders are being set up. Path : /home/${username}/Nasa_Archive"
	echo -e ">> Warning : Please don't delete this folder. Otherwise it will not work."
        echo -e ">>"
        echo -e ">> Please contact us if you have any questions or bugs." 
        echo -e ">> Email:  gungor.can@istanbul.edu.tr"
	echo -e "--------------------------------------------------------------------------\n"
	sleep 1
	for number in $(seq ${_start} ${_end})
	do

	    sleep 0.06
	    ProgressBar ${number} ${_end}

	done
	echo -e "\n--------------------------------------------------------------------------"
	echo -e ">> Folders have been set up and created!"
	echo -e "--------------------------------------------------------------------------\n"
	echo -e "\n--------------------------------------------------------------------------"
	echo -e ">> Alias are being adjusted. "
	echo -e "--------------------------------------------------------------------------\n"
	sleep 1

	echo 'alias archive_downloader="bash '${save_path}'/scripts/nasa_archive.sh"' >> ${bashrc}
	echo -e '\nsource_path='${save_path}'/scripts/\n' | cat - ${save_path}/scripts/nasa_archive.sh > temp && mv temp ${save_path}/scripts/nasa_archive.sh

	source ${bashrc}

	for number in $(seq ${_start} ${_end})
	do
	    sleep 0.06
	    ProgressBar ${number} ${_end}
	done
	sleep 1
	echo -e "\n--------------------------------------------------------------------------"
	echo -e ">> Finished. Alias set.\n"
	echo -e ">> You can start using the script by typing ' archive_downloader '."
	echo -e "--------------------------------------------------------------------------\n"


fi
