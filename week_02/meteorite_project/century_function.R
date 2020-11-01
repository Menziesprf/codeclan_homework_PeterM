# year must be in format "yyyy"
# eg. 2020 or 0893
# Doesn't work for years before 100 AD 
# Doesn't work for years beyond 2199 AD

century <- function(year) {
  if (year < 1000) {
    cent <- str_sub(year, start = 1, end = 1)
    cent <- as.numeric(cent)
    if (cent == 1) {
      return(paste(cent + 1, "nd", sep = ""))
    }
    if (cent == 2) {
      return(paste(cent + 1, "rd", sep = ""))
    }
    if (cent >= 3 & cent <= 9) {
      return(paste(cent + 1, "th", sep = ""))
    }
  }
  if (year >= 1000) {
    cent <- str_sub(year, start = 1, end = 2)
    cent <- as.numeric(cent)  
    if (cent >= 10 & cent <= 19) {
      return(paste(cent + 1, "th", sep = ""))
    }
    if (cent == 20) {
      return(paste(cent + 1, "st", sep = ""))
    }  
    if (cent == 21) {
      return(paste(cent + 1, "nd", sep = ""))
    }
  }
}

century(2120)
century(2013)
century(1956)
century(1856)
century(1756)
century(1656)
century(1556)
century(1456)
century(1356)
century(1256)
century(1156)
century(1056)
century(0956)
century(0856)
century(0756)
century(656)
century(556)
century(456)
century(356)
century(256)
century(156)

