#!/bin/bash

#-help
if [[ "${1}" == "-help" ]];then
	more ${source_path}read.me
	exit 1	
fi

#-purge
username=$(whoami)
if [[ "${1}" == "-purge" ]];then

	if [ "$EUID" -eq 0 ];then
		#root silme
		sed -i '/alias archive_downloader="/d' /etc/bash.bashrc
	        sed -i '/alias sudo="/d' /etc/bash.bashrc
		rm -rf "/usr/local/Nasa_Archive"
		

	exit 1
		
	else		
		#normal
		sed -i '/alias archive_downloader="/d' /home/${username}/.bashrc
		rm -rf "/home/${username}/Nasa_Archive"
		source /home/${username}/.bashrc
	exit 1
	fi
return 0
fi

#Section_1: Data input.

echo -e "\n########################################################################"
echo -e "########################################################################"
echo -e "####################### NASA Archive Downloader ########################"
echo -e "########################################################################"
echo -e "########################################################################\n"
current_path=""
if [ ! -z ${current_path} ];then
echo -e "\n--------------------------------------------------------------------------"
echo -e "NOTE: Current Path. If You Want To Change It Enter New Path Below."
echo -e "--------------------------------------------------------------------------"
echo -e ">> Current Path: " ${current_path}
echo -e "--------------------------------------------------------------------------\n" 
fi
if [ -z ${current_path} ];then
	echo -e "\n--------------------------------------------------------------------------"
	echo -e "NOTE: Enter Full Path e.g. /home/user/folder"
	echo -e "--------------------------------------------------------------------------\n"

	while [ -z "${current_path}" ];do read -ep ">> New Download Path: " new_path ; 
	echo -e "--------------------------------------------------------------------------\n"
	if [ ! -z ${new_path} ];then
	end_of_path=${new_path: -1}
	head_of_path=${new_path::1}

	if [ ${end_of_path} == "/" ]; then
		download_path=$(echo ${new_path} | sed 's/\/$//')
		current_path="${download_path}"
		sed -i 's~current_path=""~current_path='$download_path'~g' $0
	fi
	if [ ${head_of_path} != "/" ]; then
		download_path=""/"${new_path}"
		current_path="${download_path}"
		sed -i 's~current_path=""~current_path='$download_path'~g' $0
	fi
	if [ ${end_of_path} != "/" ]; then
		download_path="${new_path}"
		current_path="${download_path}"
		sed -i 's~current_path=""~current_path='$download_path'~g' $0
	fi
	

	fi
	done
else

	echo -e "\n--------------------------------------------------------------------------"
	echo -e "NOTE: Just Enter for Skip. Enter Full Path e.g. /home/user/folder"
	echo -e "--------------------------------------------------------------------------\n"

read -ep ">> New Download Path : " new_path;

echo -e "--------------------------------------------------------------------------\n"
if [ ! -z ${new_path} ];then
	end_of_path=${new_path: -1}
	head_of_path=${new_path::1}

	if [ ${end_of_path} == "/" ]; then
		download_path=$(echo ${new_path} | sed 's/\/$//')
		current_path="${download_path}"
		sed -i 's~current_path=""~current_path='$download_path'~g' $0
	fi
	if [ ${head_of_path} != "/" ]; then
		download_path=""/"${new_path}"
		current_path="${download_path}"
		sed -i 's~current_path=""~current_path='$download_path'~g' $0
	fi
	if [ ${end_of_path} != "/" ]; then
		download_path="${new_path}"
		current_path="${download_path}"
		sed -i 's~current_path=""~current_path='$download_path'~g' $0
	fi

	fi

fi


echo -e "Select Satellite. NOTE : Just enter the numeric value !\n"

echo -e "[1] -> RXTE \n[2] -> XMM-Newton \n[3] -> Swift\n"



while [ -z "${sat}" ]; do

	read -ep ">> Satellite :  " sat;

	if [ ! -z "${sat}" ];then
		if [ ${sat} == "1" ];then
		satellite=rxte
		elif [ ${sat} == "2" ];then
		satellite=xmm-newton
		elif [ ${sat} == "3" ];then
		satellite=swift
		elif [ ${sat} != "1" ] || [ ${sat} != "2" ] || [ ${sat} != "3" ];then
		echo "Warning : Invalid Choose" 
		sat=""
		fi
	fi
	
