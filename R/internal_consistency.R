#' @title Check internal consistency of a test or questionnaire
#' @name reliab_test
#'
#' @description These function compute various measures of internal consistencies
#'                for tests or item-scales of questionnaires.
#'
#' @param x Depending on the function, \code{x} may be a \code{matrix} as
#'          returned by the \code{\link{cor}}-function, or a data frame
#'          with items (e.g. from a test or questionnaire).
#' @param scale.items Logical, if \code{TRUE}, the data frame's vectors will be scaled. Recommended,
#'          when the variables have different measures / scales.
#' @param digits Amount of digits for returned values.
#' @param cor.method Correlation computation method. May be one of
#'          \code{"spearman"} (default), \code{"pearson"} or \code{"kendall"}.
#'          You may use initial letter only.
#'
#' @inheritParams grpmean
#'
#' @return \describe{
#'            \item{\code{reliab_test()}}{
#'              A data frame with the corrected item-total correlations (\emph{item
#'              discrimination}, column \code{item.discr}) and Cronbach's alpha
#'              (if item deleted, column \code{alpha.if.deleted}) for each item
#'              of the scale, or \code{NULL} if data frame had too less columns.
#'            }
#'            \item{\code{split_half()}}{
#'              A list with two values: the split-half reliability \code{splithalf} and
#'              the Spearman-Brown corrected split-half reliability \code{spearmanbrown}.
#'            }
#'            \item{\code{cronb()}}{
#'              The Cronbach's Alpha value for \code{x}.
#'            }
#'            \item{\code{mic()}}{
#'              The mean inter-item-correlation value for \code{x}.
#'            }
#'            \item{\code{difficulty()}}{
#'              The item difficulty value for \code{x}.
#'            }
#'          }
#'
#' @details \describe{
#'            \item{\code{reliab_test()}}{
#'              This function calculates the item discriminations (corrected item-total
#'              correlations for each item of \code{x} with the remaining items) and
#'              the Cronbach's alpha for each item, if it was deleted from the scale.
#'              The absolute value of the item discrimination indices should be
#'              above 0.1. An index between 0.1 and 0.3 is considered as "fair",
#'              while an index above 0.3 (or below -0.3) is "good". Items with
#'              low discrimination indices are often ambiguously worded and
#'              should be examined. Items with negative indices should be
#'              examined to determine why a negative value was obtained (e.g.
#'              reversed answer categories regarding positive and negative poles).
#'            }
#'            \item{\code{split_half()}}{
#'              This function calculates the split-half reliability for items in
#'              the data frame \code{x}, including the Spearman-Brown adjustment.
#'              Splitting is done by selecting odd versus even columns in \code{x}.
#'              A value closer to 1 indicates greater internal consistency.
#'            }
#'            \item{\code{cronb()}}{
#'              The Cronbach's Alpha value for \code{x}. A value closer to 1
#'              indicates greater internal consistency, where usually following
#'              rule of thumb is applied to interprete the results:
#'              \ifelse{html}{\out{&alpha;}}{\eqn{\alpha}{alpha}} < 0.5 is unacceptable,
#'              0.5 < \ifelse{html}{\out{&alpha;}}{\eqn{\alpha}{alpha}} < 0.6 is poor,
#'              0.6 < \ifelse{html}{\out{&alpha;}}{\eqn{\alpha}{alpha}} < 0.7 is questionable,
#'              0.7 < \ifelse{html}{\out{&alpha;}}{\eqn{\alpha}{alpha}} < 0.8 is acceptable,
#'              and everything > 0.8 is good or excellent.
#'            }
#'            \item{\code{mic()}}{
#'              This function calculates a mean inter-item-correlation, i.e.
#'              a correlation matrix of \code{x} will be computed (unless
#'              \code{x} is already a matrix as returned by the
#'              \code{\link{cor}}-function) and the mean
#'              of the sum of all item's correlation values is returned.
#'              Requires either a data frame or a computed \code{\link{cor}}-object.
#'              \cr \cr
#'              \dQuote{Ideally, the average inter-item correlation for a set of
#'              items should be between .20 and .40, suggesting that while the
#'              items are reasonably homogenous, they do contain sufficiently
#'              unique variance so as to not be isomorphic with each other.
#'              When values are lower than .20, then the items may not be
#'              representative of the same content domain. If values are higher than
#'              .40, the items may be only capturing a small bandwidth of the construct.}
#'              \cite{(Piedmont 2014)}
#'            }
#'            \item{\code{difficulty()}}{
#'              This function calculates the item difficutly, which should
#'              range between 0.2 and 0.8. Lower values are a signal for
#'              more difficult items, while higher values close to one
#'              are a sign for easier items. The ideal value for item difficulty
#'              is \code{p + (1 - p) / 2}, where \code{p = 1 / max(x)}. In most
#'              cases, the ideal item difficulty lies between 0.5 and 0.8.
#'            }
#'          }
#'
#' @references Spearman C. 1910. Correlation calculated from faulty data. British Journal of Psychology (3): 271–295. \doi{10.1111/j.2044-8295.1910.tb00206.x}
#'             \cr \cr
#'             Brown W. 1910. Some experimental results in the correlation of mental abilities. British Journal of Psychology (3): 296–322. \doi{10.1111/j.2044-8295.1910.tb00207.x}
#'             \cr \cr
#'             Piedmont RL. 2014. Inter-item Correlations. In: Michalos AC (eds) Encyclopedia of Quality of Life and Well-Being Research. Dordrecht: Springer, 3303-3304. \doi{10.1007/978-94-007-0753-5_1493}
#'
#' @examples
#' library(sjlabelled)
#' # Data from the EUROFAMCARE sample dataset
#' data(efc)
#'
#' # retrieve variable and value labels
#' varlabs <- get_label(efc)
#'
#' # recveive first item of COPE-index scale
#' start <- which(colnames(efc) == "c82cop1")
#' # recveive last item of COPE-index scale
#' end <- which(colnames(efc) == "c90cop9")
#'
#' # create data frame with COPE-index scale
#' x <- efc[, c(start:end)]
#' colnames(x) <- varlabs[c(start:end)]
#'
#' # reliability tests
#' reliab_test(x)
#'
#' # split-half-reliability
#' split_half(x)
#'
#' # cronbach's alpha
#' cronb(x)
#'
#' # mean inter-item-correlation
#' mic(x)
#'
#' # item difficulty
#' difficulty(x)
#'
#' \dontrun{
#' library(sjPlot)
#' sjt.df(reliab_test(x), describe = FALSE, show.cmmn.row = TRUE,
#'        string.cmmn = sprintf("Cronbach's &alpha;=%.2f", cronb(x)))
#'
#' # Compute PCA on Cope-Index, and perform a
#' # reliability check on each extracted factor.
#' factors <- sjt.pca(x)$factor.index
#' findex <- sort(unique(factors))
#' library(sjPlot)
#' for (i in seq_len(length(findex))) {
#'  rel.df <- subset(x, select = which(factors == findex[i]))
#'  if (ncol(rel.df) >= 3) {
#'    sjt.df(reliab_test(rel.df), describe = FALSE, show.cmmn.row = TRUE,
#'           use.viewer = FALSE, title = "Item-Total-Statistic",
#'           string.cmmn = sprintf("Scale's overall Cronbach's &alpha;=%.2f",
#'                                 cronb(rel.df)))
#'    }
#'  }}
#'
#' @importFrom stats cor
#' @importFrom sjmisc std
#' @export
reliab_test <- function(x, scale.items = FALSE, digits = 3, out = c("txt", "viewer", "browser")) {
  # check param
  if (!is.matrix(x) && !is.data.frame(x)) {
    warning("`x` needs to be a data frame or matrix.", call. = F)
    return(NULL)
  }

  out <- match.arg(out)

  if (out != "txt" && !requireNamespace("sjPlot", quietly = TRUE)) {
    message("Package `sjPlot` needs to be loaded to print HTML tables.")
    out <- "txt"
  }


  # remove missings, so correlation works
  x <- stats::na.omit(x)

  # remember item (column) names for return value
  # return value gets column names of initial data frame
  df.names <- colnames(x)

  # check for minimum amount of columns
  # can't be less than 3, because the reliability
  # test checks for Cronbach's alpha if a specific
  # item is deleted. If data frame has only two columns
  # and one is deleted, Cronbach's alpha cannot be calculated.
  if (ncol(x) > 2) {
    # Check whether items should be scaled. Needed,
    # when items have different measures / scales
    if (scale.items) x <- sjmisc::std(x, append = FALSE)

    # init vars
    totalCorr <- c()
    cronbachDeleted <- c()

    # iterate all items
    for (i in seq_len(ncol(x))) {
      # create subset with all items except current one
      # (current item "deleted")
      sub.df <- subset(x, select = c(-i))

      # calculate cronbach-if-deleted
      cronbachDeleted <- c(cronbachDeleted, cronb(sub.df))

      # calculate corrected total-item correlation
      totalCorr <- c(totalCorr, stats::cor(x[, i],
                                           apply(sub.df, 1, sum),
                                           use = "pairwise.complete.obs"))
    }

    # create return value
    ret.df <- data_frame(
      term = df.names,
      alpha.if.deleted = round(cronbachDeleted, digits),
      item.discr = round(totalCorr, digits)
    )
  } else {
    warning("Data frame needs at least three columns for reliability-test.", call. = F)
    return(NULL)
  }

  # save how to print output
  attr(ret.df, "print") <- out

  if (out %in% c("viewer", "browser"))
    class(ret.df) <- c("sjt_reliab", class(ret.df))

  ret.df
}



