#' Read n2EX Price and Volume Data
#' 
#' @author Jethro Browell, \email{jethro.browell@@strath.ac.uk}
#' @param path Path to folder for n2ex price and volume
#' @param years Which years (last two digits, only data from 2000s available) should be loaded?
#' 
#' @return A \code{data.table} of n2ex price, volume and exchange rate.
#' 
#' @import readxl
#' @import data.table
#' @export
read_n2ex_price_vol <- function(path=paste0(get_credentials()$data_path,"price_volume/"),years = 15:20){
  
  PriceData <- data.table()
  VolData <- data.table()
  ERData <- data.table()
  
  for(year in years){
    
    ## Price
    temp <- read_xls(paste0(path,"auction-prices",year,".xls"),range = "A6:Z400")
    temp2 <- rep(na.omit(c(t(as.matrix(temp[,-1])))),each=2)
    PriceData <- rbind(PriceData,
                       data.table(dtm=seq(as.POSIXct(as.matrix(temp[1,1]),
                                                     tz = "Europe/London")-60*60,
                                          length.out = length(temp2),by=30*60),
                                  n2ex=temp2))
    
    ## Volume
    if(file.exists(paste0(path,"auction-turnover",year,".xls"))){
      if(year==15){
        temp <- read_xls(paste0(path,"auction-turnover",year,".xls"),range = "A7:Z400")
      }else{
        temp <- read_xls(paste0(path,"auction-turnover",year,".xls"),range = "A6:Z400")  
      }
      
      temp2 <- rep(na.omit(c(t(as.matrix(temp[,-1])))),each=2)
      VolData <- rbind(VolData,
                       data.table(dtm=seq(as.POSIXct(as.matrix(temp[1,1]),
                                                     tz = "Europe/London")-60*60,
                                          length.out = length(temp2),by=30*60),
                                  n2ex_v=temp2))
    }
    
    ## Exchange Rate
    if(file.exists(paste0(path,"ukrate20",year,".csv"))){
      temp <- fread(paste0(path,"ukrate20",year,".csv"),skip = 9)
      temp[,date:=as.Date(V6,format="%d.%m.%Y")]
      temp[,Euro_rate:=V8]
      
      temp2 <- data.table(dtm=temp[,seq(as.POSIXct(as.character(min(date)),tz ="Europe/Paris"),
                                        as.POSIXct(as.character(max(date)+1),tz="Europe/Paris")-30*60,
                                        by=60*30)])
      temp2[,date:=as.Date(dtm,tz="Europe/Paris")]
      temp2 <- merge(temp2,temp[,.(date,Euro_rate)],by="date")
      
      ERData <- rbind(ERData,temp2[,.(dtm,Euro_rate)])
    }
    
  }
  
  PriceData <- merge(PriceData,VolData,by="dtm",all = T)
  PriceData <- merge(PriceData,ERData,by="dtm",all = T)
  
  return(PriceData)
}