install2.r --error --skipmissing \
    # graphic handling ============================================================================
    dbplyr \
    ggh4x \
    ggquiver \
    ggExtra \
    # bayes ============================================================================
    tidybayes \
    rstan \
    rstanarm \
    bayesplot \
   #document ============================================================================
    rticles \
    rmarkdown \
    knitr \
    DT \
    htmlwidgets \
    bookdown \
    tableone \
    knitr \
    sessioninfo \
    tinytex \
    latex2exp \
    distill \
    equatiomatic \
    kable \
    kableExtra \
    readxl \
    docxtractr \
    gapminder \
    ftExtra \
    reactable \
    minidown \
    rvest \
    RSelenium \
    stringr \
    polite \
    renv \
    targets \
    cronR \
    openxlsx \
    drat \
    OpenCL \
    DBI \
    spatialsample \
    ggthemes \
    Rtsne \
    gtsummary \
    corrplot \
    modelsummary \
    rBaysianOptimization \
    RODBC \
    skimr \
    progress \
    stringi \
    excel.link \
    XLConnect \
    patchwork \
    sen2r \
    languageserver

#bayes
R -q -e 'tinytex::install_tinytex(force = TRUE);tinytex::tlmgr_install("ipaex")'

