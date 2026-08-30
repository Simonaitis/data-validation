USE [AdventureWorks2022];
GO

CREATE OR ALTER VIEW dbo.vw_CourtCase_Registry AS
SELECT 
    soh.SalesOrderID AS CaseID,
    soh.SalesOrderNumber AS CaseDocketNumber,
    soh.OrderDate AS FilingDate,
    soh.DueDate AS HearingDate,
    soh.Status AS CaseStatusCode,
    c.CustomerID AS PartyID,
    c.AccountNumber AS CourtControlNumber,
    ISNULL(p.FirstName + ' ' + p.LastName, 'Corporate/State Entity') AS PrimaryPartyName,
    soh.SubTotal AS BaseFilingFees,
    soh.TaxAmt AS StatutorySurcharges,
    soh.Freight AS ServiceFees,
    soh.TotalDue AS TotalCaseBalance
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
LEFT JOIN Person.Person p ON c.PersonID = p.PersonID;
GO

CREATE OR ALTER PROCEDURE dbo.sp_CourtCase_GetFilingFees
    @CaseID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        sod.SalesOrderID AS CaseID,
        sod.SalesOrderDetailID AS AssessmentID,
        sod.OrderQty AS FeeQuantity,
        sod.ProductID AS FeeCodeID,
        p.Name AS FeeDescription,
        p.ProductNumber AS FeeStatuteCode,
        sod.UnitPrice AS StandardFeeAmount,
        sod.UnitPriceDiscount AS StatutoryWaiver,
        sod.LineTotal AS NetFeeAssessed
    FROM Sales.SalesOrderDetail sod
    INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
    WHERE sod.SalesOrderID = @CaseID;
END;
GO
