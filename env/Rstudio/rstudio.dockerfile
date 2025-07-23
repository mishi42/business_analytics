FROM rocker/verse
#FROM rocker/mlverse
USER root

# https://zenn.dev/nononoexe/articles/recommendations-for-spatial-analysis-with-r

ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

RUN sed -i '$d' /etc/locale.gen \
    && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"

RUN /bin/bash -c "source /etc/default/locale"
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# 日本語フォントのインストール 
RUN apt-get update && \
    apt-get install -y \
    fonts-ipaexfont fonts-noto-cjk pandoc \
    mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8 \
    #libpng-dev libjpeg-dev libfreetype6-dev libglu1-mesa-dev libgl1-mesa-dev \
    #zlib1g-dev libicu-dev libgdal-dev gdal-bin libgeos-dev libproj-dev \
    libboost-filesystem-dev \
    sudo htop gnupg openssh-client curl wget texlive-xetex texlive-latex-base 
    # texlive-full

# DVC
RUN wget https://dvc.org/deb/dvc.list -O /etc/apt/sources.list.d/dvc.list && \
    wget -qO - https://dvc.org/deb/iterative.asc | apt-key add - && \
    apt update && \
    apt install -y dvc 


RUN mkdir /work && \
    mkdir /work/env/
#japanese font
RUN install2.r --error --skipmissing --skipinstalled extrafont remotes
RUN R -q -e 'extrafont::font_import(prompt = FALSE)'
RUN R -q -e 'install.packages("devtools")'
RUN R -q -e 'remotes::install_github("lchiffon/wordcloud2")'
RUN R -q -e 'install.packages("RMeCab", repos = "https://rmecab.jp/R") '
RUN R -q -e 'remotes::install_github("m-clark/mixedup")'
RUN R -q -e 'remotes::install_github("nx10/httpgd")'
RUN R -q -e 'install.packages("reticulate")'
RUN R -q -e 'reticulate::install_python(version = "3.12")'
RUN R -q -e 'reticulate::virtualenv_create("r-reticulate")'
RUN R -q -e 'reticulate::py_install("nevergrad", pip = TRUE)'

RUN R -q -e 'devtools::install_github("ebenmichael/augsynth")'


#compose fileからのディレクトリの位置。フォルダはコピーされない
COPY ./shell/ /work/env/

WORKDIR /work/env/
RUN sudo ./R_library.sh

#catdap2ext
#RUN mkdir /work/catdap
#WORKDIR /work/catdap

#RUN curl -OL https://jasp.ism.ac.jp/ism/catdap2ext/catdap2ext_0.2.0.zip && \
#    R -q -e 'install.packages("catdap2ext_0.2.0.tar.gz")'
