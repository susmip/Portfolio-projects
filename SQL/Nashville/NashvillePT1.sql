select * from PortfolioProjects..NashvilleHousing

-- standardize file format
select Saledate,convert(date,saledate)
from PortfolioProjects..NashvilleHousing

update NashvilleHousing
set SaleDate=convert(date,saledate)

alter table NashvilleHousing 
add Saledate_converted date

update NashvilleHousing
set Saledate_converted=convert(date,saledate)

-- populate property address date
select *
from PortfolioProjects..NashvilleHousing 
--where PropertyAddress is null
order by ParcelID

select a.parcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProjects..NashvilleHousing a
join PortfolioProjects..NashvilleHousing b
on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is NULL

update a
set PropertyAddress=isnull(a.propertyAddress,b.PropertyAddress)
from PortfolioProjects..NashvilleHousing a
join PortfolioProjects..NashvilleHousing b
on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is NULL


select PropertyAddress from PortfolioProjects..NashvilleHousing
order by ParcelID

-- delimiters

select 
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as lane
from PortfolioProjects..NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255)

update NashvilleHousing
set PropertySplitAddress=substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertyCity Nvarchar(255)

update NashvilleHousing
set PropertyCity=substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

select * from PortfolioProjects..NashvilleHousing

select OwnerAddress from PortfolioProjects..NashvilleHousing
