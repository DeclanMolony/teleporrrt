test_that("city_link() provides the Teleport API link to a specific city",{
  correct_result <- "https://api.teleport.org/api/urban_areas/slug:dublin/scores/"

  my_result <- city_link("Dublin")

  expect_equal(my_result, correct_result)
})
