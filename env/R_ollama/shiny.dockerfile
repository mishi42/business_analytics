# Base R Shiny image
FROM rocker/shiny-verse

ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

RUN sed -i '$d' /etc/locale.gen \
    && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen ja_JP.UTF-8 \
    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"

RUN /bin/bash -c "source /etc/default/locale"
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Install R dependencies
RUN install2.r --error --skipmissing --skipinstalled \
               shinychat ellmer bslib plotly GWalkR ggplot2 shinydashboard shinyBS shinyjs querychat

# Expose the application port
EXPOSE 3838
