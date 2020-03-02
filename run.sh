#!/bin/bash

if [ ! -d "${DOWNLADPATH}" ]; then
	echo "Creating Download folder."
	mkdir -p "${DOWNLADPATH}"
fi

if [ ! -d "${COREPATH}" ]; then
	echo "Creating Core folder."
	mkdir -p "${COREPATH}"
fi

if [ ! -f "${COREPATH}"/aniGamerPlus.py ]; then
	echo "Does not find aniGamerPlus. Download from git."
	git clone https://github.com/miyouzi/aniGamerPlus.git "${COREPATH}"
	chomod 664 *
fi

echo "Check for git updates."
cd "${COREPATH}"
git pull https://github.com/miyouzi/aniGamerPlus.git

# Set a default value from the original json
if [[ -z "${UA}" ]]; then
		echo "=================================================================="
		echo "  You didn't provide -v UA=xxx while run docker."
		echo "  Using default value for User Agent."
		echo "  UA should be the same browser that the COOKIE is created."
		echo "=================================================================="
		UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.96 Safari/537.36"
fi


# Fill the cookie however. If the cookie exists do nothing.
if [ ! -f "${COREPATH}"/cookie.txt ]; then
	if [[ -z "${COOOKIE}" ]]; then
		echo "=================================================================="
		echo "  You didn't provide -v COOKIE=xxx while run docker."
		echo "  Creating cookie.txt and you can add contents later."
		echo "  A cookie is required for high resolutions and limited contents."
		echo "=================================================================="
		touch "${COREPATH}"/cookie.txt
	else
		printf "${COOKIE}" >> "${COREPATH}"/cookie.txt
	fi
fi

# Create a base config file. And alter the path according to the
# container volume defines.

if [ ! -f "${COREPATH}"/config.json ]; then
	echo "Replacing the config file for UA and bangumi_dir."
	cp "${COREPATH}"/config-sample.json "${COREPATH}"/config.json
	sed -i -E 's|"ua": "(.*)",|"ua": "'"${UA}"'",|g' "${COREPATH}"/config.json
	sed -i -E 's|"bangumi_dir": "(.*)",|"bangumi_dir": "'"${DOWNLADPATH}"'",|g' "${COREPATH}"/config.json
fi

echo "=================================================================="
echo "  aniGamer docker is running."
echo "=================================================================="

export PYTHONIOENCODING=utf-8

python3 "${COREPATH}"/aniGamerPlus.py
