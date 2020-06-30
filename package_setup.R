### StrathCast Extended Example
require(devtools)
require(roxygen2)
require(rstudioapi)

PackagePath <- dirname(getActiveDocumentContext()$path)
setwd(PackagePath)

# Update package documentation
document(pkg = ".")
# Install from local repository
install(PackagePath)
# Load Package
require(EnergyMarkR)