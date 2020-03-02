
# aniGamer-docker
Chinese should be provided later when the steps are verified working. No ETA for that anyway.

The aniGamer-docker is a containerized image for aniGamerPlus written by miyouzi. Its project page can be found here:
> https://github.com/miyouzi/aniGamerPlus

The purpose to create this docker is the provide an easier method to deploy aniGamerPlus on a NAS environment. The direct command-line download mode is not supported for the moment and does not have firm schedules, depending on the needs or the status of the updates from aniGamerPlus.
## Basic components
Base: ubuntu:18.04
Apt packages installed: locales git ffmpeg python3-pip
Pip packages installed: requests beautifulsoup4 lxml termcolor chardet pysocks

It is planned to use other bases to replace current ubuntu 18.04, but will need more time to perform tests to confirm if the environment is working. That is a low priority task.
Due to the nature of docker, the time inside is always UTC.

## Installation (General docker method)
Under a system which supports docker, run below commands at the CLI

    docker pull itemx/anigamer:latest
And the system should download it directly, which can be found at the local docker image repository.
Then execute the docker with below parameters

    docker run \
       --name aniGamer \
        -v /your/local/folder/config:/aniGamer/Core \
        -v /your/local/folder/downloaded:/aniGamer/Download \
        -e UA="YOUR_USER_AGENT" \
        -e COOKIE="YOUR_COOKIE" \
        -d \
        itemx/anigamer
        

### Parameters

 - `--name <NAME>` 
    The name of the running docker. This is for identification only.
    
 - `-v /your/local/folder/config:/aniGamer/Core` 
   The folder on the host. This folder will be used to store files pulled from [aniGamerPlus on GitHub](https://github.com/miyouzi/aniGamerPlus). The [configuration file](https://github.com/miyouzi/aniGamerPlus#configjson), and [download list](https://github.com/miyouzi/aniGamerPlus#sn_listtxt) will also stored here. Also, the temporary file during download will be created under this folder.
   
 - `-v /your/local/folder/downloaded:/aniGamer/Download`
   The folder is used to store the animations downloaded from the website.
   
**Note**:

**DO NOT** set these folders to the same folder. Otherwise, the execution result might be strange.

The above folders will be created automatically. And the permission will be set to 777 to prevent unexpected troubles.

 - `-e UA="YOUR_USER_AGENT"`
  The user agent from your browser. It should be the same as the browser that obtains the cookie. You can also replace the user agent from aniGamerPlus's [configuration file](https://github.com/miyouzi/aniGamerPlus#configjson) later.
  
 - `-e COOKIE="YOUR_COOKIE"`
  The initial cookie to be written in `cookie.txt `. You can change the content of the [cookie.txt](https://github.com/miyouzi/aniGamerPlus#cookietxt) after the folders are created.
  
 - `-d`
  To run this container in the background. 


## Installation (On a QNAP NAS UI)

Login the QNAP NAS via SSH and copy-paste the command in above is much faster than using the UI. Below step are still provided as reference.

**Note:**
 - Install Container Station is a must-have step before using CLI.
 - The visible folder (Shared folder) of the NAS is under the `/share/` folder. Remember to add it in front of the folder you know.
	- For example, if the content is planned to put at `/Public` then it should be `/share/Public` in the CLI.
	- Just select `/Public` when setting from Container Station UI.
 - On QNAP NAS, the docker is managed by "Container Station" and it can be installed from the NAS's AppCenter. [Check here for details](https://www.qnap.com/en/how-to/tutorial/article/how-to-use-container-station) on how to initiate the Container Station

 1. The Container Station will look like this. And you can "Create" a new one.
![ContainerStation UI](https://raw.githubusercontent.com/itemx/anigamer-docker/master/readme_pic/qn_container1.png)

 2. After pressing "Create," a list of available containers will appear. And it is already integrated with the docker hub. Simply search "itemx" or "anigamer" can locate this package for installation.
![Search "itemx/anigamer"](https://raw.githubusercontent.com/itemx/anigamer-docker/master/readme_pic/qn_container2.png)
Press "Install" will download the container to the local storage and creates a docker based on it.

 3. Adjust the resource limitation and then press Advanced settings![Create settings](https://raw.githubusercontent.com/itemx/anigamer-docker/master/readme_pic/qn_container3.png) 

 4. Change the UA and the COOKIE
 
 ![UA COOKIE settings](https://raw.githubusercontent.com/itemx/anigamer-docker/master/readme_pic/qn_container_install1.png)
 Press "Add" and create` UA` and `COOKIE` entries with the proper value.
 
 | Name | Value |
 |---|---|
 | COOKIE | The Cookie Value inspected from browser |
 | UA | The UserAgnet |

 The method to obtain a proper User-Agent of your browser and the COOKIE can be found at the document provided in aniGamerPlus. 

- [Find the COOKIE](https://github.com/miyouzi/aniGamerPlus#cookietxt)
- [Find the User Agent](https://github.com/miyouzi/aniGamerPlus#%E4%BD%BF%E7%94%A8chrome%E8%88%89%E4%BE%8B%E5%A6%82%E4%BD%95%E7%8D%B2%E5%8F%96-ua)
	- Or from here directly: https://developers.whatismybrowser.com/useragents/parse/?analyse-my-user-agent=yes

5. Switch to the `Shared Folders` tab. Add two Volume from the host.

![UA COOKIE settings](https://raw.githubusercontent.com/itemx/anigamer-docker/master/readme_pic/qn_container_install2.png)


| Volume from host | Mount Point |
|--|--|
| The shared folder you want to put core files. | /aniGamer/Core |
| The shared folder you want to put downloaded videos. | /aniGamer/Download |

  - Click on the grey textbox will pop up a path selector. Which lists the share folder trees on the NAS.
  - Be aware the mount point sample above is in **ONE LINE**.

6. After everything is set, press `Create` and then proceed. 

7. The docker image will be downloaded and enabled after the download finishes. 
![Docker list](https://raw.githubusercontent.com/itemx/anigamer-docker/master/readme_pic/qn_container_install4.png)
![Details](https://raw.githubusercontent.com/itemx/anigamer-docker/master/readme_pic/qn_container_install5.png)

If the output contains `aniGamer docker is running.` like above means it's ready to use. You can add animation id into `sn_list.txt` following [the instructions](https://github.com/miyouzi/aniGamerPlus#sn_listtxt).

## Installation (Other platforms)
The instructions for other platforms are not provided but should be similar to the guides provided in earlier sections.

It is appreciated to have platform guides for platforms other than above. Ping me if you have tested this docker on different places and the guides may update accordingly.

----
Last edit: Mar. 2nd, 2020