# load scrape function
# source("f_scrape_WB-OKR.R")
# Created by https://github.com/transteph/world-bank-document-scraping

# WB's INSTRUCTIONS --------------------------------------------------------------------
# Structured metadata for OKR content is exposed according to the OAI-PMH (Open Archives Initiative Protocol for Metadata Harvesting) protocol.
# WBG: HARVESTING METADATA OF PUBLICATIONS WITHIN A COLLECTION
# https://openknowledge.worldbank.org/pages/harvesting-the-okr-en
#       - there is a limit of 100 results per query
#       - to harvest results exceeding this, make use of the ***resumption token***.


# General Variables ---------------------------------------------------------------
 # # base url for query
 # base <- "https://openknowledge.worldbank.org/oai/request?verb=ListRecords&metadataPrefix=oai_dc&set=col_10986_"
 # # base url with resumption token
 # base0 <- "https://openknowledge.worldbank.org/oai/request?verb=ListRecords&resumptionToken=oai_dc///col_10986_"
 #


# Function ----------------------------------------------------------------
# r <- createDT('r', cat0,  subcat, base, base0, subid, n)
# Returns data table with meta data of all docs within subcategory
#
# collect = collection                        # EXE: (suo interno "a")
# cat0 = subcategory                          # EXE: (suo interno "1")
# base = base URL                             # EXE: see above
# base0 = base URL with renumeration token    # EXE: see above
# subid = subcategory id                    * # EXE: "2124" (WDRs)
# n = number of total docs                  * # EXE: 45 (n  WDRs)



createDT <- function (collect, cat0, subcat, base, base0, subid, n) {

## STEP 1 ----------------------------------------------------------------
temp_url <- paste0(base, temp_id)

## STEP 2 ----------------------------------------------------------------
# retrieve metadata first 100 docs
rr <- httr::GET(temp_url) # xml_document
rr <- httr::content(rr, as="parsed")

# each page lists 100, so find how many pages to look through
num_cycles <- (ceiling(n / 100) - 1)
# print(paste("num_cycles:", num_cycles))

## STEP 3 ----------------------------------------------------------------
# If more than 100 items (that fit 1 page)
if (num_cycles > 0){
  # url for queries past first 100 docs
  temp_url0 <- paste0(base0, subid)
  # cycle through rest of listings
  # return list of metadata from each page
  for (pp in 1:num_cycles){
    # print(paste("cycle #", pp))
    pg_num = pp * 100
    # print(paste("pg_num:", pg_num))
    s <- GET(paste0(temp_url0, "/", pg_num))
    #  print(paste("url:", paste0(temp_url0, "/", pg_num)))
    s <-content(s, as="parsed")

    to_add <- xml2::xml_children(s) # returns only elements,

    query <- for (child in to_add) {
      xml2::xml_add_child(rr, child) # insert a node
    }
  }
}

## STEP 4 ----------------------------------------------------------------
# check length of id
r_id <-  xml_find_all(rr, ".//d1:identifier") %>% xml_text()
l <- length(r_id)
print(paste("length of total list:", l))

# put metadata into data table
if (cat0 == 1){
  z_category = "WDR"
} else if (cat0 == 2){
  z_category = "WDR Working Papers"
}  else if (cat0 == 3){
  z_category = "Other"
}

z_id   = xml_find_all(rr, ".//d1:identifier") %>% xml_text()
z_title = xml_find_all(rr, ".//dc:title" ) %>% xml_text()
z_subject = xml_find_all(rr, ".//dc:subject" ) %>% xml_text()

z_abstract = xml_find_all(rr, ".//dc:description") %>% xml_text() %>% str_squish()
z_date  = xml_find_all(rr, ".//dc:date[3]") %>% xml_text()
z_language  = xml_find_all(rr, ".//dc:language") %>% xml_text()


r <- data.table(
  "category" = z_category,
  "subcategory" = subcat,
  'id' = z_id[1:l],
  'title' = z_title[1:l],
  'subject' = z_subject[1:l],
  'abstract'= z_abstract[1:l],
  'date'  = z_date[1:l],
  'language' = z_language[1:l],

  stringsAsFactors = FALSE )

print(paste("blank cells:", sum(is.na(r))))

# add to worksheet

# Add some sheets to the workbook
addWorksheet(OUT, paste0(collect, subcat))

# Write the data to the sheets
writeDataTable(OUT, sheet = paste0(collect, subcat), x = r)

print(paste0("Worksheet ", collect, subcat, " added"))

return (r)

}



