library(testthat)
library(digest)
library(dplyr)

dictionary <- function(var) {
r <- c("Age of the major income earner in the family unit.", "PAGEMIEG")
r <- rbind(r,c("price of property", "PASRCST"))
r <- rbind(r,c("interest rate", "PASRINTG"))
r <- rbind(r,c("What is the total credit limit on all credit card(s) that you (and your family) own?", "PATTCRLM"))
r <- rbind(r,c("expected change in total income", "PATTSTIN"))
r <- rbind(r,c("have a business", "PBUSIND"))
r <- rbind(r,c("Highest level of education of the major income earner.", "PEDUCMIE"))
r <- rbind(r,c("after-tax-income", "PEFATINC"))
r <- rbind(r,c("government transfers", "PEFGTR"))
r <- rbind(r,c("Major source of income for the family unit.", "PEFMJSIF"))
r <- rbind(r,c("market income. Also, income before taxes and government transfers.", "PEFMTINC"))
r <- rbind(r,c("Amount of mortgage payments", "PEXMG1A"))
r <- rbind(r,c("Frequency of mortgage payment", "PEXMG1F"))
r <- rbind(r,c("Number of members in the family unit, all ages", "PFSZ"))
r <- rbind(r,c("Presence of persons in the family of age 65 and up", "PFSZ65UP"))
r <- rbind(r,c("Principal residence ownership status", "PFTENUR"))
r <- rbind(r,c("Total value of inheritances received in 2016 constant dollars", "PINHERT"))
r <- rbind(r,c("Major income earner in the family usually works 30 hours or more per week", "PLFCHRME"))
r <- rbind(r,c("Major income earner in the family worked either full time or part-time (in 2018)", "PLFFPTME"))
r <- rbind(r,c("Major income earner in the family is either a paid worker or self employed", "PLFPDMEG"))
r <- rbind(r,c("Number of earners aged 15 or over in the family unit", "PNBEARG"))
r <- rbind(r,c("Province of residence for the family unit", "PPVRES"))
r <- rbind(r,c("Region of residence of the family unit", "PREGION"))
r <- rbind(r,c("Indicates if the major income earner has ever retired", "PRETIRME"))
r <- rbind(r,c("Gender of the major income earner in the family unit", "PGDRMIE"))
r <- rbind(r,c("Other retirement funds", "PWAOTPEN"))
r <- rbind(r,c("Value of the principal residence", "PWAPRVAL"))
r <- rbind(r,c("Value of all employer pension plans", "PWARPPG"))
r <- rbind(r,c("Registered retirement income funds (RRIFs)", "PWARRIF"))
r <- rbind(r,c("RRSP investments including locked in RRSP’s", "PWARRSPL"))
r <- rbind(r,c("Bonds, non-registered", "PWASTBND"))
r <- rbind(r,c("Money in banks, non-registered", "PWASTDEP"))
r <- rbind(r,c("Mutual funds, other investment, Income trusts, non-registered", "PWASTMUI"))    
r <- rbind(r,c("Other investments or financial assets", "PWASTOIN"))     
r <- rbind(r,c("Other non-financial assets", "PWASTONF"))     
r <- rbind(r,c("Real estate other than principal residence", "PWASTRST"))     
r <- rbind(r,c("Stocks and shares, non registered", "PWASTSTK"))     
r <- rbind(r,c("Total of vehicles (cars, trucks and vans and other vehicles)", "PWASTVHE"))
r <- rbind(r,c("Tax Free Saving Accounts (TFSA)", "PWATFS"))
r <- rbind(r,c("Total assets including employer pension plans - On going concern basis", "PWATOTPG"))
r <- rbind(r,c("Equity value of businesses operated by the family unit", "PWBUSEQ"))
r <- rbind(r,c("Mortgage on principal residence, final value", "PWDPRMOR"))
r <- rbind(r,c("Debt value of student loans", "PWDSLOAN"))
r <- rbind(r,c("Credit card and installment debt", "PWDSTCRD"))
r <- rbind(r,c("What is the total credit limit on all line(s) of credit that you (and your family) own?", "PATTLMLC"))
r <- rbind(r,c("Line-of-credit debt (home and other line of credit)", "PWDSTLOC"))    
r <- rbind(r,c("Total of other debt (other loans from financial instituitions and other money owed)", "PWDSTODB"))     
r <- rbind(r,c("Mortgages on ’other real estate’ in and outside of Canada", "PWDSTOMR"))       
r <- rbind(r,c("Debt on vehicles", "PWDSTVHN"))
r <- rbind(r,c("Total of all debts for the family", "PWDTOTAL"))
r <- rbind(r,c("Networth of the family unit. (On going concern basis)", "PWNETWPG"))
r <- rbind(r,c("Year property was purchased", "PASRBUYG"))
r = as.data.frame(r)
r= r %>% filter_all(any_vars(. %in% c(toupper(var))))

return(r[1,1])
}


