#!/bin/bash

if [ ! -d "${DOWNLOADPATH}" ]; then
	echo "Creating Download folder."
	mkdir -p "${DOWNLOADPATH}"
fi

if [ ! -d "${COREPATH}" ]; then
	echo "Creating Core folder."
	mkdir -p "${COREPATH}"
fi

if [ ! -f "${COREPATH}"/aniGamerPlus.py ]; then
	echo "Does not find aniGamerPlus. Download from git."
	rm -rf "${COREPATH}"/* # Remove all contents to prevent git failure.
	mkdir -p "${COREPATH}"
	git clone https://github.com/miyouzi/aniGamerPlus.git "${COREPATH}"
fi

chmod -R 777 "${COREPATH}"
chmod -R 777 "${DOWNLOADPATH}"

echo ""
echo "Check for git updates."
cd "${COREPATH}"
git pull https://github.com/miyouzi/aniGamerPlus.git
echo ""

# Set a default value from the original json
if [[ -z "${UA}" || "${UA}" = "Should_be_the_same_as_your_browser" ]]; then
		echo ""
		echo "=================================================================="
		echo "  You didn't provide -v UA=xxx while run docker or doesn't change"
		echo "  Default value from dockerhub. Using default value for UserAgent."
		echo "  UA should be the same browser that the COOKIE is created."
		echo "=================================================================="
		echo ""
		UA="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.96 Safari/537.36"
fi


# Fill the cookie however. If the cookie exists do nothing.
if [ ! -f "${COREPATH}"/cookie.txt ]; then
	if [[ -z "${COOKIE}" || "${COOKIE}" = "Fill_it_here_or_change_cookie.txt_later" ]]; then
		echo ""
		echo "=================================================================="
		echo "  You didn't provide -v COOKIE=xxx while run docker."
		echo "  Creating cookie.txt and you can add contents later."
		echo "  A cookie is required for high resolutions and limited contents."
		echo "=================================================================="
		echo ""
	else
		echo "${COOKIE}" >> "${COREPATH}"/cookie.txt
	fi
fi

# Create a base config file. And alter the path according to the
# container volume defines.

if [ ! -f "${COREPATH}"/config.json ]; then
	echo "  Replacing the config file for UA and bangumi_dir."
	cp "${COREPATH}"/config-sample.json "${COREPATH}"/config.json
	sed -i -E 's|"ua": "(.*)",|"ua": "'"${UA}"'",|g' "${COREPATH}"/config.json
	sed -i -E 's|"bangumi_dir": "(.*)",|"bangumi_dir": "'"${DOWNLOADPATH}"'",|g' "${COREPATH}"/config.json
fi

echo ""
echo "=================================================================="
echo "  aniGamer docker is running."
echo "=================================================================="
echo ""

export PYTHONIOENCODING=utf-8

python3 "${COREPATH}"/aniGamerPlus.py
