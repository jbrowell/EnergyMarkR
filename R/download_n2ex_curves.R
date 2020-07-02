
#' Download n2ex Curve Data
#' 
#' @description Download or update n2ex buy and sell curves data from the n2ex FTP.
#' 
#' @author Jethro Browell, \email{jethro.browell@@strath.ac.uk}
#' @param path Path to folder for n2ex curve data
#' @param userpwd Credentials for the n2ex FTP
#' @param years Which years (last two digits, only data from 2000s available) should be downloaded?
#' 
#' @details Files are downloaded if a local copy does not exisit. The file corresponding to the last
#' year in \code{years} is updated.
#' 
#' @import curl
#' @importFrom data.table year
#' @export
download_n2ex_curves <- function(path=paste0(get_credentials()$data_path,"n2ex_auction_cross/"),
                                    h=new_handle(httpauth = 1, userpwd =get_credentials()$n2ex),
                                    years = 10:(year(Sys.Date())-2000)){
  
  ## Create directory
  if(!dir.exists(path)){
    dir.create(path)
  }
  
    # list.files(path)
  
  for(year in years){
   
    
    curl_download(url = paste0("ftp://n2ex.nordpoolspot.com/Auction/Auction_market_cross/20",year,"/"),
                  destfile = paste0(path,"avail_files.txt"),handle = h)
    avail_files <- read.table(paste0(path,"avail_files.txt"),header = F)$V9
    current_files <- list.files(path)
    
    for(new_file in avail_files[!(avail_files %in% current_files)]){
      try(curl_download(paste0("ftp://n2ex.nordpoolspot.com/Auction/Auction_market_cross/20",year,"/",new_file),
                    destfile = paste0(path,new_file),
                    handle = h))
    }
    
    unlink(paste0(path,"avail_files.txt"))
     
  }
  
}

