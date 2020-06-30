
#' Download n2ex Price and Volume Data
#' 
#' @description Download or update n2ex price, volume and exchange rate data from the n2ex FTP.
#' 
#' @author Jethro Browell, \email{jethro.browell@@strath.ac.uk}
#' @param path Path to folder for n2ex price and volume
#' @param userpwd Credentials for the n2ex FTP
#' @param years Which years (last two digits, only data from 2000s available) should be downloaded?
#' 
#' @details Files are downloaded if a local copy does not exisit. The file corresponding to the last
#' year in \code{years} is updated.
#' 
#' @import curl
#' @export
n2ex_price_vol_download <- function(path=paste0(get_credentials()$data_path,"n2ex_price_volume/"),
                                    h=new_handle(httpauth = 1, userpwd =get_credentials()$n2ex),
                                    years = 10:(year(Sys.Date())-2000)){
  
  list.files(path)
  
  for(year in years){
    
    ## Volume data
    new_file <- paste0("auction-turnover",year,".xls")
    if(!(new_file %in% list.files(path)) | year==tail(years,1) ){
      curl_download(paste0("ftp://n2ex.nordpoolspot.com/Auction/Auction_volumes/20",year,"/",new_file),
                    destfile = paste0(path,new_file),
                    handle = h)
    }
    
    # Price Data
    new_file <- paste0("auction-prices",year,".xls")
    if(!(new_file %in% list.files(path)) | year==tail(years,1) ){
      curl_download(paste0("ftp://n2ex.nordpoolspot.com/Auction/Auction_prices/20",year,"/",new_file),
                    destfile = paste0(path,new_file),
                    handle = h)
    }
    
    # Exchange Rate Data
    new_file <- paste0("ukrate20",year,".csv")
    if(!(new_file %in% list.files(path)) | year==tail(years,1) ){
      try1 <- try(curl_download(paste0("ftp://n2ex.nordpoolspot.com/Auction/Auction_currency/20",year,"/",new_file),
                                destfile = paste0(path,new_file),
                                handle = h),silent = T)
      if(class(try1)=="try-error" & year==tail(years,1)){
        try1 <- try(curl_download(paste0("ftp://n2ex.nordpoolspot.com/Auction/Auction_currency/",new_file),
                                  destfile = paste0(path,new_file),
                                  handle = h),silent = T)
      }
    }
    
    
  }
  
}