clean_up_sfs <- function(SFS_data){

SFS_data <- filter(SFS_data, !is.na(SFS_data$pefmtinc))

SFS_data <- rename(SFS_data, income_before_tax = pefmtinc)
SFS_data <- rename(SFS_data, income_after_tax = pefatinc)
SFS_data <- rename(SFS_data, wealth = pwnetwpg)
SFS_data <- rename(SFS_data, gender = pgdrmie)
SFS_data <- rename(SFS_data, education = peducmie)
SFS_data <- rename(SFS_data, business = pbusind)
SFS_data <- rename(SFS_data, province = ppvres)
SFS_data <- rename(SFS_data, credit_limit = pattlmlc)
SFS_data <- rename(SFS_data, age = pagemieg)
SFS_data <- rename(SFS_data, employment = plffptme)

SFS_data<-SFS_data[!(SFS_data$education=="9"),]
SFS_data$education <- as.numeric(SFS_data$education)
SFS_data <- SFS_data[order(SFS_data$education),]
SFS_data$education <- as.character(SFS_data$education)
SFS_data$education[SFS_data$education == "1"] <- "Less than high school"
SFS_data$education[SFS_data$education == "2"] <- "High school"
SFS_data$education[SFS_data$education == "3"] <- "Non-university post-secondary"
SFS_data$education[SFS_data$education == "4"] <- "University"

SFS_data$province[SFS_data$province == "10"] <- "Newfoundland and Labrador"
SFS_data$province[SFS_data$province == "11"] <- "Prince Edward Island"
SFS_data$province[SFS_data$province == "12"] <- "Nova Scotia"
SFS_data$province[SFS_data$province == "13"] <- "New Brunswick"
SFS_data$province[SFS_data$province == "24"] <- "Quebec"
SFS_data$province[SFS_data$province == "35"] <- "Ontario"
SFS_data$province[SFS_data$province == "46"] <- "Manitoba"
SFS_data$province[SFS_data$province == "47"] <- "Saskatchewan"
SFS_data$province[SFS_data$province == "48"] <- "Alberta"
SFS_data$province[SFS_data$province == "59"] <- "British Columbia"

SFS_data$employment[SFS_data$employment == "1"] <- "Full-time"
SFS_data$employment[SFS_data$employment == "2"] <- "Part-time"
SFS_data$employment[SFS_data$employment == "3"] <- "Did not work"
SFS_data$employment[SFS_data$employment == "6"] <- NA
SFS_data$employment[SFS_data$employment == "9"] <- NA

SFS_data$pasrbuyg[SFS_data$pasrbuyg == 96] <- NA

SFS_data$gender <- as_factor(SFS_data$gender)
SFS_data$education <- as_factor(SFS_data$education)
SFS_data$business <- as_factor(SFS_data$business)
SFS_data$province <- as_factor(SFS_data$province)
SFS_data$age <- as_factor(SFS_data$age)
SFS_data$employment <- as_factor(SFS_data$employment)
SFS_data$pasrbuyg <- as_factor(SFS_data$pasrbuyg)

SFS_data$financial_asset <- SFS_data$pwastbnd + SFS_data$pwastdep + SFS_data$pwastmui + SFS_data$pwastoin + SFS_data$pwaststk
SFS_data$risk_proxy <- SFS_data$pwaststk/SFS_data$financial_asset
SFS_data <- rename(SFS_data, stock = pwaststk)
    
}


### Self-tests

test_1 <- function() {
  test_that("Solution is incorrect", {
    expect_equal(digest(answer1), 'f7b0db1c9bc01deadcdde41033af1311')
  })
  print("Success!")
}

test_2 <- function() {
  test_that("Solution is incorrect", {
    expect_equal(digest(reg_LESS), '7df21fa8ed0617285e8f4a1071595394')
  })
  print("Success!")
}


test_2.5 <- function() {
  test_that("Solution is incorrect", {
    expect_equal(digest(reg_HS), '0c50f758ff8cb68a030401ac6de4939d')
  })
  print("Success!")
}

test_3 <- function() {
  test_that("Solution is incorrect", {
    expect_equal(digest(reg_NU), '0b3c41dd1005a2e67e6ef5def14ea4d3')
  })
  print("Success!")
}


test_3.5 <- function() {
  test_that("Solution is incorrect", {
    expect_equal(digest(reg_U), 'd8d479e699e3e829e0b01f136950bf8b')
  })
  print("Success!")
}

test_4 <- function() {
  test_that("Solution is incorrect", {
    expect_equal(digest(reg2), '7950a021dd4e1c7607b643cf1893c378')
  })
  print("Success!")
}

test_5 <- function() {
  test_that("Solution is incorrect", {
    expect_equal(digest(reg3), 'cc2e2abc7b2a9eac38cc98cf04245bcb')
  })
  print("Success!")
}

test_5.5 <- function() {
  test_that("Solution is incorrect", {
    expect_equal(digest(reg4), '7c718247447f90b495dc08c5bdf05c50')
  })
  print("Success!")
}
test_6 <- function() {
  test_that("Solution is incorrect", {
    expect_equal(digest(reg5), 'df498e271a443c91d940e4349b475294')
  })
  print("Success!")
}
