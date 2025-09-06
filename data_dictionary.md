
# Data Dictionary (Fake Data for Tableau Portfolio Project)

## digital_campaigns.csv
- campaign_id: Unique ID for the marketing campaign
- campaign_name: Readable name (Channel - Vendor - sequence)
- channel: Marketing channel (Paid Search, Email, etc.)
- vendor: System or vendor (Google Ads, SFMC, etc.)
- start_date, end_date: Campaign flight dates (YYYY-MM-DD)
- impressions: Total ad impressions
- clicks: Total ad clicks
- spend: Total media cost (USD)
- leads_generated: Number of CRM leads attributed to the campaign

## marketing_crm_leads.csv
- lead_id: Unique ID for the CRM lead
- patient_id: Foreign key to patients_dim
- campaign_id: Foreign key to digital_campaigns
- lead_date: Lead creation date (YYYY-MM-DD)
- engagement_score: 0-100 score; higher = more engaged
- converted_to_appointment: 1 if a booking occurred, else 0
- booked_appt_date: If converted, the appointment date (YYYY-MM-DD)

## ehr_appointments.csv
- appointment_id: Unique appointment ID
- patient_id: Foreign key to patients_dim
- appointment_date: Date of the appointment (YYYY-MM-DD)
- service_line: Clinical area (Primary Care, Cardiology, etc.)
- appointment_type: New or Follow-up
- outcome: Completed, No-Show, or Cancelled
- appointment_source: Campaign, Organic, or Referral
- campaign_id: Populated only when appointment_source == "Campaign"
- prior_no_shows_12mo: Count of prior no-shows in last 12 months
- age, sex, zip3: Light demographics for segmentation

## patients_dim.csv
- patient_id: Unique patient identifier
- age: Age in years
- sex: F, M, Other, Unknown
- zip3: First 3 digits of ZIP (regional grouping)
- prior_no_shows_12mo: Count of prior no-shows for risk features
