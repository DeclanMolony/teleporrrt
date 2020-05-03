#' Gives the closest city and distance to a given location
#'
#' @param lat the latitude position to search with
#' @param lon the longitude position to search with
#'
#' @return A data frame with closest city name and distance(km)
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' nearest_city(lat = 37, lon = -120)
#'
#' @export
nearest_city <- function(lat, lon){

  response <- GET(paste0("https://api.teleport.org/api/locations/", lat, ",", lon, "/"))

  content <- fromJSON(rawToChar(response$content))$`_embedded`$`location:nearest-cities`

  distance_km <- as.numeric(content$distance_km)

  nearest_city <- content$`_links`$`location:nearest-city`$name

  if(is.null(nearest_city)){
    return("Invalid Lat/Lon coordinate")
  }

  nearest_df <- cbind(nearest_city, distance_km)

  return(nearest_df)

}

#' @title Gives the html link of a city or country in the Teleport API
#'
#' @description Use function city_lookup() to see available cities and country_lookup() to see available countries
#'
#' @param area Either a city or country name, must be given as a string, the first letter must be capitalized
#' @param type "city" by default. A string indicating if the area is a city or country, use "country".
#'
#' @return an html link for the salaries of the given area
#'
#' @examples
#' area_link("San Diego")
#' area_link("United States", "country")
#'
#' @export
area_link <- function(area, type = "city") {

  if(type == "city") {

    cities <- city_lookup()

    link <- cities[cities$name == area,1]

    if (identical(link, character(0))) {
      return("Invalid city name")
    }

    link <- as.character(link)

    link <- paste0(link, "salaries/")

    return(link)

  } else if(type == "country") {

    countries <- country_lookup()

    link <- countries[countries$name == area,1]

    if (identical(link, character(0))) {
      return("Invalid country name")
    }

    link <- as.character(link)

    link <- paste0(link, "salaries/")

    return(link)

  } else{

    return("Invalid 'type' specified")

  }

}

#' Countries in the Teleport API
#'
#' @return A dataframe of countries and their links
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
#' @export
country_lookup <- function() {

  res <- GET("https://api.teleport.org/api/countries/")

  countries <- fromJSON(rawToChar(res$content))

  countries <- countries$`_links`$`country:items`

  return(countries)

}

#' Gives a dataframe of the 25th, 50th, and 75th salary percentiles for jobs in a given city
#'
#' @param area Either a city or country name, must be given as a string, the first letter must be capitalized
#' @param type "city" by default. A string indicating if the area is a city or country, use "country".
#'
#' @return a dataframe where each row is a job, and the columns are salary percentiles
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
#' @examples
#' salaries_qt("San Diego")
#' salaries_qt("United States", "country")
#'
#' @export
salaries_qt <- function(area, type = "city") {

  response <- GET(area_link2(area, type))

  content <- fromJSON(rawToChar(response$content))

  job_names <- content$salaries$job$title

  salaries <- content$salaries$salary_percentiles

  salary_df <- cbind(job_names, salaries)

  return(salary_df)

}

