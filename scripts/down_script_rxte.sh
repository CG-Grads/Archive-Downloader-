#!/bin/bash

for obsid_name in ${obsid_file}
do
	data=$(cat "${obsid_name}" | wc -l)

	echo -e "\n--------------------------------------------------------------------------"
    echo -e "Object name \t: \t${object} "
	echo -e "Number of Data \t: \t${noheader}"
	echo -e "--------------------------------------------------------------------------\n"
	echo -e "Pointing Data Checking...\n"
	echo "echo -e '#Obsid \t\t\tDown_start_date \tDown_start_time \tDown_duration (s) \tDown_file_size (Mb) \tNumber_of_file \tDownload_speed (Mb/s)' > ${info_file}" >> ${download_script_path}
	echo "" >> ${download_script_path}


  for obs_row in $(seq 2 $data) #i; obs indice
	do


  		obsid_first=$(sed -n "${obs_row}"p "${obsid_name}" | cut -d '-' -f 1)
  		obsid_full=$(sed -n "${obs_row}"p "${obsid_name}")
  		obsid_a=$(sed -n "${obs_row}"p "${obsid_name}" | cut -b 1)
  		obsid_d=$(sed -n "${obs_row}"p "${obsid_name}" | cut -b 2)
 	  	obsid_g=$(sed -n "${obs_row}"p "${obsid_name}" | cut -b 1-2)



  		if [ ${obsid_g} -ge 91 ]; then

    			num=$((obsid_d-1))
					url1="https://heasarc.gsfc.nasa.gov/FTP/xte/data/archive/AO1${num}//P${obsid_first}/${obsid_full}/."

					if wget ${url1} >/dev/null 2>&1 ; then
						count_data=$((data-1))
						num_obs=$((obs_row-1))
						echo -e "${num_obs} / ${count_data}  \tObsid :  ${obsid_full} \tPointing Data"
						echo "${obsid_full}" >> ${exist_data}
						rm index*

						number_exist=$((number_exist+1))

						echo 'echo -e "'${number_exist}' / ex_data\t\t'${object}'\t'${obsid_full}'\tDownloading..."' >> ${download_script_path}
	  					echo "obsid=${obsid_full}" >> ${download_script_path}
						echo 'year=$(date "+%Y-%m-%d %H:%M:%S" | cut -d\  -f 1)' >> ${download_script_path}
						echo 'time=$(date "+%Y-%m-%d %H:%M:%S" | cut -d\  -f 2)' >> ${download_script_path}
	    				echo 'start=$(date +%s)' >> ${download_script_path}

	    				
	    				
	    				echo "wget -q -nH --no-check-certificate --cut-dirs=5 -r -l0 -c -N -np -R 'index*' -erobots=off --retr-symlinks https://heasarc.gsfc.nasa.gov/FTP/xte/data/archive/AO1${num}//P${obsid_first}/${obsid_full}/. -P ${save_location}/${obsid_full}_downloading" >> ${download_script_path}
	   					
						echo 'cp -r '${save_location}/${obsid_full}'_downloading/* '${save_location}'' >> ${download_script_path}
						echo 'rm -rf '${save_location}/${obsid_full}'_downloading' >> ${download_script_path}		   					

	   					echo 'end=$(date +%s)' >> ${download_script_path}
	    				echo 'runtime=$((end-start))' >> ${download_script_path}
	    				echo 'size=$(du -ch '$save_location'/P'$obsid_first'/'$obsid_full'/ | tail -1 | cut -f1)' >> ${download_script_path}
						echo 'download_mb=$(echo $size | tr -d M\")' >> ${download_script_path}
						echo 'download_speed=$(awk "BEGIN {print ($download_mb)/($runtime)}")' >> ${download_script_path}
	    				echo 'nof=$(ls '$save_location'/P'$obsid_first'/'$obsid_full'/ | wc -l)' >> ${download_script_path}
						echo 'nof_2=$(ls '$save_location'/P'$obsid_first'/'$obsid_full'/* | wc -l)' >> ${download_script_path}
						
						#statistics
						echo 'old_runtime=$(cut -d ";" -f 2 '${tmp}/.stat')' >> ${download_script_path}
						echo 'new_runtime=$((old_runtime+runtime))' >> ${download_script_path}
						echo 'sed -i "s/;$old_runtime/;$new_runtime/g" '${tmp}/.stat'' >> ${download_script_path}
						#statistics

						echo_line='echo -e "${obsid} \t\t${year} \t\t${time} \t\t${runtime} \t\t\t${download_mb} \t\t\t${nof}/${nof_2} \t\t${download_speed}" >> '${info_file}''
	  					
	  					
						


						echo $echo_line >> ${download_script_path}

					else
						count_data=$((data-1))
						num_obs=$((obs_row-1))
						echo -e "${num_obs} / ${count_data}  \tObsid :  ${obsid_full} \tNot Pointing Data"
						number_not_ex=$((number_not_ex+1))

    			fi

  		elif [ ${obsid_g} == 90 ]; then

					url2="https://heasarc.gsfc.nasa.gov/FTP/xte/data/archive/AO9//P${obsid_first}/${obsid_full}/."

					if wget ${url2} >/dev/null 2>&1 ; then
						count_data=$((data-1))
						num_obs=$((obs_row-1))
						echo -e "${num_obs} / ${count_data}  \tObsid :  ${obsid_full} \tPointing Data"
						echo "${obsid_full}" >> ${exist_data}
						rm index*

						number_exist=$((number_exist+1))

						echo 'echo -e "'${number_exist}' / ex_data\t\t'${object}'\t'${obsid_full}'\tDownloading..."' >> ${download_script_path}

  						echo "obsid=${obsid_full}" >> ${download_script_path}
						echo 'date=$(date "+%Y-%m-%d %H:%M:%S")' >> ${download_script_path}
						echo 'year=$(date "+%Y-%m-%d %H:%M:%S" | cut -d\  -f 1)' >> ${download_script_path}
						echo 'time=$(date "+%Y-%m-%d %H:%M:%S" | cut -d\  -f 2)' >> ${download_script_path}
	    				echo "wget -q -nH --no-check-certificate --cut-dirs=5 -r -l0 -c -N -np -R 'index*' -erobots=off --retr-symlinks https://heasarc.gsfc.nasa.gov/FTP/xte/data/archive/AO9//P$obsid_first/$obsid_full/. -P ${save_location}/${obsid_full}_downloading" >> ${download_script_path}
						echo 'cp -r '${save_location}/${obsid_full}'_downloading/* '${save_location}'' >> ${download_script_path}
						echo 'rm -rf '${save_location}/${obsid_full}'_downloading' >> ${download_script_path}	   					
						echo 'end=$(date +%s)' >> ${download_script_path}
	    				echo 'runtime=$((end-start))' >> ${download_script_path}
	    				echo 'size=$(du -ch '$save_location'/P'$obsid_first'/'$obsid_full'/ | tail -1 | cut -f1)' >> ${download_script_path}
						echo 'download_mb=$(echo $size | tr -d M\")' >> ${download_script_path}
						echo 'download_speed=$(awk "BEGIN {print ($download_mb)/($runtime)}")' >> ${download_script_path}
    					echo 'nof=$(ls '$save_location'/P'$obsid_first'/'$obsid_full'/ | wc -l)' >> ${download_script_path}
						echo 'nof_2=$(ls '$save_location'/P'$obsid_first'/'$obsid_full'/* | wc -l)' >> ${download_script_path}
						
						#statistics
						echo 'old_runtime=$(cut -d ";" -f 2 '${tmp}/.stat')' >> ${download_script_path}
						echo 'new_runtime=$((old_runtime+runtime))' >> ${download_script_path}
						echo 'sed -i "s/;$old_runtime/;$new_runtime/g" '${tmp}/.stat'' >> ${download_script_path}
						#statistics

						echo_line='echo -e "${obsid} \t\t${year} \t\t${time} \t\t${runtime} \t\t\t${download_mb} \t\t\t${nof}/${nof_2} \t\t${download_speed}" >> '${info_file}''

						echo $echo_line >> ${download_script_path}
						echo "" >> ${download_script_path}




					else
						count_data=$((data-1))
						num_obs=$((obs_row-1))
						echo -e "${num_obs} / ${count_data}  \tObsid :  ${obsid_full} \tNot Pointing Data"
						number_not_ex=$((number_not_ex+1))
   		 		fi

  		else
    			url3="https://heasarc.gsfc.nasa.gov/FTP/xte/data/archive/AO${obsid_a}//P${obsid_first}/${obsid_full}/."
  				if wget $url3 >/dev/null 2>&1 ; then
						count_data=$((data-1))
						num_obs=$((obs_row-1))
						echo -e "${num_obs} / ${count_data}  \tObsid :  ${obsid_full} \tPointing Data"
						echo "${obsid_full}" >> ${exist_data}
						rm index*
						number_exist=$((number_exist+1))

						echo 'echo -e "'${number_exist}' / ex_data\t\t'${object}'\t'${obsid_full}'\tDownloading..."' >> ${download_script_path}
  						echo "obsid=${obsid_full}" >> ${download_script_path}
						echo 'year=$(date "+%Y-%m-%d %H:%M:%S" | cut -d\  -f 1)' >> ${download_script_path}
						echo 'time=$(date "+%Y-%m-%d %H:%M:%S" | cut -d\  -f 2)' >> ${download_script_path}
	    				echo 'start=$(date +%s)' >> ${download_script_path}
	    				echo "wget -q -nH --no-check-certificate --cut-dirs=5 -r -l0 -c -N -np -R 'index*' -erobots=off --retr-symlinks https://heasarc.gsfc.nasa.gov/FTP/xte/data/archive/AO${obsid_a}//P${obsid_first}/${obsid_full}/. -P ${save_location}/${obsid_full}_downloading" >> ${download_script_path}
	   					echo 'cp -r '${save_location}/${obsid_full}'_downloading/* '${save_location}'' >> ${download_script_path}
						echo 'rm -rf '${save_location}/${obsid_full}'_downloading' >> ${download_script_path}	
	   					echo 'end=$(date +%s)' >> ${download_script_path}
	    				echo 'runtime=$((end-start))' >> ${download_script_path}
	    				echo 'size=$(du -ch '$save_location'/P'$obsid_first'/'$obsid_full'/ | tail -1 | cut -f1)' >> ${download_script_path}
						echo 'download_mb=$(echo $size | tr -d M\")' >> ${download_script_path}
						echo 'download_speed=$(awk "BEGIN {print ($download_mb)/($runtime)}")' >> ${download_script_path}
    					echo 'nof=$(ls '$save_location'/P'$obsid_first'/'$obsid_full'/ | wc -l)' >> ${download_script_path}
						echo 'nof_2=$(ls '$save_location'/P'$obsid_first'/'$obsid_full'/* | wc -l)' >> ${download_script_path}
						
						
						#statistics
						echo 'old_runtime=$(cut -d ";" -f 2 '${tmp}/.stat')' >> ${download_script_path}
						echo 'new_runtime=$((old_runtime+runtime))' >> ${download_script_path}
						echo 'sed -i "s/;$old_runtime/;$new_runtime/g" '${tmp}/.stat'' >> ${download_script_path}
						#statistics


						echo_line='echo -e "${obsid} \t\t${year} \t\t${time} \t\t${runtime} \t\t\t${download_mb} \t\t\t${nof}/${nof_2} \t\t${download_speed}" >> '${info_file}''


						echo $echo_line >> ${download_script_path}
						echo "" >> ${download_script_path}

			 		else
			    	count_data=$((data-1))
						num_obs=$((obs_row-1))
						echo -e "${num_obs} / ${count_data}  \tObsid :  ${obsid_full} \tNot Pointing Data"
						number_not_ex=$((number_not_ex+1))

					fi
  		fi

	done #i



	#statistics

	cp ${tmp_location}/${master_catalog} ${tmp}/back_master.txt

			if [[ -f "${tmp}/not_exist.txt" ]];then

			for obsid_name in ${tmp}/not_exist.txt
				do
					data=$(cat "${obsid_name}" | wc -l)

				  for obs_row in $(seq 1 $data) #i; obs indice
					do
						
	  					obsid_full=$(sed -n "${obs_row}"p "${obsid_name}")

	  					sed -i "/${obsid_full}/d" ${tmp}/back_master.txt

					done #i
				done

			rm ${tmp}/not_exist.txt

			fi

			if [[ -f "${all_obsid}" ]];then	

			for obsid_name in ${all_obsid}
				do
					data=$(cat "${obsid_name}" | wc -l)

				  for obs_row in $(seq 1 $data) #i; obs indice
					do
						
	  					obsid_full=$(sed -n "${obs_row}"p "${obsid_name}")

	  					sed -i "/${obsid_full}/d" ${tmp}/back_master.txt

					done #i
				done

			rm ${all_obsid}

			fi

	


	cut -d '|' -f 11 ${tmp_location}/${master_catalog} > ${tmp}/tmp_stat.txt


	sed -i '/duration/d' ${tmp}/tmp_stat.txt
	sed -i '/^[[:space:]]*$/d' ${tmp}/tmp_stat.txt
	new_duration=$(paste -sd+ ${tmp}/tmp_stat.txt | bc)


	if [[ -f "${tmp}/.stat" ]];then
		total_time=$(cut -d ";" -f 2 ${tmp}/.stat)
		old_duration=$(cut -d ";" -f 1 ${tmp}/.stat)
		download_time=$(((total_time*new_duration)/old_duration))
		download_time=$(date -d@${download_time} -u +%H:%M:%S)

		new_total_duration=$((old_duration+new_duration))
		sed -i "s/$old_duration/$new_total_duration/g" ${tmp}/.stat

	else
		echo -n ${new_duration} >> ${tmp}/.stat
		echo -n ";0" >> ${tmp}/.stat
	fi



	rm ${tmp}/tmp_stat.txt
	rm ${tmp}/back_master.txt
	

	#statistics


	if [ -z ${number_exist} ] ; then
		echo -e "\n--------------------------------------------------------------------------"
		echo -e "${object} : Warning ! There is no pointing data!"
		echo -e "--------------------------------------------------------------------------\n"

		if [[ "$(echo "$check_source")" == "ok" ]]; then

			rm ${download_script_path}
			rm ${tmp_location}/${master_catalog}
			rm ${tmp_location}/${full_catalog}
			rm ${obsid_file}

		else
			rm -rf ${save_location}
			rm -rf ${tmp_location}
		fi

		
		exit 1
	elif [ -z ${limit} ] ; then
		echo -e "\n--------------------------------------------------------------------------"
		echo -e "Pointing Data \t\t\t: ${number_exist} "
		echo -e "Off Pointing Data \t\t: ${number_not_ex}"
		if [[ "$(echo "$total_time")" -ne "0" ]]; then
		echo -e "Approximate Download Time \t: ${download_time}"
		fi
	else
	  	echo -e "\n--------------------------------------------------------------------------"
		echo -e "Pointing Data \t\t\t: ${number_exist}"
		echo -e "Off Pointing Data \t\t: ${number_not_ex}"
		echo -e "Empty Data \t\t\t: ${no_url}"
		echo -e "Download Limit \t\t\t: ${limit}"
		if [[ "$(echo "$total_time")" -ne "0" ]]; then
		echo -e "Approximate Download Time \t: ${download_time}"
		fi
	fi

done
