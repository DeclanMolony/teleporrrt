test_that("nearest_city returns error message", {

  correct_result <- "Invalid Lat/Lon coordinate"

  my_result <- nearest_city(22, -122)

  expect_equal(my_result, correct_result)
})

test_that("area_link() returns right link for city", {

  correct_result <- "https://api.teleport.org/api/urban_areas/slug:san-diego/salaries/"

  my_result <- area_link("San Diego", "city")

  expect_equal(my_result, correct_result)
})

test_that("area_link() returns right link for country", {

  correct_result <- "https://api.teleport.org/api/countries/iso_alpha2:US/salaries/"

  my_result <- area_link("United States", "country")

  expect_equal(my_result, correct_result)
})

test_that("area_link() returns right error for city", {

  correct_result <- "Invalid city name"

  my_result <- area_link("San Diegos", "city")

  expect_equal(my_result, correct_result)
})

test_that("area_link() returns right error for country", {

  correct_result <- "Invalid country name"

  my_result <- area_link("United Stites", "country")

  expect_equal(my_result, correct_result)
})
