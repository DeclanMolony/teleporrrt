test_that("cities_valid() returns the correct result",{
  correct_result <- c("FALSE")

  my_result <- cities_valid(c("Vienna", "Zuric"))

  expect_equal(my_result, correct_result)
})

test_that("MaxMinRating() returns the correct result",{
  correct_result <- c("Please choose a valid category!")

  my_result <- MaxMinRating(c("Toronto", "Vancouver"), "cost")

  expect_equal(my_result, correct_result)
})

test_that("MaxMinRating() returns the correct result",{
  correct_result <- c("Please choose valid cities. Use the function 'city_lookup()' for a list of valid cities.")

  my_result <- MaxMinRating(c("Toronto", "Vancouve"), "cost of living")

  expect_equal(my_result, correct_result)
})

test_that("MaxMinRating() returns the correct result",{
  correct_result <- c("Maximum cost of living rating: 5.271 (Toronto)", "Minimum cost of living rating: 5.259 (Vancouver)")

  my_result <- MaxMinRating(c("Toronto", "Vancouver"), "cost of living")

  expect_equal(my_result, correct_result)
})



