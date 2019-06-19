# Load Packages
library("tidyverse")

# Import Data 
elec_sales <- read.csv("refine_original.csv", fileEncoding ="UTF-8-BOM")

# Preview Data
view(elec_sales)

# Clean Brand Names 
elec_sales$company <- tolower(elec_sales$company)

elec_sales$company <- sub(pattern = ".*\\ps$", "philips", x = elec_sales$company)
elec_sales$company <- sub(pattern = "^ak.*", replacement = "akzo", x = elec_sales$company)
elec_sales$company <- sub(pattern = "^u.*", replacement = "unilever", x = elec_sales$company)

# Seperate Product Code and Number
elec_sales <- elec_sales %>% 
  separate(Product.code...number, c("Product Code", "Product Number"), sep = "-")

# Add Product Categories 
elec_sales$product_category <- sub(pattern = "^p$", replacement = "Smartphone",
                                   x = sub("^x$", "Laptop", 
                                       sub("^v$", "TV", 
                                       sub("^q$", "Tablet", elec_sales$`Product Code`))))

# Add Full Addresses for Geocoding
elec_sales <- mutate(elec_sales,full_address = paste(elec_sales$address, elec_sales$city, elec_sales$country))

# Add Dummy Variables for Company and Product Category
elec_sales <- mutate(elec_sales, company_philips = ifelse(company == "philips", 1, 0))
elec_sales <- mutate(elec_sales, company_akzo = ifelse(company == "akzo", 1, 0))
elec_sales <- mutate(elec_sales, company_van_houten = ifelse(company == "van houten", 1, 0))
elec_sales <- mutate(elec_sales, company_unilever = ifelse(company == "unilever", 1, 0))

elec_sales <- mutate(elec_sales, product_smartphone = ifelse(product_category == "Smartphone", 1, 0))
elec_sales <- mutate(elec_sales, product_tv = ifelse(product_category == "TV", 1, 0))
elec_sales <- mutate(elec_sales, product_laptop = ifelse(product_category == "Laptop", 1, 0))
elec_sales <- mutate(elec_sales, product_tablet = ifelse(product_category == "Tablet", 1, 0))

# Preview Clean Data
view(elec_sales)

# Export to CSV File
write.table(elec_sales, "refine_clean.csv", sep = ",")



