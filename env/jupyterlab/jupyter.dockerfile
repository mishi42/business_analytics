FROM nvidia/cuda:12.2.0-base-ubuntu22.04

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV LANG ja_JP.UTF-8
ENV LC_ALL ja_JP.UTF-8

ARG env_name=py3_12_12
ARG ver_python=3.12.12

#RUN sed -i '$d' /etc/locale.gen \
#    && echo "ja_JP.UTF-8 UTF-8" >> /etc/locale.gen \
#    && locale-gen ja_JP.UTF-8 \
#    && /usr/sbin/update-locale LANG=ja_JP.UTF-8 LANGUAGE="ja_JP:ja"

# 必要そうなものをinstall
RUN apt-get update -y && \ 
    apt-get install -y --no-install-recommends wget build-essential libreadline-dev libgl1-mesa-dev \ 
        libncursesw5-dev libssl-dev libsqlite3-dev libgdbm-dev libbz2-dev liblzma-dev zlib1g-dev uuid-dev  \ 
        libffi-dev libdb-dev curl cmake make git libgl1-mesa-dev sudo wget vim htop curl 

# 任意バージョンのpython install
RUN wget --no-check-certificate https://www.python.org/ftp/python/"${ver_python}"/Python-"${ver_python}".tgz \
    && tar -xf Python-"${ver_python}".tgz \
    && cd Python-"${ver_python}" \
    && ./configure --enable-optimizations\
    && make \
    && make install

# サイズ削減のため不要なものは削除
RUN apt-get autoremove -y
RUN apt-get clean

RUN ln -s /usr/bin/"${ver_python}" /usr/bin/python

# install other library #############################################################
RUN pip3 install -U pip

RUN pip3 install -U --ignore-installed  \
        pandas setuptools numpy scipy scikit-learn \
        statsmodels seaborn pyarrow polars \
        pycaret lightgbm xgboost \
        pandas-profiling optuna imbalanced-learn mlxtend \
        #opencv-contrib-python pyocr catboost gluonts geopandas torchaudio torchvision signate kaggle \
        matplotlib japanize_matplotlib plotly seaborn
        

#personal
RUN pip3 install missingno boto3 s3fs xlrd xlwt \ 
                msoffcrypto-tool openpyxl google-cloud-bigquery beautifulsoup4 
                # selenium

#XAI
RUN pip3 install -U --ignore-installed \
        shap pydotplus graphviz skope-rules interpret-core witwidget alibi streamlit
    #lime eli5 skater

#torch
RUN pip3 install -U --ignore-installed \
        torch torch_tb_profiler && \
    pip3 install -U --ignore-installed \
        pytorch-lightning torchinfo torchensemble pyro-ppl torch-choice gpytorch 
        #catalyst pytorchltr torchaudio pytorchvideo torchvision albumentations && \
        #pip install torch-scatter torch-sparse torch-geometric gym

#LLM
RUN pip3 install -U --ignore-installed \
        transformers peft trl langchain langchain_ollama ollama inspect-ai chatlas mlverse-mall vllm


#bayes
RUN pip3 install pymc pymc-marketing pymc-bart "arviz[all]"
RUN pip3 install -U "jax[cuda12_pip]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

#RUN pip install tensorboard tensorflow onnxruntime-gpu skl2onnx

#bayes
#RUN pip install numpyro[cuda] -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

#causal
RUN pip3 install -U --ignore-installed \
        pgmpy lingam munkres cdt dowhy econml && \
        #semopy causalml causalnex obp \
    pip3 install pyblp causalml

#image
#RUN apt-get -y install tesseract-ocr tesseract-ocr-jpn libtesseract-dev libleptonica-dev tesseract-ocr-script-jpan tesseract-ocr-script-jpan-vert \
#    pip install pdf2image open3d timm yolov5 pyocr opencv-python pillow PyPDF catboost
RUN pip3 install pillow opencv-python


#transformer

WORKDIR /
RUN mkdir /work && \ 
    mkdir /work/dev && \
    mkdir /work/dev/model/ && \
    mkdir /work/env


ENV PATH /work:$PATH

WORKDIR /work/dev/model/
RUN pip3 install 'transformers[torch]'
#RUN python3 -c \
#    "from transformers import BertJapaneseTokenizer; \
#    tokenizer = BertJapaneseTokenizer.from_pretrained('cl-tohoku/bert-base-japanese-v2'); \
#    dir_name = 'bert_base_japanese_v2'; \
#    tokenizer.save_pretrained(dir_name) "

#NLP
#RUN ./ins_nlp.sh
#WORKDIR /work/dev/
RUN apt-get -y install mecab libmecab-dev file mecab-ipadic-utf8 fontconfig fonts-ipaexfont
RUN pip3 install --upgrade pip
RUN pip3 install -U --ignore-installed \
        python-dotenv gensim ginza \
        networkx oseti requests_oauthlib spacy tqdm
        #allennlp allennlp-models nlpaug pyvis pymlask 

RUN pip3 install -U --ignore-installed \
        mojimoji numba stop-words textblob gensim \
        fugashi fugashi[unidic] sudachipy sudachidict_core mecab-python3 Janome unidic ipywidgets
        #bertopic imgaug pyshp
        #pyLDAvis scattertext ja-ginza-electra ja-ginza janomepreprocessing  \ 
        #ipadicneologdn 
        #cabocha-python 

RUN python3 -m unidic download
#RUN python3 -c "import nltk; nltk.download('omw-1.4')"
#RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && cd ./mecab-unidic-neologd && ./bin/install-mecab-unidic-neologd -n yes yes | mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -n -a
#RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
#    cd mecab-ipadic-neologd && \
#    echo yes | ./bin/install-mecab-ipadic-neologd -n

#GIS
#RUN pip install -U --ignore-installed \
#        geopandas pyrosm shapely pysal geojson contextily mplleaflet osmnx pygeos fiona sentinelsat

# geocoding apply patch
#RUN git clone https://github.com/hottolink/pydams.git \
#    && wget http://newspat.csis.u-tokyo.ac.jp/download/dams-4.3.4.tgz \
#    && tar -xzvf dams-4.3.4.tgz \
#    && patch -d ./dams-4.3.4 -p1 < ./pydams/patch/dams-4.3.4.diff


#RUN pip install pyreadline

#RUN reboot


#jupyter lab
RUN apt-get install -y graphviz graphviz-dev && \
    #pip install datashader plotly dash && \
    pip3 install -U --ignore-installed \
        jupyter jupyterlab lckr-jupyterlab-variableinspector jupyterlab_nvdashboard jupyterlab_execute_time flake8 jupyterlab-git

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && \
    apt-get -y install nodejs

#RUN jupyter lab build --minimize=False

WORKDIR /work
#CMD ["/bin/bash"]
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--LabApp.token=''"]