#' @rdname reliab_test
#' @importFrom stats cor
#' @export
split_half <- function(x, digits = 3) {
  # Calculating total score for even items
  score_e <- rowMeans(x[, c(TRUE, FALSE)], na.rm = TRUE)
  # Calculating total score for odd items
  score_o <- rowMeans(x[, c(FALSE, TRUE)], na.rm = TRUE)

  # Correlating scores from even and odd items
  shr <- stats::cor(score_e, score_o, use = "complete.obs")

  # Adjusting with the Spearman-Brown prophecy formula
  sb.shr <- (2 * shr) / (1 + shr)

  structure(class = "sj_splithalf",
            list(splithalf = shr, spearmanbrown = sb.shr))
}



#' @rdname reliab_test
#' @importFrom stats na.omit var
#' @export
cronb <- function(x) {
  # remove missings
  .data <- stats::na.omit(x)

  # we need at least two columns for Cronach's Alpha
  if (is.null(ncol(.data)) || ncol(.data) < 2) {
    warning("Too less columns in `x` to compute Cronbach's Alpha.", call. = F)
    return(NULL)
  }

  # Compute Cronb. Alpha
  dim(.data)[2] / (dim(.data)[2] - 1) * (1 - sum(apply(.data, 2, var)) / stats::var(rowSums(.data)))
}


