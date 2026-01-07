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
    fonts-ipaexfont fonts-noto-cjk pandoc libnotify-bin \
    mecab libmecab-dev mecab-ipadic mecab-ipadic-utf8 \
    libpoppler-cpp-dev libglpk40 libfftw3-dev libopencv-dev libtbb-dev libgsl0-dev \
    #libpng-dev libjpeg-dev libfreetype6-dev libglu1-mesa-dev libgl1-mesa-dev \
    #zlib1g-dev libicu-dev libgdal-dev gdal-bin libgeos-dev libproj-dev \
    libboost-filesystem-dev libudunits2-dev \
    sudo htop gnupg openssh-client curl wget texlive-xetex texlive-latex-base iputils-ping patch git build-essential

RUN apt-get install -y python3 python3-venv python3-dev python3-pip
    # texlive-full

# DVC
RUN wget https://dvc.org/deb/dvc.list -O /etc/apt/sources.list.d/dvc.list && \
    wget -qO - https://dvc.org/deb/iterative.asc | apt-key add - && \
    apt update && \
    apt install -y dvc 

RUN mkdir /work && \
    mkdir /work/env/
#japanese font
RUN install2.r --error --skipmissing --skipinstalled extrafont remotes showtext sysfonts tinytex BiocManager
#RUN R -q -e 'extrafont::font_import(prompt = FALSE); \
RUN R -q -e 'install.packages("devtools"); \
             install.packages("pak"); \ 
             tinytex::install_tinytex(force = T); '
             #sysfonts::font_add("noto", "NotoSansCJKjp-Regular.otf");  \

#RUN R -q -e ''
RUN R -q -e 'install.packages("RMeCab", repos = "https://rmecab.jp/R"); \
             #remotes::install_github("m-clark/mixedup"); \
             #remotes::install_github("nx10/httpgd"); \
             install.packages("https://cran.r-project.org/src/contrib/Archive/notifier/notifier_1.0.0.tar.gz"); \
             devtools::install_github("ebenmichael/augsynth"); \
             devtools::install_github("AlbertRapp/tidychatmodels"); \
             remotes::install_github("lawremi/wizrd"); \
             pak::pkg_install("devOpifex/mcpr"); \
             devtools::install_github("lchiffon/wordcloud2"); \
             remotes::install_github("uribo/jpndistrict"); \
             devtools::install_github("jacob-long/dpm"); \
             devtools::install_github("soerenkuenzel/causalToolbox"); \
             devtools::install_github("susanathey/causalTree"); \
             devtools::install_github("mlflow/mlflow", subdir = "mlflow/R/mlflow"); \
             devtools::install_github("davidsjoberg/ggsankey"); \
             devtools::install_github("GreenGrassBlueOcean/MattermostR"); \
             BiocManager::install("Rgraphviz"); \
             devtools::install_github("frankiethull/kuzco"); \
             pak::pak("mlverse/lang"); \
             install.packages("Robyn"); \
             install.packages("reticulate");' 
             #reticulate::install_python(version = "3.12"); \
             #reticulate::virtualenv_create("r-reticulate"); \
             #reticulate::py_install("nevergrad", pip = TRUE);'
             #devtools::install_github("frankiethull/kuzco"); \
             #remotes::install_github("bgreenwell/statlingua"); \
             #remotes::install_github("anna-neufeld/treevalues");\
             #devtools::install_github("heurekalabsco/axolotr"); \
             #remotes::install_github("lawremi/wizrd") ;'
             #remotes::install_github("mlr-org/mlr3extralearners"); \
             #remotes::install_github("mlr-org/mlr3automl"); \
             #remotes::install_github("mlr-org/mlr3viz");' 


#RUN  R -q -e 'data_server.py <- system.file("mcp", "data_server.py",package = "wizrd"); \
#              server <- start_mcp(data_server.py);'

