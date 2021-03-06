if (require("testthat") && require("sjstats") && require("lme4") && require("dplyr")) {
  context("sjstats, pred_vars")

  data("sleepstudy")

  sleepstudy$mygrp <- sample(1:5, size = 180, replace = TRUE)
  sleepstudy <- sleepstudy %>%
    dplyr::group_by(mygrp) %>%
    dplyr::mutate(mysubgrp = sample(1:30, size = n(), replace = TRUE))

  m1 <- lme4::lmer(
    Reaction ~ Days + (1 + Days | Subject),
    data = sleepstudy
  )

  m2 <- lme4::lmer(
    Reaction ~ Days + (1 | mygrp / mysubgrp) + (1 | Subject),
    data = sleepstudy
  )

  test_that("re_grp_var", {
    expect_equal(re_grp_var(m1), "Subject")
    expect_equal(re_grp_var(m2), c("mysubgrp:mygrp", "mygrp", "Subject"))
  })
}

