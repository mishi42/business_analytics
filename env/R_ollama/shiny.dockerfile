# Base R Shiny image
FROM rocker/shiny-verse

# Install R dependencies
RUN install2.r --error --skipmissing --skipinstalled \
               shinychat ellmer bslib plotly GWalkR ggplot2 shinydashboard

# Expose the application port
EXPOSE 3838
