library(shiny)
library(bslib)
library(bsicons)
library(highcharter)
library(reactable)
library(dplyr)
library(tidyr)
library(ggplot2)

# Sample Data Generation (Sales Data)
set.seed(123)
dates <- seq(as.Date("2025-01-01"), as.Date("2025-12-31"), by = "day")
categories <- c("Electronics", "Furniture", "Office Supplies", "Software")
regions <- c("North", "South", "East", "West")

data <- expand.grid(Date = dates, Category = categories, Region = regions) %>%
    mutate(
        Sales = round(runif(n(), 100, 1000) + (as.numeric(Date) - min(as.numeric(Date))) / 10, 2),
        Profit = round(Sales * runif(n(), 0.1, 0.4), 2),
        Quantity = sample(1:10, n(), replace = TRUE)
    )

# UI
ui <- page_sidebar(
    title = "Next-Gen Analytics Dashboard",
    theme = bs_theme(
        version = 5,
        primary = "#007bff",
        secondary = "#6c757d",
        base_font = font_google("Inter"),
        code_font = font_google("JetBrains Mono")
    ),
    sidebar = sidebar(
        title = "Filters",
        selectInput("region", "Region", choices = c("All", regions), selected = "All"),
        selectInput("category", "Category", choices = c("All", categories), selected = "All"),
        dateRangeInput("dates", "Date Range",
            start = min(dates),
            end = max(dates)
        ),
        hr(),
        downloadButton("export_data", "Export to CSV", class = "btn-outline-primary w-100"),
        div(
            style = "margin-top: 10px;",
            actionButton("generate_report", "Generate PDF Report", icon = icon("file-pdf"), class = "btn-danger w-100")
        )
    ),

    # Performance Cards (KPIs)
    layout_columns(
        fill = FALSE,
        value_box(
            title = "Total Sales",
            value = textOutput("total_sales"),
            showcase = bs_icon("currency-dollar"),
            theme = "primary"
        ),
        value_box(
            title = "Total Profit",
            value = textOutput("total_profit"),
            showcase = bs_icon("graph-up-arrow"),
            theme = "success"
        ),
        value_box(
            title = "Avg. Margin",
            value = textOutput("avg_margin"),
            showcase = bs_icon("percent"),
            theme = "info"
        )
    ),

    # Main Visuals
    layout_columns(
        col_widths = c(8, 4),
        card(
            full_screen = TRUE,
            card_header(
                div(
                    class = "d-flex justify-content-between align-items-center",
                    "Sales Trends & Forecast",
                    tooltip(bs_icon("info-circle"), "Interactive time-series analysis")
                )
            ),
            highchartOutput("sales_chart", height = "450px")
        ),
        card(
            full_screen = TRUE,
            card_header("Regional Performance"),
            highchartOutput("region_pie", height = "450px")
        )
    ),

    # Data Table
    card(
        card_header("Detailed Transaction Data"),
        reactableOutput("data_table")
    )
)

# Server
server <- function(input, output, session) {
    # Reactive Data Filtering
    filtered_data <- reactive({
        d <- data
        if (input$region != "All") d <- d %>% filter(Region == input$region)
        if (input$category != "All") d <- d %>% filter(Category == input$category)
        d <- d %>% filter(Date >= input$dates[1] & Date <= input$dates[2])
        d
    })

    # KPI Calculations
    output$total_sales <- renderText({
        paste0("$", format(round(sum(filtered_data()$Sales)), big.mark = ","))
    })

    output$total_profit <- renderText({
        paste0("$", format(round(sum(filtered_data()$Profit)), big.mark = ","))
    })

    output$avg_margin <- renderText({
        margin <- sum(filtered_data()$Profit) / sum(filtered_data()$Sales) * 100
        paste0(round(margin, 1), "%")
    })

    # Highcharts: Sales Trend
    output$sales_chart <- renderHighchart({
        df_trend <- filtered_data() %>%
            group_by(Date) %>%
            summarise(Sales = sum(Sales))

        highchart() %>%
            hc_chart(type = "areaspline") %>%
            hc_title(text = "Daily Sales Over Time") %>%
            hc_xAxis(title = list(text = "Date"), type = "datetime") %>%
            hc_yAxis(title = list(text = "Sales ($)")) %>%
            hc_add_series(data = df_trend, hcaes(x = Date, y = Sales), name = "Sales", color = "#007bff") %>%
            hc_tooltip(shared = TRUE, crosshairs = TRUE) %>%
            hc_exporting(enabled = TRUE)
    })

    # Highcharts: Regional Pie
    output$region_pie <- renderHighchart({
        df_region <- filtered_data() %>%
            group_by(Region) %>%
            summarise(Sales = sum(Sales))

        hc_pie <- highchart() %>%
            hc_chart(type = "pie") %>%
            hc_title(text = "Sales by Region") %>%
            hc_add_series(
                data = df_region,
                hcaes(x = Region, y = Sales),
                name = "Sales",
                innerSize = "60%" # Donut chart style
            ) %>%
            hc_plotOptions(pie = list(dataLabels = list(enabled = TRUE, format = "{point.name}: {point.percentage:.1f}%")))

        hc_pie
    })

    # Reactable: Modern Table
    output$data_table <- renderReactable({
        reactable(
            filtered_data(),
            pagination = TRUE,
            showPageSizeOptions = TRUE,
            highlight = TRUE,
            defaultPageSize = 10,
            columns = list(
                Sales = colDef(format = colFormat(prefix = "$", separators = TRUE, digits = 2)),
                Profit = colDef(
                    format = colFormat(prefix = "$", separators = TRUE, digits = 2),
                    style = function(value) {
                        color <- if (value > 0) "#008000" else "#e00000"
                        list(color = color, fontWeight = "bold")
                    }
                ),
                Date = colDef(format = colFormat(date = TRUE))
            ),
            theme = reactableTheme(
                headerStyle = list(background = "#f8f9fa")
            )
        )
    })

    # CSV Export
    output$export_data <- downloadHandler(
        filename = function() {
            paste("data-", Sys.Date(), ".csv", sep = "")
        },
        content = function(file) {
            write.csv(filtered_data(), file, row.names = FALSE)
        }
    )

    # (Optional) Fake Report Generation Logic
    observeEvent(input$generate_report, {
        showNotification("Generating high-quality Quarto report... (Simulated)", type = "message")
    })
}

# Run App
shinyApp(ui, server)
