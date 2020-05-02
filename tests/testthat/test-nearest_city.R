test_that("nearest_city returns error message", {

  correct_result <- "Invalid Lat/Lon coordinate"

  my_result <- nearest_city(22, -122)

  expect_equal(my_result, correct_result)
})
