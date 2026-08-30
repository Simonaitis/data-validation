USE [AdventureWorks2022];
GO

SELECT 
    v.CaseID,
    v.CaseDocketNumber,
    v.TotalCaseBalance AS HeaderReportedTotal,
    SUM(d.LineTotal) + v.StatutorySurcharges + v.ServiceFees AS DetailCalculatedTotal,
    (v.TotalCaseBalance - (SUM(d.LineTotal) + v.StatutorySurcharges + v.ServiceFees)) AS Variance
FROM dbo.vw_CourtCase_Registry v
INNER JOIN Sales.SalesOrderDetail d ON v.CaseID = d.SalesOrderID
WHERE v.CaseID IN (43659, 43660, 43661)
GROUP BY 
    v.CaseID, 
    v.CaseDocketNumber, 
    v.TotalCaseBalance, 
    v.StatutorySurcharges, 
    v.ServiceFees;
GO
