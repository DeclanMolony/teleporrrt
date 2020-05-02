#Nearest City finder?
#Photo Finder

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
