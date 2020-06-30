#' Function to set FTP/API credentials and set path to data
#' 
#' @description Set-up default credentials and folder/path for use by other functions in this package. 
#' 
#' @author Jethro Browell, \email{jethro.browell@@strath.ac.uk}
#' @param n2ex curl handle for the n2ex API
#' @param entso_e curl handle for the entso-e transparency platform
#' @param data_path Path to folder where data will be stored and read from. Used as default in other
#' functions in this package. Folder will be created if it doen't exist.
#' 
#' @details CURL handles sould be in format "username:password".
#' @return Saves file "~/gb_elec_creds.Rda" containing specified credentials.
#' @export
make_credentials <- function(n2ex=NULL,entso_e=NULL,data_path="~/EnergyMarkR_data/"){
  
  creds <- list(n2ex=paste0(n2ex),
                entso_e=paste0(entso_e),
                data_path=paste0(data_path))
  
  if(!dir.exists(data_path)){
    dir.create(data_path)
  }
  
  save(creds,
       file = "~/gb_elec_creds.Rda")
  
}


#' Functions to get FTP/API credentials
#' 
#' @description Get credentials from file created by \code{make_credentials}.
#' 
#' @author Jethro Browell, \email{jethro.browell@@strath.ac.uk}
#' @return A \code{list} of credentials.
#' @export
get_credentials <- function(){
  load("~/gb_elec_creds.Rda")
  return(creds)
}