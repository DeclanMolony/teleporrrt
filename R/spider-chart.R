#' Cities in the Teleport API
#'
#' @return A dataframe of cities and their links
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
#' @export
city_lookup <- function() {

  res <- GET("https://api.teleport.org/api/urban_areas/")

  cities <- fromJSON(rawToChar(res$content))

  cities <- cities$`_links`$`ua:item`

  return(cities)

}

#' Gives the html link of a city in the Teleport API
#' Use function city_lookup() to see available cities
#'
#' @param city A city name, must be given as a string, the first letter must be capitalized
#'
#' @return An html link of the city's scores
#'
#' @export
city_link <- function(city) {

  cities <- city_lookup()

  link <- cities[cities$name == city,1]

  link <- as.character(link)

  link <- paste0(link, "scores/")

  return(link)

}

#' Creates a dataframe of a city's scores out of 10
#' Use function city_lookup() to see available cities
#'
#' @param city A city name, must be given as a string, the first letter must be capitalized
#'
#' @return A dataframe of a city's score of all 17 metrics
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
#' @export
city_dataframe <- function(city) {

  city_link <- city_link(city)

  res <- GET(city_link)

  city <- fromJSON((rawToChar(res$content)))

  city <- city$categories[,2:3]

  city_df <- as.data.frame(matrix(city$score_out_of_10, ncol = 17))

  colnames(city_df) <- city$name

  return(city_df)

}

#' Merges dataframes created by city_dataframe() for two cities
#' Use function city_lookup() to see available cities
#'
#' @param city1 A city name, must be given as a string, the first letter must be capitalized
#' @param city2 A city name, must be given as a string, the first letter must be capitalized
#'
#' @return A merged dataframe along with metric minimums and maximums
#'
#' @export
city_combine_df <- function(city1,city2) {

  city_1 <- city_dataframe(city1)

  city_2 <- city_dataframe(city2)

  both_cities <- rbind(city_1, city_2)

  both_cities <- rbind(rep(10,17), rep(0,17), both_cities)

  rownames(both_cities) <- c("Max score",
                             "Min score",city1, city2)

  return(both_cities)

}

#' Produces a Spider Chart comparing two cities' metrics from the Teleport API
#' Use function city_lookup() to see available cities
#'
#' @param city1 A city name, must be given as a string, the first letter must be capitalized
#' @param city2 A city name, must be given as a string, the first letter must be capitalized
#'
#' @importFrom fmsb radarchart
#' @importFrom graphics legend
#'
#' @export
city_radarchart <- function(city1, city2) {

  both_cities <- city_combine_df(city1,city2)

  colors_border = c(rgb(0.2,0.5,0.5,0.9), rgb(0.7,0.5,0.1,0.9))
  colors_in = c(rgb(0.2,0.5,0.5,0.4), rgb(0.7,0.5,0.1,0.4))

  radarchart(both_cities, axistype = 1, seg = 5,
             title = paste0("Spider Chart comparing ",city1," and ",city2),
             pcol=colors_border,
             pfcol=colors_in,
             plwd=4,
             plty=1,
             cglcol="grey",
             cglty=1,
             axislabcol="grey",
             caxislabels=seq(0,10,2),
             cglwd=0.8,
             vlcex=0.8)

  legend(x = 0.8, y = 1.2,
         legend = rownames(both_cities[-c(1,2),]),
         bty = "n", pch=20, col=colors_in,
         text.col = "black", cex=1.2, pt.cex=3)

}