RUN install2.r --error --skipmissing --skipinstalled \
    checkpoint \
    pacman rmarkdown rticles DT reactable \
    knitr kableExtra Hmisc reporttools NMOF papeR ztable xtable report \
    sessioninfo quarto flextable flexlsx htmlTable parameters pander \
    htmlwidgets htmltools gt gtsummary renv stargazer huxtable bookdown markdown docxtractr testthat \
    excel.link XLConnect readxl openxlsx Microsoft365R r2pptx officer officedown \
    dbplyr \
    DBI RODBC duckplyr arrow aws.s3 bigrquery RPostgreSQL duckdb redshift paws duckdbfs furrr odbc RMySQL \
    ggh4x \
    ggExtra lemon ggthemes hrbrthemes patchwork plotly ggfortify ggspatial janitor ggeffects ggdendro ggalluvial \
    colormap ggridges ggdist GGally ggstatsplot ggrepel dbplot ggmice rgl pdftools igraph qgraph jtools panelr interactions tidygraph \
    ggraph ggupset ggcorrplot lindia ggheatmap ggsurvfit ggstats ggwordcloud tidyterra networkD3 \
    vcd vcdExtra viridis ggpubr ggsci survminer ggforce cowplot ggalt ggsignif scatterplot3d lattice \
    gplots modelbased rnaturalearth imager tesseract magick opencv OpenImageR sketcher materialmodifier biopixR \
    summarytools \
    dlookr GWalkR explore DataExplorer modelsummary skimr dataMaid dlookr gmodels \
    flexdashboard \
    shiny shinydashboard bslib shinytest shinyFiles shinychat ERSA shinyPredict ShinyItemAnalysis shinyML shinyBS shinyjs \
    tidylog \
    rstan rstanarm brms bayesplot bayestestR bayesAB BART MCMCpack tidybayes multilevelmod R2BayesX dynamite dbarts \
    tidyposterior dprng bartMachine broom.mixed rstantools shinystan projpred posterior dapper cat bcf BMA loo \
    zipangu \
    jpmesh kuniezu \
    corrplot \
    Rtsne psych statmod embed XICOR \
    catdap stacks bonsai glmnet vars rBayesianOptimization modeltime lgcp \
    tidymodels xgboost lightgbm ranger normtest lars nlme luz Rserve kernlab prophet tidyquant torch isotree qcc fastDummies texreg rminer rattle shinymodels lime tidypredict plsmod \
    mlr3 mlr3verse mlr3pipelines mlr3learners mlr3torch mlr3tuning mlr3summary \
    partykit rpart.plot earth BVAR finetune sem semTools tidyrules plumber slackr jsonlite tidycat vroom \
    semPlot lavaan lme4 mclust FactoMineR factoextra FactoInvestigate kohonen ggsom dirichletprocess BNPmix DPpackage BNPdensity Silhouette pricesensitivitymeter sjPlot \
    doFuture parameters agua h2o h2oEnsemble sparklyr rsparkling \ 
    copula evd extRemes bayescopulareg VineCopula mdgc mvnmle \
    fixest \
    AER lmtest clubSandwich sandwich dlm KFAS bsts marginaleffects BLPestimatoR rms plm marketr mfx DescTools tidyclust cluster sjmisc here \
    CLVTools bayesQR quantreg rqPen tvReg \
    sampleSelection \
    CausalImpact rdd rdrobust rddensity RDHonest DoubleML tools4uplift \
    clickstream \
    seqHMM superheat depmixS4 edeaR stagedtrees markovchain dtw ChannelAttribution completejourney HMM HiddenMarkov dtwclust TSclust　funtimes pdc latrend tsfeatures otsfeatures kml kml3d momentuHMM MARSS mHMMbayes \
    networkDynamic \
    tsna dnr ndtv btergm graphicalVAR mlVAR psychonetrics \
    DALEX tidytreatment MatchIt grf fwildclusterboot survey rbounds randomForestExplainer fairmodels \
    bnlearn pcalg censReg bartCause iml shapviz finalfit BaylorEdPsych simputation Matching cobalt WeightIt pwr \
    mice \
    Amelia VIM missMDA missForest naniar miceadds MissMech missRanger JointAI \
    ssgraph huge BayesianGLasso BayesianLasso imputeMissings Synth tidysynth gsynth panelView PanelMatch microsynth tidyhte rddapp counterfactuals iml \
    Rdimtools \
    VBsparsePCA mlogit flexmix pscl arules arulesSequences arulesViz arulesCBA gmnl flexclust useful \
    conjoint bayesm invgamma recsys recommenderlab recosystem NMF nestedLogit apollo BDgraph ChoiceModelR \
    tidytext \
    tm stm stringr stringi topicmodels lda LDAvis textmineR gutenbergr methods spacyr text GermaParl transport gsaot T4transport approxOT \
    sentencepiece tokenizers.bpe SnowballC tokenizers fastText \
    stopwords doc2vec word2vec udpipe Ruchardet quanteda widyr quanteda.textplots textclean syuzhet topicmodels.etm uwot textplot epitools \
    tableone \
    latex2exp distill equatiomatic ftExtra minidown \
    rvest \
    polite selenium targets wdman RSelenium gtrendsR \
    cronR drat OpenCL spatialsample \
    progress sen2r miniCRAN languageserver here janitor \
    ellmer \
    chatLLM tidyllm ollamar rollama LLMAgentR chattr gander ragnar mall mcptools emend tidyprompt myownrobs vitals openai

#python関連
#RUN mkdir /opt/reticulate

#RUN R -q -e 'reticulate::install_miniconda(); \
#             reticulate::use_miniconda("/opt/reticulate"); \
#             reticulate::conda_create("reticulate_py313", "python=3.13"); \
#             reticulate::conda_install("reticulate_py313", \
#             c("spacy","Cython","nevergrad","numpy","sentencepiece","transformers","torch")); \
#             reticulate::use_condaenv("reticulate_py313", required = TRUE); \
#             '

