attach(APIS_PUF_2019_Person)
View(APIS_PUF_2019_Person)
data <- APIS_PUF_2019_Person[c(-2:-4,-10, -16:-17,-23:-24)] #Remove unnecessary data


library(dplyr)
#Rename Columns
data <- data %>% 
  rename("Sex" = "C04_SEY", "Age" = "C05_AGF","Marital_Stat" = "C06_STATUS", "Attend_preschool" = "C08_PRE_PRIM",
                        "Attending_school" = "C09_CUR_ATTEND", "Reason_not_attending" = "C11_YNOT_ATTND",
                        "Highest_educational_attainment" = "C13_HGC", "Work" = "C14_DID_WORK", "Class_worker" = "C15_CLS_WKR",
                        "Ill/injured" = "C16_ILL", "Has_bank_account" = "C20_BANK_ACCT", "Has_voucher" = "C22_VOUCHER", "SUC/LUC" = "C23_A", 
                        "TES" = "C23_B","Student_Loan" = "C23_C")
#Change NA to 0
data$Reason_not_attending[is.na(data$Reason_not_attending)] <- 0 #Unknown status


#Remove observations that already graduated in Reasons on not attending school
data <- filter(data, Reason_not_attending != "06")

#Change values in Reason not attending to 12 which means they are still in school
data$Reason_not_attending[data$Attending_school == 1] <- "12"
data$Reason_not_attending[data$Attending_school == 2] <- "12"
data$Reason_not_attending[data$Attending_school == 3] <- "12"

#Change values 1 if attending school and 0 if not
data$Attending_school[data$Attending_school == 2] <- 1 #Still attending
data$Attending_school[data$Attending_school == 3] <- 1 #Still attending
data$Attending_school[data$Attending_school == 4] <- 0 #Not attending

#Remove NA in specific columns
library(tidyr)
data <- data %>% drop_na(Attending_school)
data <- data %>% drop_na(Work)

#Change values for NA in some column
data$Has_voucher[is.na(data$Has_voucher)] <- 3 #Did not avail for shs voucher since they are young
data$Has_bank_account[is.na(data$Has_bank_account)] <- 4 #Unknown status
data$Student_Loan[is.na(data$Student_Loan)] <- "0" #Did not avail

data$Student_Loan[data$Student_Loan == 'TRUE'] <- "1" #Did avail for loans
data$`SUC/LUC`[is.na(data$`SUC/LUC`)] <- 0 #Did not avail for SUC/LUC
data$TES[is.na(data$TES)] <- 0 #Did not avail for TES
data$TES[data$TES == 2] <- 1 #Did avail for TES

data$Class_worker[data$Work == 2] <- 7 #Not working

View(data)

library(writexl)
write_xlsx(data, "C:\\Users\\jonar\\Downloads\\cleaned_data.xlsx")



