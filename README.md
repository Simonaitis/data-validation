# Court Data Reporting & SQL Validation Lab

Set up a local SQL Server 2022 (Ubuntu 22.04 LTS) environment to test report design, parameter filtering, and data validation using "court style" records.

## Background & Challenges
Directly querying production tables in reporting tools (such as Crystal Reports or SSRS) often causes slow performance and table locks.

## Technical Setup

### 1. Data Access Layer (`/sql/01_court_reporting_views.sql`)
* **`dbo.vw_CourtCase_Registry`**: Wraps core case and party details into a clean view. Decouples report design from raw table changes and uses `ISNULL` to handle missing party names cleanly.
* **`dbo.sp_CourtCase_GetFilingFees`**: Parameterized stored procedure (`@CaseID`) built for sub-reports. Enforces strict input types and avoids heavy table scans.

### 2. Audit & QA Verification (`/sql/02_qa_data_reconciliation.sql`)
* Wrote a quick QA reconciliation script to cross-check header balances against itemized fee totals.
* Confirms `TotalDue` equals `SUM(LineTotal) + Surcharges + Fees` to ensure **$0.00 variance** before any report goes live.

## Validation Query Output

```text
CaseID  CaseDocketNumber  HeaderReportedTotal  DetailCalculatedTotal  Variance
43659   SO43659           20565.6234           20565.6234             0.0000
43660   SO43660           1294.2529            1294.2529              0.0000
43661   SO43661           32726.8942           32726.8942             0.0000
```
