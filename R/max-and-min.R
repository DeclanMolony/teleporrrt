#' Finds the Maximum and the Minimum Ratings in a Dataframe Based on the Teleport API
#'
#' @param citiesdf A dataframe consisting of two columns, the first being the city and the second being the category
#' @param locasecat A valid category that is in lowercase form
#'
#' @return A list containing the maximum rating with its corresponding city, and the minimum rating with its corresponding city
#'
#' @export
find_max_find_min <- function(citiesdf, locasecat){

  maxrowindex = which.max(citiesdf[,2] )
  maxRow = citiesdf[maxrowindex, ]

  minrowindex = which.min(citiesdf[,2])
  minRow = citiesdf[minrowindex, ]

  returnMax = paste("Maximum ", locasecat, " rating: ", maxRow[1,2], " (", maxRow[1,1], ")", sep = "")
  returnMin = paste("Minimum ", locasecat, " rating: ", minRow[1,2], " (", minRow[1,1], ")", sep = "")

  maxandmin = c(returnMax, returnMin)

  return(maxandmin)
}

#' Checks if Valid Cities in the Teleport API are Given
#'
#' @param cities A list of city names
#'
#' @return A list of FALSE corresponding to each city given that is not valid
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
#' @export
cities_valid = function(cities){

  validCities = GET("https://developers.teleport.org/assets/urban_areas.json")

  citieslist = fromJSON(rawToChar(validCities$content))

  allcities = tolower(names(citieslist))

  citiesGiven = tolower(cities)

  tfcities = c()

  for (i in 1:length(cities)){

    if (citiesGiven[i] %in% allcities){

      tfcities = tfcities

    } else if (!citiesGiven[i] %in% allcities) {

      tfcities = c(tfcities, "FALSE")
    }
  }

  return(tfcities)
}

#' Returns the Maximum and Minimum Rating of Cities, Given a Certain Category
#'
#' @param cities A list of city names
#' @param category A category name; accepts only Education, Housing, or Cost of Living - not case sensitive
#'
#' @return A list containing the maximum rating with its corresponding city, and the minimum rating with its corresponding city
#'
#' @importFrom httr GET
#' @importFrom jsonlite fromJSON
#'
#' @export
MaxMinRating <- function(cities, category){

  City = c()
  CostOfLiving = c()
  Education = c()
  Housing = c()
  citiesdf = data.frame()

  if("FALSE" %in% cities_valid(cities)){

    return(paste("Please choose valid cities.", "Use the function 'city_lookup()' for a list of valid cities.", sep = " "))

  } else if (!"FALSE" %in% cities_valid(cities)) {

    for(i in 1:length(cities)){

      locasecities = tolower(cities)

      locasecat = tolower(category)

      scores = GET(paste("https://api.teleport.org/api/urban_areas/slug:", locasecities[i], "/scores/", sep = ""))

      data = fromJSON(rawToChar(scores$content))

      City = c(City, cities[i])

      if (locasecat == "cost of living"){

        CostOfLiving = c(CostOfLiving, data$categories$score_out_of_10[2])
        citiesdf = data.frame(City, CostOfLiving)

      } else if (locasecat == "education") {

        Education = c(Education, data$categories$score_out_of_10[10])
        citiesdf = data.frame(City, Education)

      } else if (locasecat == "housing") {

        Housing = c(Housing, data$categories$score_out_of_10[1])
        citiesdf = data.frame(City, Housing)

      } else {

        return("Please choose a valid category!")

      }
    }
    find_max_find_min(citiesdf, locasecat)
  }
}


