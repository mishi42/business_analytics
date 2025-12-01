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
    mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8 \
    libpoppler-cpp-dev libglpk40 libfftw3-dev libopencv-dev libtbb-dev libgsl0-dev \
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
RUN install2.r --error --skipmissing --skipinstalled extrafont remotes showtext sysfonts tinytex
#RUN R -q -e 'extrafont::font_import(prompt = FALSE); \
RUN R -q -e 'install.packages("devtools"); \
             install.packages("pak"); \ 
             tinytex::install_tinytex(force = T); '
             #sysfonts::font_add("noto", "NotoSansCJKjp-Regular.otf");  \

#RUN R -q -e ''
RUN R -q -e 'install.packages("RMeCab", repos = "https://rmecab.jp/R"); \
             #remotes::install_github("m-clark/mixedup"); \
             #remotes::install_github("nx10/httpgd"); \
             devtools::install_github("ebenmichael/augsynth"); \
             devtools::install_github("AlbertRapp/tidychatmodels"); \
             devtools::install_github("lchiffon/wordcloud2"); \
             remotes::install_github("uribo/jpndistrict"); \
             devtools::install_github("jacob-long/dpm"); \
             devtools::install_github("soerenkuenzel/causalToolbox"); \
             devtools::install_github("susanathey/causalTree"); \
             devtools::install_github("mlflow/mlflow", subdir = "mlflow/R/mlflow"); \
             pak::pak("mlverse/lang"); \
             install.packages("Robyn"); \
             install.packages("reticulate"); \ 
             reticulate::install_python(version = "3.12"); \
             reticulate::virtualenv_create("r-reticulate"); \
             reticulate::py_install("nevergrad", pip = TRUE);'
             #devtools::install_github("frankiethull/kuzco"); \
             #remotes::install_github("bgreenwell/statlingua"); \
             #remotes::install_github("anna-neufeld/treevalues");\
             #devtools::install_github("heurekalabsco/axolotr"); \
             #remotes::install_github("lawremi/wizrd") ;'
             #remotes::install_github("mlr-org/mlr3extralearners"); \
             #remotes::install_github("mlr-org/mlr3automl"); \
             #remotes::install_github("mlr-org/mlr3viz");' 



RUN install2.r --error --skipmissing --skipinstalled \
    checkpoint \
    pacman rmarkdown rticles DT reactable \
    knitr kableExtra Hmisc quantreg reporttools NMOF papeR ztable xtable report \
    sessioninfo quarto flextable htmlTable parameters pander \
    htmlwidgets gt gtsummary renv stargazer huxtable bookdown markdown docxtractr testthat \
    excel.link XLConnect readxl openxlsx Microsoft365R r2pptx officer officedown \
    dbplyr \
    DBI RODBC duckplyr arrow aws.s3 bigrquery RPostgreSQL duckdb redshift paws duckdbfs furrr odbc RMySQL \
    ggh4x \
    ggExtra lemon ggthemes hrbrthemes patchwork plotly ggfortify ggspatial naniar janitor ggeffects \
    colormap ggridges ggdist GGally ggstatsplot ggrepel dbplot ggmice GWalkR rgl pdftools igraph qgraph explore jtools panelr interactions \
    ggraph ggupset ggcorrplot lindia ggheatmap ggsurvfit ggstats ggwordcloud tidyterra \
    vcd vcdExtra viridis ggpubr ggsci survminer ggforce cowplot ggalt ggsignif scatterplot3d lattice \
    gplots modelbased rnaturalearth imager tesseract magick opencv OpenImageR sketcher materialmodifier biopixR \
    flexdashboard \
    shiny shinydashboard bslib shinytest shinyFiles shinychat ERSA shinyPredict ShinyItemAnalysis shinyML \
    tidylog \
    rstan rstanarm brms bayesplot bayestestR bayesAB BART MCMCpack tidybayes multilevelmod R2BayesX dynamite dbarts \
    tidyposterior dprng bartMachine broom.mixed rstantools shinystan projpred posterior dapper cat bcf BMA loo \
    zipangu \
    jpmesh kuniezu \
    rvest RSelenium selenium \
    corrplot \
    Rtsne psych dirichletprocess statmod embed DPpackage \
    modelsummary skimr catdap stacks bonsai glmnet vars rBayesianOptimization \
    tidymodels xgboost lightgbm ranger normtest lars nlme luz Rserve kernlab prophet tidyquant\
    mlr3 mlr3verse mlr3pipelines mlr3learners mlr3torch mlr3tuning mlr3summary \
    partykit rpart.plot earth DataExplorer BVAR finetune sem semTools tidyrules plumber slackr jsonlite tidycat \
    semPlot lavaan lme4 mclust FactoMineR factoextra FactoInvestigate \
    doFuture parameters agua h2o h2oEnsemble sparklyr rsparkling \    
    copula evd extRemes bayescopulareg VineCopula mdgc mvnmle \
    fixest \
    AER lmtest clubSandwich sandwich dlm KFAS bsts marginaleffects BLPestimatoR rms plm  marketr CLVTools \
    sampleSelection \
    CausalImpact rdd rdrobust rddensity RDHonest DoubleML tools4uplift \
    clickstream \
    seqHMM \
    DALEX tidytreatment Amelia MatchIt grf fwildclusterboot survey rbounds randomForestExplainer fairmodels \
    bnlearn pcalg censReg bartCause iml shapviz finalfit mice BaylorEdPsych simputation Matching cobalt WeightIt \
    ssgraph huge BayesianGLasso BayesianLasso imputeMissings Synth tidysynth gsynth panelView PanelMatch microsynth tidyhte rddapp counterfactuals iml JointAI \
    Rdimtools \
    VBsparsePCA mlogit flexmix pscl arules arulesSequences arulesViz arulesCBA gmnl \
    conjoint bayesm invgamma recsys recommenderlab recosystem NMF nestedLogit apollo BDgraph ChoiceModelR \
    tidytext \
    tm stringr stringi topicmodels lda LDAvis textmineR gutenbergr methods spacyr \
    quanteda widyr \
    tableone \
    latex2exp distill \
    equatiomatic ftExtra minidown \
    polite selenium targets wdman \
    cronR drat OpenCL spatialsample \
    progress sen2r miniCRAN languageserver here janitor \
    ellmer \
    chatLLM tidyllm ollamar rollama LLMAgentR chattr gander ragnar mall mcptools emend tidyprompt