#' @rdname reliab_test
#' @importFrom stats na.omit
#' @export
difficulty <- function(x) {
  d <- apply(x, 2, function(.x) {
    .x <- stats::na.omit(.x)
    round(sum(.x) / (max(.x) * length(.x)), 2)
  })

  # ideal item difficulty
  fun.diff.ideal <- function(.x) {
    p <- 1 / max(.x, na.rm = T)
    round(p + (1 - p) / 2, 2)
  }

  di <- apply(x, 2, fun.diff.ideal)

  attr(d, "ideal.difficulty") <- di
  attr(d, "items") <- colnames(x)
  class(d) <- c("sj_item_diff", "numeric")

  d
}


#' @rdname reliab_test
#' @importFrom stats cor na.omit
#' @export
mic <- function(x, cor.method = c("pearson", "spearman", "kendall")) {
  # Check parameter
  cor.method <- match.arg(cor.method)

  # Mean-interitem-corelation
  if (inherits(x, "matrix")) {
    corr <- x
  } else {
    x <- stats::na.omit(x)
    corr <- stats::cor(x, method = cor.method)
  }

  # Sum up all correlation values
  meanic <- c()

  for (j in seq_len((ncol(corr) - 1))) {
    # first correlation is always "1" (self-correlation)
    for (i in (j + 1):nrow(corr)) {
      # check for valid bound
      if (i <= nrow(corr) && j <= ncol(corr)) {
        # add up all subsequent values
        meanic <- c(meanic, corr[i, j])
      } else {
        meanic <- c(meanic, "NA")
      }
    }
  }

  mean(meanic)
}
