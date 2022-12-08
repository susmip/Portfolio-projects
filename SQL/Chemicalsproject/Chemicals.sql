
-- 1) Find out which chemicals were used the most in cosmetics and personal care products.

select ProductName,ChemicalName,PrimaryCategory,PrimaryCategoryId, SubCategory,ChemicalCount from PortfolioProjects..['chemicals-in-cosmetics-$']
where PrimaryCategoryId=74 or PrimaryCategoryId=44
order by ChemicalCount desc

with Chemicals as(
select ProductName,ChemicalName,PrimaryCategory,PrimaryCategoryId, SubCategory,ChemicalCount from PortfolioProjects..['chemicals-in-cosmetics-$']
where PrimaryCategoryId=74 or PrimaryCategoryId=44) select chemicalName, count(*) as countofChems from Chemicals group by ChemicalName order by countofChems desc

-- 2) Find out which companies used the most reported chemicals in their cosmetics and personal care products.


select CompanyName,chemicalname,count(chemicalName) as countChem from PortfolioProjects..['chemicals-in-cosmetics-$']
where PrimaryCategoryId=74 or PrimaryCategoryId=44
group by ChemicalName,companyName order by countChem desc

-- 3) Which brands had chemicals that were removed and discontinued? Identify the chemicals.
select distinct CompanyName,ProductName,chemicalname,DiscontinuedDate from PortfolioProjects..['chemicals-in-cosmetics-$'] 
where DiscontinuedDate is not NULL
ORDER BY ChemicalName desc


-- 4) Identify the brands that had chemicals which were mostly reported in 2018.


alter table PortfolioProjects..['chemicals-in-cosmetics-$']
add InitialDateReportedDate date

update PortfolioProjects..['chemicals-in-cosmetics-$']
set InitialDateReportedDate=convert(date,InitialDateReported)

select distinct BrandName,ChemicalName,InitialDateReportedDate from PortfolioProjects..['chemicals-in-cosmetics-$']
where InitialDateReportedDate>='20180101' and InitialDateReportedDate<'20181231' order by InitialDateReportedDate

-- 5) Which brands had chemicals discontinued and removed?

select distinct BrandName from PortfolioProjects..['chemicals-in-cosmetics-$']
where ChemicalDateRemoved is not NULL or DiscontinuedDate is not NULL

-- 6) Identify the period between the creation of the removed chemicals and when they were actually removed.

alter table PortfolioProjects..['chemicals-in-cosmetics-$']
add ChemicalCreatedAtDate date

update PortfolioProjects..['chemicals-in-cosmetics-$']
set ChemicalCreatedAtDate=convert(date,chemicalCreatedAt)

alter table PortfolioProjects..['chemicals-in-cosmetics-$']
add ChemicalRemovedDate date

update PortfolioProjects..['chemicals-in-cosmetics-$']
set ChemicalRemovedDate=convert(date,ChemicalDateRemoved)



select ChemicalName,datediff(day,ChemicalCreatedAtDate,ChemicalRemovedDate) as days from PortfolioProjects..['chemicals-in-cosmetics-$']
where ChemicalCreatedAtDate is not NULL and ChemicalRemovedDate is not NULL and ChemicalCreatedAtDate<ChemicalRemovedDate order by days


-- 7) Can you tell if discontinued chemicals in bath products were removed.

alter table PortfolioProjects..['chemicals-in-cosmetics-$']
add Discontinued date

update PortfolioProjects..['chemicals-in-cosmetics-$']
set Discontinued=convert(date,DiscontinuedDate)

select BrandName,ChemicalName,Discontinued,ChemicalRemovedDate,PrimaryCategory from PortfolioProjects..['chemicals-in-cosmetics-$'] 
where Discontinued is not NULL and ChemicalRemovedDate is not NULL
and PrimaryCategoryId=6


-- 8) How long were removed chemicals in baby products used? (Tip: Use creation date to tell)

with cte_baby as(select distinct ChemicalName,PrimaryCategory, ChemicalCreatedAtDate, ChemicalRemovedDate,DATEDIFF(day,ChemicalCreatedAtDate,ChemicalDateRemoved) 
as Chemicaluseperiod from PortfolioProjects..['chemicals-in-cosmetics-$']
where PrimaryCategory='Bath products')select * from cte_baby where 
Chemicaluseperiod  is NOT null and Chemicaluseperiod>0 order by Chemicaluseperiod desc


--9) Identify the relationship between chemicals that were mostly recently reported and discontinued. (Does most recently reported chemicals equal discontinuation of such chemicals?)
alter table PortfolioProjects..['chemicals-in-cosmetics-$']
add RecentReport date

update PortfolioProjects..['chemicals-in-cosmetics-$']
set RecentReport=convert(date,MostRecentDateReported)

select distinct ProductName,CompanyName,ChemicalName,RecentReport,Discontinued from PortfolioProjects..['chemicals-in-cosmetics-$']
where Discontinued is not NULL and RecentReport=Discontinued

-- 10) Identify the relationship between CSF and chemicals used in the most manufactured sub categories. (Tip: Which chemicals gave a certain type of CSF in sub categories?)

select CSF,SubCategory,count(*) as cnt from PortfolioProjects..['chemicals-in-cosmetics-$']
where CSF is not NULL
group by CSF,SubCategory
order by cnt desc