# RUN R -q -e 'ragnar_find_links("https://r4ds.hadley.nz")'

RUN R -q -e 'remotes::install_github("quanteda/quanteda.sentiment"); \
             devtools::install_github("quanteda/quanteda.tidy"); \
             pak::pak("quanteda/quanteda.llm"); \
             spacyr::spacy_install(lang_models = "ja_core_news_sm");'
             #spacyr::spacy_download_langmodel("ja_core_news_sm")' 

##download.file(url = "https://github.com/tesseract-##ocr/tessdata/raw/4.00/jpn.traineddata",
##              destfile = paste0(TessRact$datapath, "/jpn.traineddata"))


RUN apt-get install -y libtesseract-dev libleptonica-dev tesseract-ocr-eng && \
    apt-get install -y tesseract-ocr-jpn 

RUN R -q -e 'tesseract::tesseract_download(lang = "jpn");'
RUN R -q -e 'sparklyr::spark_install();'


#radiant
RUN R -q -e 'install.packages("radiant", repos = "https://radiant-rstats.github.io/minicran/"); \
             install.packages("radiant.update", repos = "https://radiant-rstats.github.io/minicran/")'

# add user
RUN sudo adduser user01 --disabled-password --gecos "" && \
    sudo echo user01:'user01' | /usr/sbin/chpasswd && \
    sudo adduser user02 --disabled-password --gecos "" && \
    sudo echo user02:'user02' | /usr/sbin/chpasswd && \
    sudo adduser user03 --disabled-password --gecos "" && \
    sudo echo user03:'user03' | /usr/sbin/chpasswd && \
    sudo adduser user04 --disabled-password --gecos "" && \
    sudo echo user04:'user04' | /usr/sbin/chpasswd && \
    sudo adduser user05 --disabled-password --gecos "" && \
    sudo echo user05:'user05' | /usr/sbin/chpasswd && \
    sudo adduser user06 --disabled-password --gecos "" && \
    sudo echo user06:'user06' | /usr/sbin/chpasswd && \
    sudo adduser user07 --disabled-password --gecos "" && \
    sudo echo user07:'user07' | /usr/sbin/chpasswd && \
    sudo adduser user08 --disabled-password --gecos "" && \
    sudo echo user08:'user08' | /usr/sbin/chpasswd

#RUN echo 'options(.gander_chat = ellmer::chat_ollama(model = "gemma3:4b",base_url = "http://ollama:11434"))' > ~/.Rprofile && \
#         'options(.lang_chat = ellmer::chat_ollama(model = "gemma3:4b",base_url = "http://ollama:11434"))' >>  ~/.Rprofile  


#compose fileからのディレクトリの位置。フォルダはコピーされない
#COPY ./shell/ /work/env/

#WORKDIR /work/env/
#RUN sudo ./R_library.sh

#catdap2ext
RUN mkdir /work/catdap
WORKDIR /work/catdap

RUN curl -OL https://jasp.ism.ac.jp/ism/catdap2ext/catdap2ext_0.2.0.zip && \
    R -q -e 'install.packages("catdap2ext_0.2.0.tar.gz")'





