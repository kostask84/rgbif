#' Check input WKT
#'
#' @export
#' @param wkt (character) one or more Well Known Text objects
#' @examples \dontrun{
#' check_wkt('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))')
#' check_wkt('POINT(30.1 10.1)')
#' check_wkt('LINESTRING(3 4,10 50,20 25)')
#'
#' # check many passed in at once
#' check_wkt(c('POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 10.1))',
#'   'POINT(30.1 10.1)'))
#'
#' # bad WKT
#' # wkt <- 'POLYGON((30.1 10.1, 10 20, 20 60, 60 60, 30.1 a))'
#' # check_wkt(wkt)
#'
#' # this passes this check, but isn't valid for GBIF
#' wkt <- 'POLYGON((-178.59375 64.83258989321493,-165.9375 59.24622380205539,
#' -147.3046875 59.065977905449806,-130.78125 51.04484764446178,
#' -125.859375 36.70806354647625,-112.1484375 23.367471303759686,
#' -105.1171875 16.093320185359257,-86.8359375 9.23767076398516,
#' -82.96875 2.9485268155066175,-82.6171875 -14.812060061226388,
#' -74.8828125 -18.849111862023985,
#' -77.34375 -47.661687803329166,-84.375 -49.975955187343295,
#' 174.7265625 -50.649460483096114,
#' 179.296875 -42.19189902447192,-176.8359375 -35.634976650677295,
#' 176.8359375 -31.835565983656227,163.4765625 -6.528187613695323,
#' 152.578125 1.894796132058301,135.703125 4.702353722559447,
#' 127.96875 15.077427674847987,127.96875 23.689804541429606,
#' 139.921875 32.06861069132688,149.4140625 42.65416193033991,
#' 159.2578125 48.3160811030533,168.3984375 57.019804336633165,
#' 178.2421875 59.95776046458139,-179.6484375 61.16708631440347,
#' -178.59375 64.83258989321493))'
#' check_wkt(gsub("\n", '', wkt))
#'
#' # many wkt's, semi-colon separated, for many repeated "geometry" args
#' wkt <- "POLYGON((-102.2 46.0,-93.9 46.0,-93.9 43.7,-102.2 43.7,-102.2 46.0))
#' ;POLYGON((30.1 10.1, 10 20, 20 40, 40 40, 30.1 10.1))"
#' check_wkt(gsub("\n", '', wkt))
#' }

check_wkt <- function(wkt = NULL){
  if (!is.null(wkt)) {
    stopifnot(is.character(wkt))

    newwkt <- c()
    for (i in seq_along(wkt)) {
      if (grepl(";", wkt[[i]])) {
        newwkt[[i]] <- strsplit(wkt[[i]], ";")[[1]]
      } else {
        newwkt[[i]] <- wkt[[i]]
      }
    }
    wkt <- unlist(newwkt)

    y <- strextract(wkt, "[A-Z]+")

    wkts <- c('POINT', 'POLYGON', 'MULTIPOLYGON', 'LINESTRING', 'LINEARRING')

    for (i in seq_along(wkt)) {
      if (!y[i] %in% wkts) {
        stop(
          paste0("WKT must be one of the types: ",
                 paste0(wkts, collapse = ", "))
        )
      }

      res <- wicket::validate_wkt(wkt[i])
      if (!res$is_valid) stop(res$comments)
    }

    return(wkt)
  } else {
    NULL
  }
}
