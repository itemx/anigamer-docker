FROM ubuntu:18.04

MAINTAINER Itemx Mizusaka <itemx@i3x.tw>

ENV COOKIE="Fill_it_here_or_change_cookie.txt_later"
ENV UA="Should_be_the_same_as_your_browser"
ENV ROOTPATH="/aniGamer"
ENV DOWNLADPATH=${ROOTPATH}"/Download"
ENV COREPATH=${ROOTPATH}"/Core"


RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install locales
RUN apt-get install -y git
RUN apt-get install -y ffmpeg
RUN apt-get install -y python3-pip
RUN pip3 install requests beautifulsoup4 lxml termcolor chardet pysocks

# Set the locale
RUN sed -i -e 's/# \(en_US\.UTF-8 .*\)/\1/' /etc/locale.gen 
RUN touch /usr/share/locale/locale.alias 
RUN locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8    

WORKDIR ${ROOTPATH}
COPY run.sh ${ROOTPATH}
RUN chmod +x run.sh

VOLUME [ ${DOWNLADPATH}, ${COREPATH} ]

CMD ["./run.sh"]
