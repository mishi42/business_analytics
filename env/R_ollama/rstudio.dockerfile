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
    libboost-filesystem-dev \
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
    dlookr GWalkR explore DataExplorer modelsummary skimr dataMaid dlookr \
    flexdashboard \
    shiny shinydashboard bslib shinytest shinyFiles shinychat ERSA shinyPredict ShinyItemAnalysis shinyML \
    tidylog \
    rstan rstanarm brms bayesplot bayestestR bayesAB BART MCMCpack tidybayes multilevelmod R2BayesX dynamite dbarts \
    tidyposterior dprng bartMachine broom.mixed rstantools shinystan projpred posterior dapper cat bcf BMA loo \
    zipangu \
    jpmesh kuniezu \
    corrplot \
    Rtsne psych statmod embed XICOR \
    catdap stacks bonsai glmnet vars rBayesianOptimization modeltime \
    tidymodels xgboost lightgbm ranger normtest lars nlme luz Rserve kernlab prophet tidyquant torch isotree qcc fastDummies texreg rminer gtrendsR \
    mlr3 mlr3verse mlr3pipelines mlr3learners mlr3torch mlr3tuning mlr3summary \
    partykit rpart.plot earth BVAR finetune sem semTools tidyrules plumber slackr jsonlite tidycat vroom \
    semPlot lavaan lme4 mclust FactoMineR factoextra FactoInvestigate kohonen ggsom dirichletprocess BNPmix DPpackage BNPdensity Silhouette pricesensitivitymeter sjPlot \
    doFuture parameters agua h2o h2oEnsemble sparklyr rsparkling \ 
    copula evd extRemes bayescopulareg VineCopula mdgc mvnmle \
    fixest \
    AER lmtest clubSandwich sandwich dlm KFAS bsts marginaleffects BLPestimatoR rms plm marketr mfx DescTools tidyclust cluster \
    CLVTools bayesQR quantreg rqPen tvReg \
    sampleSelection \
    CausalImpact rdd rdrobust rddensity RDHonest DoubleML tools4uplift \
    clickstream \
    seqHMM superheat depmixS4 edeaR stagedtrees markovchain dtw ChannelAttribution completejourney \
    DALEX tidytreatment MatchIt grf fwildclusterboot survey rbounds randomForestExplainer fairmodels \
    bnlearn pcalg censReg bartCause iml shapviz finalfit BaylorEdPsych simputation Matching cobalt WeightIt pwr \
    mice \
    Amelia VIM missMDA missForest naniar miceadds MissMech missRanger JointAI \
    ssgraph huge BayesianGLasso BayesianLasso imputeMissings Synth tidysynth gsynth panelView PanelMatch microsynth tidyhte rddapp counterfactuals iml JointAI \
    Rdimtools \
    VBsparsePCA mlogit flexmix pscl arules arulesSequences arulesViz arulesCBA gmnl flexclust useful \
    conjoint bayesm invgamma recsys recommenderlab recosystem NMF nestedLogit apollo BDgraph ChoiceModelR rattle \
    tidytext \
    tm stringr stringi topicmodels lda LDAvis textmineR gutenbergr methods spacyr text GermaParl transport gsaot T4transport approxOT \
    sentencepiece tokenizers.bpe SnowballC stm tokenizers fastText \
    stopwords doc2vec word2vec udpipe Ruchardet quanteda widyr quanteda.textplots textclean syuzhet topicmodels.etm uwot textplot epitools \
    tableone \
    latex2exp distill equatiomatic ftExtra minidown \
    rvest \
    polite selenium targets wdman RSelenium \
    cronR drat OpenCL spatialsample \
    progress sen2r miniCRAN languageserver here janitor \
    ellmer \
    chatLLM tidyllm ollamar rollama LLMAgentR chattr gander ragnar mall mcptools emend tidyprompt

#python関連
RUN apt-get install -y 

RUN python3 -m venv /opt/reticulate
ENV RETICULATE_PYTHON=/opt/reticulate/bin/python
ENV PATH="/opt/reticulate/bin:${PATH}"

RUN /opt/reticulate/bin/pip install --upgrade pip && \
    /opt/reticulate/bin/pip install \
        Cython nevergrad numpy sentencepiece transformers scikit-learn
        #torch

#RUN /opt/reticulate/bin/pip install --no-build-isolation youtokentome 
# RUN R -q -e 'ragnar_find_links("https://r4ds.hadley.nz")'

RUN R -q -e 'reticulate::use_python("/opt/reticulate/bin/python", required = TRUE);\
             remotes::install_github("quanteda/quanteda.sentiment"); \
             devtools::install_github("quanteda/quanteda.tidy"); \
             pak::pak("quanteda/quanteda.llm"); \
             spacyr::spacy_install(lang_models = "ja_core_news_sm"); \
             devtools::install_github("theharmonylab/topics"); \
             devtools::install_github("theharmonylab/talk");'
             #talkrpp_install(prompt = FALSE); \
             #talkrpp_initialize(save_profile = TRUE); \
             #textrpp_install(prompt = FALSE); \
             #textrpp_initialize(save_profile = TRUE);
             #spacyr::spacy_download_langmodel("ja_core_news_sm")' 

RUN R -q -e 'rdevtools::install_github("farach/huggingfaceR"); \
             huggingfaceR::hf_python_depends(); \
             ' 

RUN mkdir /work/model_pretrained/
WORKDIR /work/model_pretrained/

RUN R -q -e 'sentencepiece::sentencepiece_download_model("Japanese", vocab_size = 200000,model = "/work/model_pretrained/")'

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
RUN sudo adduser user01 --disabled-password --gecos "" && \
    sudo echo user01:'user01' | /usr/sbin/chpasswd && \
    touch /home/user01/.mecabrc && \
    echo "dicdir = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd" > /home/user01/.mecabrc && \
    sudo adduser user02 --disabled-password --gecos "" && \
    sudo echo user02:'user02' | /usr/sbin/chpasswd && \
    touch /home/user02/.mecabrc && \
    echo "dicdir = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd" > /home/user02/.mecabrc && \
    sudo adduser user03 --disabled-password --gecos "" && \
    sudo echo user03:'user03' | /usr/sbin/chpasswd && \
    touch /home/user03/.mecabrc && \
    echo "dicdir = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd" > /home/user03/.mecabrc && \
    sudo adduser user04 --disabled-password --gecos "" && \
    sudo echo user04:'user04' | /usr/sbin/chpasswd && \
    touch /home/user04/.mecabrc && \
    echo "dicdir = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd" > /home/user04/.mecabrc && \
    sudo adduser user05 --disabled-password --gecos "" && \
    sudo echo user05:'user05' | /usr/sbin/chpasswd && \
    touch /home/user05/.mecabrc && \
    echo "dicdir = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd" > /home/user05/.mecabrc && \
    sudo adduser user06 --disabled-password --gecos "" && \
    sudo echo user06:'user06' | /usr/sbin/chpasswd && \
    touch /home/user06/.mecabrc && \
    echo "dicdir = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd" > /home/user06/.mecabrc && \
    sudo adduser user07 --disabled-password --gecos "" && \
    sudo echo user07:'user07' | /usr/sbin/chpasswd && \
    touch /home/user07/.mecabrc && \
    echo "dicdir = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd" > /home/user07/.mecabrc && \
    sudo adduser user08 --disabled-password --gecos "" && \
    sudo echo user08:'user08' | /usr/sbin/chpasswd && \
    touch /home/user08/.mecabrc && \
    echo "dicdir = /usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd" > /home/user08/.mecabrc

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
