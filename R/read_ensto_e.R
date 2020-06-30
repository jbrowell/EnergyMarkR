#' Read ENTSO-E Data Files
#' 
#' @author Jethro Browell, \email{jethro.browell@@strath.ac.uk}
#' @param data_item Name of data item
#' @param path Path to folder for entso-e data
#' 
#' @details Further documentation may be found at \link{https://transparency.entsoe.eu/}.
#'   
#' @return A \code{data.table} of data from \code{path}, concatinated and ordered by column \code{DateTime}. 
#' 
#' @import data.table
#' @export
read_ensto_e <- function(data_item="DayAheadPrices",
                         path=paste0(get_credentials()$data_path,"/entsoe_TP/",data_item)){
  
  ## Load all csv
  temp_data <- data.table()
  for(f in list.files(path,full.names = T)){
    temp_data <- rbind(temp_data,
                       read.delim2(f,header=TRUE,encoding = "UTF-16",skipNul = T,stringsAsFactors = F))
  }
  
  ### Re-name due to issue with encoding... Not optimal...
  colnames(temp_data)[1] <- "Year"
  warning("First column being remaned to \"Year\".")
  
  temp_data[,DateTime:=fastPOSIXct(DateTime,tz = "UTC")]
  try(setkey(temp_data,"DateTime","AreaName"))
  
  return(temp_data)
  
}


