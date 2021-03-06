#' Finds the minimal common supertaxa for a list of names.
#' 
#' @import httr jsonlite
#' @export
#' @param nameUIDs Space-separated list of UUIDs for taxonomic names.
#' @param options Space-separated list of options for the result value.
#' @param ... Further args passed on to GET. See examples.
#' @details Here are the options for the options argument:
#' \itemize{
#'  \item{citationStart}{[optional] Integer Indicates where in the string the citation starts. 
#'  May be null.}
#'  \item{html}{[optional] StringHTML version of the name.}
#'  \item{namebankID}{[optional] StringuBio Namebank identifier. May be null.}
#'  \item{root}{[optional] Boolean If true, this name has no hyperonyms (names of supertaxa). 
#'  (Should only be true for Panbiota/Vitae.)}
#'  \item{string}{[optional] String The text of the name, including the citation, if any.}
#'  \item{type}{[optional] String Either "scientific or "vernacular.}
#'  \item{uid}{[always] String Universally unique identifier.}
#'  \item{uri}{[optional] String The unique URI associated with the name.}
#'  \item{votes}{[optional] Integer The number of votes this name has received. (Currently unused.)}
#' }
#' @examples \dontrun{
#' minimal_supertaxa(nameUIDs=c("1ee65cf3-53db-4a52-9960-a9f7093d845d", 
#'    "08141cfc-ef1f-4d0e-a061-b1347f5297a0"))
#' }

minimal_supertaxa <- function(nameUIDs, options=NULL, ...)
{
  url = "http://phylopic.org/api/a/name/minSupertaxa/"
  nameUIDs <- paste(nameUIDs, collapse=" ")
  args <- phy_compact(list(nameUIDs=nameUIDs, options=options))
  tt <- GET(url, query=args, ...)
  assert_that(tt$status_code < 203)
  assert_that(tt$headers$`content-type` == "application/json; charset=utf-8")
  res <- content(tt, as = "text")
  out <- fromJSON(res, FALSE)
  out$result[[1]]$canonicalName$uid
}