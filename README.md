# healthcare-marketing-funnel-dashboard
Interactive Tableau dashboard analyzing healthcare marketing funnel performance, tracking CPL, CPA, ROI, and patient conversion rates with actionable insights.

## Project Overview
This project demonstrates how marketing and healthcare data can be integrated to measure efficiency across the full patient acquisition funnel — from impressions to completed appointments.  
I built an interactive Tableau dashboard that connects **campaign spend, CRM leads, and EHR appointment data** to highlight drop-offs, efficiency metrics, and ROI.  

## Key Features
- **Multi-source integration:** Combined simulated campaign spend, CRM leads, and EHR appointments.  
- **KPIs:** Cost per Lead (CPL), Cost per Appointment (CPA), ROI, Lead→Appointment conversion, Appointment→Completed conversion, and No-Show Rate.  
- **Visuals:** KPI tiles, funnel chart, bar charts by channel, and campaign efficiency breakdowns.  
- **Interactivity:** Time horizon parameter (past week, month, 90 days, year), campaign selector, and revenue-per-appointment slider for scenario modeling.  

## Insights
- **Display** was the most efficient channel, with the **lowest CPA** and **highest completed appointments**.  
- **Direct Mail** underperformed, driving the **highest CPA** and the **fewest completed appointments**.  
- Recommended reallocating spend away from Direct Mail toward more efficient channels like Display and Paid Search.  

## Tools & Tech
- **Tableau** – Data visualization and dashboard design  
- **Excel/CSV** – Fake data generation for campaign spend, leads, and appointments  
- **SQL / Python (optional)** – Scripts for generating and cleaning simulated data (included in repo if available)  

## Repository Contents
- `marketing_crm_leads.csv` – Simulated CRM leads dataset  
- `digital_campaigns.csv` – Simulated marketing campaign spend data  
- `ehr_appointments.csv` – Simulated EHR appointment outcomes  
- `patients_dim.csv` – Simulated patient demographics (optional)  
- `Healthcare_Marketing_Funnel_Dashboard.twbx` – Tableau packaged workbook  
- `Koval-Healthcare-Insights-Dashboard` – Exported dashboard screenshot (for quick view)  
- `README.md` – Project documentation  

## Dashboard Preview
<img width="999" height="792" alt="Koval-Healthcare-Insights-Dashboard" src="https://github.com/user-attachments/assets/b3fea3e0-305c-433d-8c26-b5d8bdd86557" />

## How to Use
1. Clone this repo or download the files.  
2. Open the Tableau packaged workbook (`.twbx`).  
3. Explore the dashboard by adjusting the time horizon, campaign selector, and revenue per appointment parameter.  

## Future Improvements
- Add service line analysis (e.g., cardiology vs. primary care) to measure clinical impact by specialty.
- Assess no-show rates and repeat customers to find value in long-term investments.
- Include trend views over time (weekly/monthly CPL and CPA).  
- Build predictive modeling for no-show risk segmentation.  

---
