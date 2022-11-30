select * from PortfolioProjects..NashvilleHousing

select PARSENAME(REPLACE(OwnerAddress,',','.'),3) as address ,
PARSENAME(REPLACE(OwnerAddress,',','.'),2) as area,
PARSENAME(REPLACE(OwnerAddress,',','.'),1) as state
from PortfolioProjects..NashvilleHousing


alter table PortfolioProjects..NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

update PortfolioProjects..NashvilleHousing
set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

alter table PortfolioProjects..NashvilleHousing
add OwnerSplitCity Nvarchar(255)

update PortfolioProjects..NashvilleHousing
set OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

alter table PortfolioProjects..NashvilleHousing
add OwnerSplitState Nvarchar(255)

update PortfolioProjects..NashvilleHousing
set OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select * from PortfolioProjects..NashvilleHousing

select distinct SoldAsVacant,count(SoldAsVacant) as cnt
from PortfolioProjects..NashvilleHousing
group by SoldAsVacant
order by cnt


-------replacing y with yes and n with n using case

select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end SoldAsVacantUpdated
from PortfolioProjects..NashvilleHousing

Update PortfolioProjects..NashvilleHousing
set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end 

select distinct SoldAsVacant from PortfolioProjects..NashvilleHousing

-- remove duplicates and unused

select * from 
PortfolioProjects..NashvilleHousing

with rowNumCTE AS(
select *, ROW_NUMBER() OVER( PARTITION BY ParcelID,
PropertyAddress, SalePrice,SaleDate,LegalReference ORDER BY UniqueID)row_num
from PortfolioProjects..NashvilleHousing 
--ORDER BY ParcelID
)delete from rowNumCTE where row_num>1 

select * from rowNumCTE WHERE ROW_NUM>1 order by PropertyAddress

select * from 
PortfolioProjects..NashvilleHousing

alter table PortfolioProjects..NashvilleHousing
drop COLUMN ownerAddress,TaxDistrict, PropertyAddress

select * from 
PortfolioProjects..NashvilleHousing

alter table PortfolioProjects..NashvilleHousing
drop column SaleDate