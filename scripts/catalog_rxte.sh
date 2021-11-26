#!/bin/bash

curl -d "Entry=$object_name&Observatory_xray1=$satellite&Time=$mjd&ResultMax=$limit&displaymode=PureTextDisplay&table_type=Observation&Coordinates=J2000" -H "Content-Type: application/x-www-form-urlencoded" -X POST https://heasarc.gsfc.nasa.gov/cgi-bin/W3Browse/w3table.pl > ${tmp_location}/$full_catalog

	error=$(grep -n "Error" ${tmp_location}/$full_catalog | head -n 1 | cut -d: -f1)
	if [ "$error" == "" ];then

		if ! grep -q heasarc_xtemaster ${tmp_location}/${full_catalog}; then
			echo -e "\n--------------------------------------------------------------------------"
			echo "ERROR! No matches for Master Catalog! "
			echo -e "--------------------------------------------------------------------------\n"
			rm -rf ${tmp_location}
			rm -rf ${save_location}
			exit 1
		fi
			awk '!NF{f=0} /Results from heasarc_xtemaster: XTE Master Catalog/ {f=1} f' ${tmp_location}/$full_catalog > ${tmp_location}/pass.txt
			sed '1,2d' ${tmp_location}/pass.txt > ${tmp_location}/$master_catalog
			awk 'NR == 1; NR > 1 {print $0 | "sort -n"}' ${tmp_location}/$master_catalog > ${tmp_location}/${master_catalog}_tmp.txt && mv ${tmp_location}/${master_catalog}_tmp.txt ${tmp_location}/$master_catalog
			rm ${tmp_location}/pass.txt

		
	else
			echo -e "\n--------------------------------------------------------------------------"
			echo "ERROR! The information entered is incorrect! Please be sure to write the information correctly."
			echo -e "--------------------------------------------------------------------------\n"
			rm -rf ${tmp_location}
			rm -rf ${save_location}
			exit 1
	fi