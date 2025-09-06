# Healthcare Marketing Funnel — Fake Data Generator (R)
# Creates: digital_campaigns.csv, marketing_crm_leads.csv, ehr_appointments.csv, patients_dim.csv

set.seed(42)

library(dplyr)

N_PATIENTS <- 1200
N_CAMPAIGNS <- 8
START <- as.Date("2024-08-01")
END   <- as.Date("2025-07-31")
DAYS  <- as.integer(END - START) + 1

service_lines <- c("Primary Care","Cardiology","Oncology","Orthopedics","Pediatrics","Dermatology","Endocrinology")
channels <- data.frame(
  channel = c("Paid Search","Paid Social","Display","Email","Organic Search","Referral","Direct Mail","Retargeting"),
  vendor  = c("Google Ads","Meta","Programmatic","SFMC","SEO","Affiliate","Mailhouse","Web Pixel"),
  stringsAsFactors = FALSE
)

rand_date <- function() START + sample(0:(DAYS-1), 1)

make_id <- function(prefix, n=8) {
  chars <- c(LETTERS, 0:9)
  paste0(prefix, paste0(sample(chars, n, replace=TRUE), collapse=""))
}

# Patients
patients <- data.frame(
  patient_id = replicate(N_PATIENTS, make_id("P")),
  age = pmin(pmax(round(rnorm(N_PATIENTS, 46, 18)), 0), 95),
  sex = sample(c("F","M","Other","Unknown"), N_PATIENTS, replace=TRUE, prob=c(0.53,0.44,0.02,0.01)),
  zip3 = sample(c(535,537,539,541,543,545), N_PATIENTS, replace=TRUE, prob=c(0.25,0.35,0.15,0.10,0.10,0.05)),
  prior_no_shows_12mo = rpois(N_PATIENTS, lambda=0.25),
  stringsAsFactors = FALSE
)

# Campaigns
campaigns <- lapply(0:(N_CAMPAIGNS-1), function(i) {
  ch <- channels$channel[(i %% nrow(channels)) + 1]
  vd <- channels$vendor[(i %% nrow(channels)) + 1]
  c_start <- START + as.integer(i * (DAYS/(N_CAMPAIGNS+1)))
  c_end <- min(END, c_start + as.integer(DAYS*0.6))
  impressions <- sample(80000:600000, 1)
  clicks <- rbinom(1, impressions, runif(1, 0.005, 0.02))
  spend <- round(runif(1, 12000, 120000), 2)
  leads <- rbinom(1, clicks, runif(1, 0.02, 0.08))
  data.frame(
    campaign_id = make_id("C"),
    campaign_name = paste(ch, "-", vd, "-", i+1),
    channel = ch,
    vendor = vd,
    start_date = c_start,
    end_date = c_end,
    impressions = impressions,
    clicks = clicks,
    spend = spend,
    leads_generated = leads,
    stringsAsFactors = FALSE
  )
}) %>% bind_rows()

# CRM Leads
crm <- do.call(rbind, lapply(1:nrow(campaigns), function(i){
  n_leads <- campaigns$leads_generated[i]
  if (n_leads == 0) return(data.frame())
  pool <- sample(patients$patient_id, n_leads, replace=TRUE)
  do.call(rbind, lapply(pool, function(pid){
    engagement <- max(0, min(100, round(rnorm(1, 55, 20))))
    prior_ns <- patients$prior_no_shows_12mo[match(pid, patients$patient_id)]
    base_p <- 0.12 + (engagement - 50)/1000
    penalty <- min(0.06, 0.02*prior_ns)
    p_conv <- min(0.35, max(0.02, base_p - penalty))
    converted <- runif(1) < p_conv
    booked <- if (converted) as.Date(rand_date() + sample(1:29,1)) else as.Date(NA)
    data.frame(
      lead_id = make_id("L"),
      patient_id = pid,
      campaign_id = campaigns$campaign_id[i],
      lead_date = as.Date(rand_date()),
      engagement_score = engagement,
      converted_to_appointment = as.integer(converted),
      booked_appt_date = booked,
      stringsAsFactors = FALSE
    )
  }))
}))

# EHR Appointments
conv <- crm %>% filter(converted_to_appointment == 1)
appt_rows <- lapply(1:nrow(conv), function(i){
  prior_ns <- patients$prior_no_shows_12mo[match(conv$patient_id[i], patients$patient_id)]
  risk <- 0.06 + 0.02*prior_ns + max(0, (50 - conv$engagement_score[i]) / 400)
  outcome <- sample(c("Completed","No-Show","Cancelled"), 1, prob=c(1-risk, min(risk*0.7,0.25), min(risk*0.3,0.15)))
  data.frame(
    appointment_id = make_id("A"),
    patient_id = conv$patient_id[i],
    appointment_date = conv$booked_appt_date[i],
    service_line = sample(service_lines, 1, prob=c(0.28,0.12,0.08,0.18,0.12,0.12,0.10)),
    appointment_type = sample(c("New","Follow-up"), 1, prob=c(0.7,0.3)),
    outcome = outcome,
    appointment_source = "Campaign",
    campaign_id = conv$campaign_id[i],
    stringsAsFactors = FALSE
  )
}) %>% bind_rows()

# Background appointments
n_bg <- as.integer(nrow(appt_rows) * 1.6)
bg <- lapply(1:n_bg, function(i){
  data.frame(
    appointment_id = make_id("A"),
    patient_id = sample(patients$patient_id, 1),
    appointment_date = as.Date(rand_date()),
    service_line = sample(service_lines, 1, prob=c(0.34,0.10,0.06,0.18,0.14,0.10,0.08)),
    appointment_type = sample(c("New","Follow-up"), 1, prob=c(0.45,0.55)),
    outcome = sample(c("Completed","No-Show","Cancelled"), 1, prob=c(0.83,0.10,0.07)),
    appointment_source = sample(c("Organic","Referral"),1),
    campaign_id = NA,
    stringsAsFactors = FALSE
  )
}) %>% bind_rows()

ehr <- bind_rows(appt_rows, bg) %>%
  left_join(patients %>% select(patient_id, prior_no_shows_12mo, age, sex, zip3), by="patient_id")

# Write files
write.csv(campaigns, "digital_campaigns.csv", row.names=FALSE)
write.csv(crm, "marketing_crm_leads.csv", row.names=FALSE)
write.csv(ehr, "ehr_appointments.csv", row.names=FALSE)
write.csv(patients, "patients_dim.csv", row.names=FALSE)

cat("Wrote digital_campaigns.csv, marketing_crm_leads.csv, ehr_appointments.csv, patients_dim.csv\n")
