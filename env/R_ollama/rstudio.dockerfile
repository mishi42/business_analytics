FROM rocker/tidyverse
USER root

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
    mecab libmecab-dev mecab-ipadic \
    # mecab-ipadic-utf8 \
    #libpng-dev libjpeg-dev libfreetype6-dev libglu1-mesa-dev libgl1-mesa-dev \
    #zlib1g-dev libicu-dev libgdal-dev gdal-bin libgeos-dev libproj-dev \
    libboost-filesystem-dev \
    sudo htop gnupg openssh-client curl wget texlive-xetex texlive-latex-base iputils-ping
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
RUN R -q -e 'extrafont::font_import(prompt = FALSE); \
             install.packages("devtools"); \
             install.packages("pak");'

#RUN R -q -e 'devtools::install_github("lchiffon/wordcloud2")'
RUN R -q -e 'install.packages("RMeCab", repos = "https://rmecab.jp/R"); \
             #remotes::install_github("m-clark/mixedup"); \
             #remotes::install_github("nx10/httpgd"); \
             #devtools::install_github("ebenmichael/augsynth"); \
             pak::pak("mlverse/lang");'
             #devtools::install_github("frankiethull/kuzco"); \
             #devtools::install_github("AlbertRapp/tidychatmodels"); \
             #remotes::install_github("bgreenwell/statlingua"); \
             #remotes::install_github("anna-neufeld/treevalues");\
             #devtools::install_github("heurekalabsco/axolotr"); \
             #remotes::install_github("lawremi/wizrd") ;'
             #remotes::install_github("mlr-org/mlr3extralearners"); \
             #remotes::install_github("mlr-org/mlr3automl"); \
             #remotes::install_github("mlr-org/mlr3viz");' 

             #install.packages("reticulate"); \ 
             #reticulate::install_python(version = "3.12"); \
             #reticulate::virtualenv_create("r-reticulate"); \
             #reticulate::py_install("nevergrad", pip = TRUE); \


RUN install2.r --error --skipmissing --skipinstalled \
    checkpoint \
    pacman rmarkdown rticles knitr DT reactable \
    knitr kableExtra Hmisc quantreg reporttools NMOF papeR ztable xtable \
    sessioninfo quarto flextable htmlTable parameters pander  \
    htmlwidgets gt gtsummary renv stargazer huxtable bookdown markdown docxtractr testthat \
    excel.link XLConnect readxl openxlsx tinytex \
    dbplyr \
    DBI RODBC duckplyr arrow aws.s3 bigrquery RPostgreSQL duckdb redshift paws duckdbfs furrr \
    ggh4x \
    ggExtra lemon ggthemes hrbrthemes patchwork plotly ggfortify ggspatial naniar \
    colormap ggridges ggdist GGally ggstatsplot ggrepel dbplot ggmice \
    ggraph ggupset ggcorrplot lindia ggheatmap ggsurvfit ggstats ggwordcloud tidyterra \
    vcd vcdExtra viridis ggpubr ggsci survminer ggforce cowplot ggalt ggsignif \
    gplots modelbased rnaturalearth imager tesseract \
    flexdashboard \
    shiny shinydashboard bslib shinytest shinyFiles shinychat \
    tidylog \
    rstan rstanarm brms bayesplot bayestestR bayesAB BART MCMCpack tidybayes multilevelmod \
    tidyposterior dprng bartMachine broom.mixed rstantools shinystan projpred posterior \
    BMA loo \
    rvest RSelenium \
    corrplot \
    Rtsne psych dirichletprocess statmod embed DPpackage \
    modelsummary skimr catdap stacks bonsai glmnet vars rBaysianOptimization \
    tidymodels xgboost lightgbm ranger normtest lars nlme luz \
    mlr3 mlr3verse mlr3pipelines mlr3learners mlr3torch mlr3tuning mlr3summary \
    partykit rpart.plot earth DataExplorer BVAR finetune sem semTools \
    semPlot lavaan lme4 mclust doFuture parameters tidyrules aqua \
    fixest \
    AER lmtest clubSandwich sandwich dlm KFAS bsts marginaleffects BLPestimatoR rms plm \
    sampleSelection \
    CausalImpact rdd rdrobust rddensity RDHonest DoubleML \
    DALEX tidytreatment Amelia MatchIt grf fwildclusterboot survey rbounds \
    bnlearn pcalg censReg bartCause iml shapviz finalfit mice simputation Matching \
    imputeMissings Synth tidysynth gsynth panelView PanelMatch microsynth tidyhte rddapp \
    counterfactuals iml JointAI \
    Rdimtools \
    VBsparsePCA mlogit flexmix pscl arules arulesSequences arulesViz arulesCBA \
    conjoint bayesm invgamma recsys recommenderlab recosystem NMF nestedLogit apollo \
    tidytext \
    tm stringr stringi topicmodels lda LDAvis textmineR gutenbergr methods \
    quanteda widyr \
    tableone \
    latex2exp distill \
    equatiomatic ftExtra minidown \
    polite targets \
    cronR drat \
    OpenCL spatialsample \
    progress sen2r miniCRAN \
    languageserver here janitor \
    ellmer \
    chatLLM tidyllm ollamar rollama LLMAgentR chattr gander ragnar mall


##download.file(url = "https://github.com/tesseract-##ocr/tessdata/raw/4.00/jpn.traineddata",
##              destfile = paste0(TessRact$datapath, "/jpn.traineddata"))


RUN apt-get install -y libtesseract-dev libleptonica-dev tesseract-ocr-eng && \
    apt-get install -y tesseract-ocr-jpn 

RUN R -q -e 'tesseract::tesseract_download(lang = "jpn");'

#RUN echo 'options(.gander_chat = ellmer::chat_ollama(model = "gemma3:4b",base_url = "http://ollama:11434"))' > ~/.Rprofile && \
#         'options(.lang_chat = ellmer::chat_ollama(model = "gemma3:4b",base_url = "http://ollama:11434"))' >>  ~/.Rprofile  


#compose fileからのディレクトリの位置。フォルダはコピーされない
#COPY ./shell/ /work/env/

#WORKDIR /work/env/
#RUN sudo ./R_library.sh

#catdap2ext
#RUN mkdir /work/catdap
#WORKDIR /work/catdap

#RUN curl -OL https://jasp.ism.ac.jp/ism/catdap2ext/catdap2ext_0.2.0.zip && \
#    R -q -e 'install.packages("catdap2ext_0.2.0.tar.gz")'