done

echo -e "--------------------------------------------------------------------------\n"


download_path="${current_path}"

mkdir -p ${download_path}/pure/$satellite
mkdir -p ${download_path}/tmp/$satellite
mkdir -p ${download_path}/log/$satellite

location=${download_path}/pure/${satellite} 
tmp=${download_path}/tmp/${satellite}
log=${download_path}/log/${satellite}

object_name=""

while [ -z "${object_name}" ];do read -ep ">> Object Name : " object_name ; done
echo -e "--------------------------------------------------------------------------\n"

object=${object_name/ /_}

#Object Control
if [ -d ${location}/${object} ];then

	number_object=$(ls -l ${location}/${object}/* | grep "^d" | wc -l | awk '{print $1}')

	
	echo -e "ALERT: This server has ${number_object} observation data of this object.\n"
	read -ep "Continue? (y / n): " ask_first
	echo -e "--------------------------------------------------------------------------\n"
	if [[ "$(echo "$ask_first" | tr '[:upper:]' '[:lower:]')" == "n" ]] || [[ "$(echo "$ask_first" | tr '[:upper:]' '[:lower:]')" == "no" ]] ;then
	exit 1
	else
	check_source="ok"

	all_obsid="${tmp}/${object}/all_obsid.txt"

	sed '1,1d' ${tmp}/${object}/*obsid* > ${all_obsid}
	sed -i '/obsid/d' ${all_obsid} 
	sort -V -o ${all_obsid} ${all_obsid} 
	sed -i '1s/^/obsid\n/' ${all_obsid}

	fi

fi

echo -e "Input Specific Date"
echo -e "NOTE: Date format is MJD. Skip by enter for all observation."
echo -e "--------------------------------------------------------------------------"
read -ep ">> Start Date: " start_date
if [ ! -z ${start_date} ];then
read -ep ">> Stop Date: " stop_date
fi
echo -e "--------------------------------------------------------------------------"
echo -e "\nNOTE: For limitless search enter for skip."
echo -e "--------------------------------------------------------------------------"
read -ep ">> Limit Result To: " limit
echo -e "--------------------------------------------------------------------------\n"


#Section_2: Location prosesing. Control Start Date, Stop Date

if [ -z ${start_date} ]; then
	choose_info="_"
  mkdir -p ${tmp}/${object}
	tmp_location="${tmp}/${object}"
elif [ ! -z ${start_date} ] && [ ! -z ${stop_date} ]; then
	choose_info="_${start_date}_${stop_date}_"
mkdir -p ${tmp}/${object}
	tmp_location="${tmp}/${satellite}/${object}"
	mjd="${start_date} .. ${stop_date}"
fi


if [ ! -d ${location}/${object} ]; then
		mkdir ${location}/${object}
		save_location="${location}/${object}"
		cd ${save_location}
else
	save_location="${location}/${object}"
	cd $save_location
fi


#ctrl+C exit: when you exit during work, its will be delete all output files.
trap_ctrlC() {

			echo -e "\n--------------------------------------------------------------------------"
			echo -e "\nDownloaded catalogues and observation datas are deleting.\n"
			echo -e "--------------------------------------------------------------------------\n"

			if [[ -f "$obsid_file" ]];then


				for obsid_name in ${obsid_file}
			do
				data=$(cat "${obsid_name}" | wc -l)

			  for obs_row in $(seq 2 $data) #i; obs indice
				do
					obsid_first=$(sed -n "${obs_row}"p "${obsid_name}" | cut -d '-' -f 1)
  					obsid_full=$(sed -n "${obs_row}"p "${obsid_name}")

  					last_proposal=$(find ${save_location} -name "P${obsid_first}")


  					if [[ ! -z ${last_proposal} ]];then

  						last_obsid=$(find ${last_proposal} -name "${obsid_full}")
  						last_obsid_down=$(find ${last_proposal} -name "${obsid_full}_downloading")

  						if [[ -z ${last_obsid_down} ]];then
  							rm -rf ${last_obsid_down}
  						else
  							rm -rf ${last_obsid}
  						fi	
  						

  					fi

				done #i
			done

			fi

			if [[ "$(echo "$check_source")" == "ok" ]]; then

			rm ${log}/${object}_$(date +%y%m%d%H%M).log 2> /dev/null || true
			rm ${obsid_file} 2> /dev/null || true
			rm ${tmp_location}/${full_catalog} 2> /dev/null || true
			rm ${tmp_location}/${master_catalog} 2> /dev/null || true
			rm ${tmp_location}/new_obsid.txt 2> /dev/null || true
			rm ${tmp_location}/all_obsid.txt 2> /dev/null || true
			rm ${exist_data} 2> /dev/null || true
			rm ${info_file} 2> /dev/null || true
			rm ${download_script_path} 2> /dev/null || true
	    exit 1
		else
			rm -rf ${tmp_location}
			rm -rf ${location}/${object}
			rm ${log}/${object}_$(date +%y%m%d%H%M).log 2> /dev/null || true
			rmdir ${download_path}/pure 2> /dev/null || true
			rmdir ${download_path}/tmp 2> /dev/null || true
			rmdir ${download_path}/log 2> /dev/null || true
			rmdir ${download_path} 2> /dev/null || true
	    exit 1

		fi
	}

trap trap_ctrlC SIGINT SIGTERM




#Abbreviation of File Names

full_catalog=${object}${choose_info}full_catalog_$(date +%y%m%d%H%M%S).txt
master_catalog=${object}${choose_info}master_catalog_$(date +%y%m%d%H%M%S).txt
download_script_path=${tmp_location}/${object}${choose_info}download_script_$(date +%y%m%d%H%M%S).sh
exist_data=${tmp_location}/${object}${choose_info}exist_data_$(date +%y%m%d%H%M%S).txt
obsid_file=${tmp_location}/${object}${choose_info}obsid_$(date +%y%m%d%H%M%S).txt
info_file=${tmp_location}/${object}${choose_info}info_$(date +%y%m%d%H%M%S).txt


#Section_3: Data downloading.
echo -e " \t\t\tEntered Information"
echo -e "--------------------------------------------------------------------------"
echo -e "Object name \t  : \t${object_name}"
if [ -z "$mjd" ]; then
echo -e "Date Range \t  : \tAll Time" ; else
echo -e "Date Range \t  : \t${mjd}" ; fi
if [ -z ${limit} ]; then
echo -e "Limit \t\t  : \tLimitless" ; else
echo -e "Limit \t\t  : \t${limit}" ; fi
echo -e "Download Location : \t${download_path}"
echo -e "Satellite \t  : \t${satellite}"
echo -e "--------------------------------------------------------------------------\n"
read -ep "Continue? (y / n) : " ask
echo ""

if [[ "$(echo "$ask" | tr '[:upper:]' '[:lower:]')" == "y" ]] || [[ "$(echo "$ask" | tr '[:upper:]' '[:lower:]')" == "yes" ]] ;
then

	if [[ $satellite == "rxte" ]]; then

		source "$source_path"catalog_rxte.sh

	elif [[ $satellite == "xmm-newton" ]]; then
		source "$source_path"catalog_xmm_newton.sh
	elif [[ $satellite == "swift" ]]; then
		source "$source_path"catalog_swift.sh	
	fi


else
	rm -rf ${tmp_location}
	rm -rf ${save_location}
exit 1
fi

#Section_4: Createing a new txt file with downloaded data.



if [[ $satellite == "rxte" ]] || [[ $satellite == "xmm-newton" ]]; then
	cut -d '|' -f 2 ${tmp_location}/$master_catalog > ${tmp_location}/${object}${choose_info}all_obsid.txt
elif [[ $satellite == "swift" ]]; then
	cut -d '|' -f 3 ${tmp_location}/$master_catalog > ${tmp_location}/${object}${choose_info}all_obsid.txt

fi


sed '/^[[:space:]]*$/d' ${tmp_location}/${object}${choose_info}all_obsid.txt > ${obsid_file}
sed -i '/obsid/d' ${obsid_file}
sed -i '1s/^/obsid\n/' ${obsid_file}
rm ${tmp_location}/${object}${choose_info}all_obsid.txt


	#functions about caunter data.
	master_line=$(cat ${tmp_location}/${master_catalog} | tail -n +2 | wc -l)
	exist_line=$(cat ${obsid_file} | tail -n +2 | wc -l)
	no_url=$((master_line - exist_line))


#all_obsid ile obsid_file karşılaştırılması yapılacak

if [[ "$(echo "$check_source")" == "ok" ]]; then

	
	comm -13 <(sort ${all_obsid}) <(sort ${obsid_file}) > ${tmp_location}/new_obsid.txt

	obsid_num=$(wc -l ${tmp_location}/new_obsid.txt | awk '{print $1}')
	checked_and_down=$(wc -l ${all_obsid} | awk '{print $1}')
	checked_and_down=$((checked_and_down-1))
	rm ${all_obsid}

	if [ $obsid_num -ge 1 ]; then


		echo -e "\n--------------------------------------------------------------------------"
		echo -e "\nNOTE : Some of the data to be downloaded is available on the server and some \nobservations have been checked beforehand."
		echo -e "\n--------------------------------------------------------------------------"
		echo -e "Checked and downloaded observations \t  : \t${checked_and_down}"
		echo -e "Observation available for download \t  : \t${obsid_num}"
		echo -e "--------------------------------------------------------------------------\n"

		sed '/^[[:space:]]*$/d' ${tmp_location}/new_obsid.txt > ${obsid_file}
		sort -V -o ${obsid_file} ${obsid_file}
		sed -i '1s/^/obsid\n/' ${obsid_file}
		rm ${tmp_location}/new_obsid.txt


	else


		echo -e "\n--------------------------------------------------------------------------"
		echo -e "NOTE : The observations within the entered limit have been checked beforehand\n and the appropriate ones have been downloaded to the server."
		echo -e "--------------------------------------------------------------------------\n"
		rm ${obsid_file}
		rm ${tmp_location}/${full_catalog}
		rm ${tmp_location}/${master_catalog}
		rm ${tmp_location}/new_obsid.txt
		sleep 1
		exit 1


	fi


fi



datanumber=$(wc -l ${obsid_file} | awk '{print $1}')
noheader=$((datanumber-1))

#select down_script_satellite


if [[ $satellite == "rxte" ]]; then
	source "$source_path"down_script_rxte.sh
elif [[ $satellite == "xmm-newton" ]]; then
	source "$source_path"down_script_xmm_newton.sh

elif [[ $satellite == "swift" ]]; then
	source "$source_path"down_script_swift.sh	
fi


#statistics




#Creating Log file
echo -e "Source Name\t:${object}" > "${log}/${object}_$(date +%y%m%d%H%M%S).log"
echo -e "User\t\t:$(whoami)" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log"
echo -e "Down Start Date\t:$(date '+%Y/%m/%d %H:%M:%S')" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log"

if [ -z "$mjd" ]; then
echo -e "Date Range\t:All Time" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log" ; else
echo -e "Date Range\t:${mjd}" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log" ; fi

if [ -z "$limit" ]; then
echo -e "Limit\t\t:Limitless" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log" ; else
echo -e "Limit\t\t:${limit}" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log" ; fi

echo -e "Pointing Data\t:${number_exist}" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log"
echo -e "Not Pointing Data:${number_not_ex}" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log"
echo -e "Satellite \t:${satellite}" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log"

if [ -z "$limit" ]; then
echo -e "Data Count\t:${count_data}" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log" ; else
echo -e "Data Count\t:${limit}" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log" ; fi

echo -e "Down Script Path:${tmp_location}/${object}${choose_info}download_script.sh" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log"
echo -e "Source Path\t:${save_location}" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log"
echo -e "Info Path\t:${tmp_location}" >> "${log}/${object}_$(date +%y%m%d%H%M%S).log"

#staring download script.
echo -e "--------------------------------------------------------------------------"
echo -e "\nData downloading...\n"

ex_data=$(wc -l ${exist_data} | awk '{print $1}')
sed -i 's/ex_data/'${ex_data}'/g' ${download_script_path}

bash ${download_script_path} #download Starting.


