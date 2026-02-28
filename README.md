# CBF_Retail_Analysis
Analysis of a UK High street retailer's data to extract insight on high value customers, their performance per region. This knowledge informs marketing investments/

**UK High Street Business Analysis Proposal**

**Scenario**: A UK high‑street retailer wants to improve customer retention and improve marketing efficiency. To do this, the business needs a better understanding of which customers deliver the most value and how it's different across regions. 

**Proposal Outline**:

**Goal**: Identify high‑value customers using RFM (Recency, Frequency, Monetary) modelling and uncover patterns of retention per region to support targeted marketing and customer‑health reporting.

**Data**: Public ecommerce datasets such as thelook_ecommerce. Containing primarily order, product, customer and order items tables.

**Methodology**: Using Visual Studio Code and PostgreSQL to join orders and customer data. Calculate RFM scores for each customer to segment them into value tiers. Analyse retention trends across UK regions

**Outcome**: A ranked list of high‑value customers based on RFM scoring. Clear insight into which regions show the strongest retention and which require intervention. A dashboard that monitors customer health, identifies churn risks, and guides targeted marketing strategies.

**Ethics**: Use only publicly available or synthetic datasets to avoid exposing real customer information. Maintain transparency in modelling decisions to prevent biased customer segmentation. 

**How to run the project**

1. Download the files to your local system.

2. Open the files in your choice platform such as Visual Studio (Note: Syntax was written in psql).

3. Create your schema by running the syntax in **Schema.sql**.

4. Import your data for each table from the csv tables using your graphical interface or the following psql command:
\copy retail.orders
FROM '/c/Users/YourName/Desktop/orders.csv'
DELIMITER ','
CSV HEADER;

**NB:** Data could not be uploaded becasue it is a large file. Sample data set can be gotten from: https://www.kaggle.com/code/chiraggivan82/thelook-ecommerce

**Only users, orders, products, and order_items table were used for this project**

5. When all the data has been inserted into the 4 schemas, run the code from the **data_cleaning.sql** file to organize the data necessary for this analysis.

6. Finally, go to the **analysis.sql** file to create the final analysis table to use for visualization.

7. Still in the **analysis.sql** file, the code syntax to view state/region retention data is below the analysis table. Run this code to see table that clearly explains region retention.

**Note:** ERD Diagram is included in this repository for clear understanding of project structure

**Project Visualisation Link:** https://lookerstudio.google.com/reporting/6c3cf36e-3ba2-40b4-9de8-6cdb30ad41f5
