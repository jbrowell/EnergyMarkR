#' Download data from ENTSO-E Transparency Platform
#' 
#' @description Download or update a complete copy of files available on the entso-e transparency platform
#' for a given data item.
#' 
#' @author Jethro Browell, \email{jethro.browell@@strath.ac.uk}
#' @param data_item Name of data item. If \code{NULL}, a list of options is returned and saved to \code{path})
#' @param path Path to folder for entso-e data
#' @param userpwd Credentials for the entso-e transparency platform
#' @details This function downloads all data matching \code{data_item} from the entso-e transparency platform,
#' that are not already present in \code{path}. Files that are present but have not been updated since the end
#' of the time period that they correspond to will be updated. E.g. incomplete files for the present and/or past month
#' are typically available, and this function will update the local copy of them.
#' 
#' Further documentation may be found at \link{https://transparency.entsoe.eu/}.
#' 
#' @import curl
#' @import fasttime
#' @importFrom  lubridate month
#' @import data.table
#' @export
download_entso_e <- function(data_item=NULL,
                             path=paste0(get_credentials()$data_path,"entsoe_TP/"),
                             userpwd = get_credentials()$entso_e){
  
  
  h <- new_handle(httpauth = 1, userpwd =userpwd,
                  ftp_use_epsv = TRUE, dirlistonly = TRUE)
  
  
  if(is.null(data_item)){
    
    curl_download(url = "sftp://sftp-transparency.entsoe.eu/TP_export/",
                  destfile = paste0(path,"available_data_items.txt"),handle = h)
    
    return(readLines(con = paste0(path,"available_data_items.txt")))
  }
  
  
  ## Create directory
  if(!dir.exists(paste0(path,data_item))){
    dir.create(paste0(path,data_item))
  }
  
  ## Current files 
  current_files <- list.files(paste0(path,data_item))
  
  ## Remove file for given month if not updated after that month
  # Get year and month
  for(L in 0:2){
    
    current_files_y_m <- regmatches(current_files,regexpr(pattern = "20[0-9]{2}_([0-9]{1,2})",current_files))
    mod_date <- file.mtime(paste0(path,data_item,"/",current_files)) %m-% lubridate::months(L)
    mod_y_m <- gsub(pattern = "_0",replacement = "_",format(mod_date,"%Y_%m"))
    current_files <- current_files[-which(current_files_y_m==mod_y_m)]
    
  }
  
  ## Available files
  curl_download(url = paste0("sftp://sftp-transparency.entsoe.eu/TP_export/",data_item,"/"),
                destfile = paste0(path,data_item,"/avail_files.txt"),handle = h)
  avail_files <- readLines(paste0(path,data_item,"/avail_files.txt"))
  
  ## Download files not in directory
  for(f in avail_files[!(avail_files %in% c(current_files,"..","."))]){
    try(curl_download(url = paste0("sftp://sftp-transparency.entsoe.eu/TP_export/",data_item,"/",f),
                  destfile = paste0(path,data_item,"/",f),handle = h))
    
  }  
  
  unlink(paste0(path,data_item,"/avail_files.txt"))
}