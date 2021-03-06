#' @title Return a vector of consecutive dates
#'
#' @param dateBegin \code{character or date}, date, YYYY-MM-DD
#' @param dateEnd \code{character or date}, date, YYYY-MM-DD
#'
#' @return a vector of dates
#' @examples
#'
#' \dontrun{
#' getSequence("2017-01-01", "2017-12-31")
#' }
#'
#' @export
getSequence <- function(dateBegin, dateEnd){
  seq(as.Date(dateBegin), as.Date(dateEnd), by = "day")
}


#' @title Build a calendar
#' 
#' @description Define a calendar, with three different "seasons" (winter, summer and interseason) and two types
#' of days (working days and weekends)
#'
#' @param dates \code{character or date}, vector of dates YYYY-MM-DD, can be generate with \link{getSequence}
#' @param interSeasonBegin \code{character or date}, date or vector of dates, YYYY-MM-DD, begin of interseason
#' @param interSeasonEnd \code{character or date}, date or vector of dates, YYYY-MM-DD, end of interseason
#' @param dayInWeekend \code{numeric}, indice of weekend days. By default \code{c(6,7)} for saturdays and sundays
#' @param dayExclude  \code{character or date}, date or vector of dates, YYYY-MM-DD, day(s) to exclude from the calendar
#' @param holiday \code{character}, see \link[timeDate]{holiday} for holidays names, holidays will be considered as weekends. Holidays days by default are :
#' NewYearsDay,GoodFriday,EasterSunday,
#' EasterMonday,LaborDay,FRAscension,Pentecost,PentecostMonday,
#' FRAssumptionVirginMary,FRAllSaints,FRArmisticeDay,
#' ChristmasEve,ChristmasDay,BoxingDay,DENewYearsEve
#'
#' @return A list of vector of dates. The name of each element of the list is a so-called "class" (season x type of day, e.g. summerWd).
#' @examples
#'
#' \dontrun{
#' dates <- getSequence("2017-01-01", "2017-12-31")
#' interSeasonBegin <- c("2017-03-01", "2017-09-01")
#' interSeasonEnd <- c("2017-05-01", "2017-11-01")
#' dayExclude <- c("2017-06-15", "2017-06-16")
#' getCalendar(dates, interSeasonBegin, interSeasonEnd, dayExclude = dayExclude)
#' }
#'
#' @import timeDate 
#'
#' @export
getCalendar <- function(dates,
                        interSeasonBegin,
                        interSeasonEnd,
                        dayExclude = NULL,
                        holiday = c("NewYearsDay",
                                    "GoodFriday",
                                    "EasterSunday",
                                    "EasterMonday",
                                    "LaborDay",
                                    "FRAscension",
                                    "Pentecost",
                                    "PentecostMonday",
                                    "FRAssumptionVirginMary",
                                    "FRAllSaints",
                                    "FRArmisticeDay",
                                    "ChristmasEve",
                                    "ChristmasDay",
                                    "BoxingDay",
                                    "DENewYearsEve"),
                        dayInWeekend = c(6, 7)){
  
  # browser()
  # Get weekend day
  weekendDay <- function(day, dayInWeekend, holiday){
    daywe <- day[ifelse(data.table::wday(day)==1,7,data.table::wday(day)-1)%in%dayInWeekend]
    allYeay <- unique(year(day))
    dayHilyday <- NULL
    if(length(holiday) > 0)
    {
      HolidayDay <- as.Date(holiday(allYeay, Holiday = holiday))
      dayHilyday <- day[day%in%HolidayDay]
    }
    unique(sort(c(daywe, dayHilyday)))
  }
  
  dates <- as.Date(dates)
  
  
  if(length(interSeasonBegin) == 0){
    stop("interSeasonBegin must be provided")
  }
  if(length(interSeasonEnd) == 0){
    stop("interSeasonEnd must be provided")
  }
  
  interSeasonBegin <- as.Date(interSeasonBegin)
  interSeasonEnd <- as.Date(interSeasonEnd)
  
  
  ##Control if intersaisons day are includes in dates
  if( sum(interSeasonBegin %in% dates) != length(interSeasonBegin) ){
    erroreseason <- interSeasonBegin[!interSeasonBegin %in% dates]
    erroreseason <- paste0(erroreseason, collapse = ";")
    stop(paste0("Intersaison begin : ", erroreseason, " not in date vector"))
  }
  if( sum(interSeasonEnd %in% dates) != length(interSeasonEnd) ){
    erroreseason <- interSeasonEnd[!interSeasonEnd %in% dates]
    erroreseason <- paste0(erroreseason, collapse = ";")
    stop(paste0("Intersaison end : ", erroreseason, " not in date vector"))
  }
  
  
  
  # Control user input
  if(length(interSeasonBegin) != length(interSeasonEnd)){
    stop("You must specify a begin and end for each interseason, (interSeasonBegin and interSeasonEnd
         must have same length")}
  
  if(!(all(interSeasonBegin < interSeasonEnd))){
    stop("All interSeasonBegin must be > to corresponding interSeasonEnd")
  }
  
  dates <- as.Date(dates)
  
  # Generate seq of all date, filtering will be apply after
  allDay <- seq(min(dates), max(dates), by = "day")
  
  dayRemoveVectorIn <- allDay[!allDay%in%dates]
  
  if(length(dates)>0){
    if(is.null(dayExclude))
    {
      if(length(dayRemoveVectorIn) > 0)
      {
        dayExclude <- dayRemoveVectorIn
      }
    }else{
      dayExclude <- as.Date(dayExclude)
      dayExclude <- unique(c(dayExclude, dayRemoveVectorIn))
      
    }
  }
  
  # find days with hour changed
  MarsChangeHour <- NULL
  if(length(allDay[which(month(allDay) == 3 & wday(allDay) == 1)]) > 0)
  {
    MarsChangeHour <- max(allDay[which(month(allDay) == 3 & wday(allDay) == 1)])
  }
  OctChangeHour <- NULL
  if(length(allDay[which(month(allDay) == 10 & wday(allDay) == 1)]) > 0)
  {
    OctChangeHour <- max(allDay[which(month(allDay) == 10 & wday(allDay) == 1)])
  }
  
  if(is.null(dayExclude)){
    dayExclude <- c(MarsChangeHour, OctChangeHour)
  }else{
    dayExclude <- as.Date(dayExclude)
    dayExclude <- unique(c(dayExclude, MarsChangeHour, OctChangeHour))
  }
  
  calendarReturn <- list()
  interSeason <- data.frame(begin = as.Date(interSeasonBegin), end = as.Date(interSeasonEnd))
  interSeasonDay <- sapply(1:nrow(interSeason), function(X){
    Y <- interSeason[X,]
    seq(as.Date(Y[,1]), as.Date(Y[,2]), by = "day")
  }, simplify = FALSE)
  
  # Be carefull unlist break date class.
  interSeasonDay <- do.call("c", interSeasonDay)
  
  interSeasonDayWeekend <- weekendDay(interSeasonDay, dayInWeekend, holiday)
  calendarReturn$interSeasonWe <- interSeasonDayWeekend
  calendarReturn$interSeasonWd <- interSeasonDay[!interSeasonDay%in%interSeasonDayWeekend]
  
  # Select day in interSeason
  saisonDay <- which(!allDay%in%interSeasonDay)
  
  
  # found breaks for interSeasonDay, create vector for each season
  breakS <- which(diff(saisonDay)!=1)+1
  allSaison <- list()
  saisonAffect <- 0
  for(i in 0:(length(breakS))){
    if(i == length(breakS)){
      CurrentSaison <-(breakS[i]):length(saisonDay)
      saisonAffect <- saisonAffect + 1
      allSaison[[saisonAffect]] <- saisonDay[CurrentSaison]
    }else{
      
      if(i == 0){
        CurrentSaison <- 1:(breakS[1]-1)
      }else{
        CurrentSaison <-breakS[i]:(breakS[i+1]-1)
      }
      saisonAffect <- saisonAffect + 1
      allSaison[[saisonAffect]] <- saisonDay[CurrentSaison]
    }
  }
  
  
  Saison <- lapply(allSaison, function(X){
    allDay[X]
  })
  
  
  
  # Dedect winter and summer
  monthSWinter <- c(1:4, 10:12)
  monthSSummer <- 5:9
  
  WS <- unlist(lapply(Saison, function(X){
    nbDayInWinter <- sum(month(X)%in%monthSWinter)
    nbDayInSummer <- sum(month(X)%in%monthSSummer)
    if(nbDayInWinter>nbDayInSummer){
      "W"
    }else{
      "S"
    }
  }))
  
  if(length(unique(WS))<2){
    stop("Cannot identify winter and/or summer as date does not cover a sufficiently long period of time.")
  }
  
  
  # Select winter and cut Week and Weekend
  winter <- do.call("c",(Saison[which(WS == "W")]))
  winterWe <- weekendDay(winter, dayInWeekend, holiday)
  calendarReturn$winterWe <- winterWe
  calendarReturn$winterWd <- winter[!winter%in%winterWe]
  
  # Select summer and cut Week and Weekend
  summer <-  do.call("c", (Saison[which(WS == "S")]))
  summerWe <- weekendDay(summer, dayInWeekend, holiday)
  calendarReturn$summerWe <- summerWe
  calendarReturn$summerWd <- summer[!summer%in%summerWe]
  
  #Exclude days not choose by user
  calendarReturn <- lapply(calendarReturn, function(X){
    X[!X%in%dayExclude]
  })
  
  if(length(unlist(calendarReturn)) == 0){
    stop("All periods are empty")
  }
  
  if(min(unlist(lapply(calendarReturn, length))) == 0){
    warning("One (or more) period defined is empty. Process like clusteringTypicalDays can't be run")
  }
  
  
  calendarReturn
}