RUN python3 -m venv /opt/reticulate
ENV RETICULATE_PYTHON=/opt/reticulate/bin/python
ENV PATH="/opt/reticulate/bin:${PATH}"

RUN R -q -e 'reticulate::use_python("/opt/reticulate/bin/python", required = TRUE);\
             reticulate::py_install( \
              packages = c("numpy", "spacy", "transformers", "torch","nevergrad","Cython","sentencepiece","scikit-learn"), \
              pip = TRUE \
             ); \
             '

#RUN /opt/reticulate/bin/pip install --upgrade pip && \
#    /opt/reticulate/bin/pip install --no-cache-dir \
#        Cython nevergrad numpy sentencepiece transformers scikit-learn spacy \
#        torch

##RUN /opt/reticulate/bin/pip install --no-build-isolation youtokentome 
# RUN R -q -e 'ragnar_find_links("https://r4ds.hadley.nz")'

RUN mkdir /work/model_pretrained/

#RUN R -q -e 'reticulate::use_python("/opt/reticulate/bin/python", required = TRUE)'
RUN R -q -e 'remotes::install_github("quanteda/quanteda.sentiment"); \
             devtools::install_github("quanteda/quanteda.tidy"); \
             pak::pak("quanteda/quanteda.llm"); \
             spacyr::spacy_install(lang_models = c("ja_core_news_trf","en_core_web_sm")); \
             devtools::install_github("theharmonylab/topics"); \
             devtools::install_github("theharmonylab/talk"); \
             sentencepiece::sentencepiece_download_model("Japanese", vocab_size = 200000,model = "/work/model_pretrained/"); \
             '
             
             #devtools::install_github("farach/huggingfaceR",upgrade = "never") ; \
             #huggingfaceR::hf_python_depends(); \
             #talkrpp_install(prompt = FALSE); \
             #talkrpp_initialize(save_profile = TRUE); \
             #textrpp_install(prompt = FALSE); \
             #textrpp_initialize(save_profile = TRUE);
             #spacyr::spacy_download_langmodel("ja_core_news_sm")' 


# NEologd
RUN mkdir /work/dic/
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git /work/dic/mecab-ipadic-neologd

RUN touch ~/.mecabrc && \
    echo "dicdir = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd" > ~/.mecabrc

##download.file(url = "https://github.com/tesseract-##ocr/tessdata/raw/4.00/jpn.traineddata",
##              destfile = paste0(TessRact$datapath, "/jpn.traineddata"))

RUN apt-get install -y libtesseract-dev libleptonica-dev tesseract-ocr-eng && \
    apt-get install -y tesseract-ocr-jpn 

RUN R -q -e 'tesseract::tesseract_download(lang = "jpn");'
#RUN R -q -e 'sparklyr::spark_install();'

#radiant
RUN R -q -e 'install.packages("radiant", repos = "https://radiant-rstats.github.io/minicran/"); \
             install.packages("radiant.update", repos = "https://radiant-rstats.github.io/minicran/")'

# add user
RUN for u in rstudio user01 user02 user03 user04 user05 user06 user07 user08; do \
        sudo adduser $u --disabled-password --gecos "" ; \
        sudo echo $u:"$u" | /usr/sbin/chpasswd ; \
        touch /home/$u/.mecabrc ; \
        echo "dicdir = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd" > /home/$u/.mecabrc ; \
    done

#RUN echo 'options(.gander_chat = ellmer::chat_ollama(model = "gemma3:4b",base_url = "http://ollama:11434"))' > ~/.Rprofile && \
#         'options(.lang_chat = ellmer::chat_ollama(model = "gemma3:4b",base_url = "http://ollama:11434"))' >>  ~/.Rprofile  

RUN mkdir /work/shiny/ && \
    mkdir /srv/shiny-server/

#WORKDIR /work/shiny/

#Shiny server
#RUN gdebi shiny-server-1.5.23.1030-x86_64.rpm && \
#    wget https://download3.rstudio.org/ubuntu-20.04/x86_64/shiny-server-1.5.23.1030-amd64.deb && \
#    gdebi -n shiny-server-1.5.23.1030-amd64.deb

RUN groupadd shiny_user && \
    for u in rstudio user01 user02 user03 user04 user05 user06 user07 user08; do \
        usermod -aG shiny_user "$u"; \
    done && \
    chown -R rstudio:shiny_user /srv/shiny-server/ && \
    chmod -R 2775 /srv/shiny-server/


#compose fileからのディレクトリの位置。フォルダはコピーされない
#COPY ./shell/ /work/env/

#WORKDIR /work/env/
#RUN sudo ./R_library.sh

#catdap2ext
RUN mkdir /work/catdap
WORKDIR /work/catdap

RUN curl -OL https://jasp.ism.ac.jp/ism/catdap2ext/catdap2ext_0.2.0.zip && \
    R -q -e 'install.packages("catdap2ext_0.2.0.tar.gz")'
