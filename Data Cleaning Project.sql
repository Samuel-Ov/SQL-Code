
--Data Cleaning Project in SQL Queries

select*
from PortfolioProject..NashvilleHousing


--Standardize Date Format; the date has time at the end which has no pupose, so I want to take that off

select SaleDateCoverted, convert(Date,SaleDate) as Date
from PortfolioProject..NashvilleHousing

Alter table NashvilleHousing
add SaleDateCoverted Date;

update NashvilleHousing
Set SaleDateCoverted = Convert(Date, SaleDate)


--Property address, where there is null value
--Using the ParcelID to update the null value in property address that have the same ParcelID
--Basicly where Parcel id has an address and the same parcel id does not have address  in some address column, let's populate it with this address


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.propertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out address into individual columns (address, city, state)

select 
substring(PropertyAddress, 1, charindex(',',PropertyAddress)-1) as Address
	,substring(PropertyAddress,charindex(',',PropertyAddress)+1, len(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing 

Alter table NashvilleHousing
add PropertyNumber nvarchar(255);

update NashvilleHousing
Set PropertyNumber = substring(PropertyAddress, 1, charindex(',',PropertyAddress)-1)


Alter table NashvilleHousing
add PropertyCity Nvarchar (255);

update NashvilleHousing
Set PropertyCity = substring(PropertyAddress,charindex(',',PropertyAddress)+1, len(PropertyAddress))

select *
from NashvilleHousing

--Looking at the owner address and pliting it with parsename

select
parsename(replace(OwnerAddress,',','.'), 3) 
,parsename(replace(OwnerAddress,',','.'), 2) 
,parsename(replace(OwnerAddress,',','.'), 1) 
from NashvilleHousing

Alter table NashvilleHousing
add OwnerPAddress nvarchar(255);

update NashvilleHousing
Set OwnerPAddress = parsename(replace(OwnerAddress,',','.'), 3)

Alter table NashvilleHousing
add OwnerPCity nvarchar(255);

update NashvilleHousing
Set OwnerPCity = parsename(replace(OwnerAddress,',','.'), 2) 

Alter table NashvilleHousing
add OwnerState nvarchar(255);

update NashvilleHousing
Set OwnerState = parsename(replace(OwnerAddress,',','.'), 1)

select *
from NashvilleHousing


---Change Y and N Yes and No in Sold as Vacant 'Field

select distinct(SoldAsVacant),count(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by SoldAsVacant

----N, Yes, No and Y is observed

select SoldAsVacant
, case	when SoldAsVacant ='Y' then 'Yes'
		when SoldAsVacant ='N' then 'No'
		else SoldAsVacant
		end 
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case	when SoldAsVacant ='Y' then 'Yes'
		when SoldAsVacant ='N' then 'No'
		else SoldAsVacant
		end  

select*
From NashvilleHousing

---Removing Duplicate and inserting it into CTE 

with RowNumCTE as(
select*,
	row_number() over (
	partition by parcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					) row_num
From NashvilleHousing
)
delete --when replace the deleet with select * and run you see that duplicte have been removed
from RowNumCTE
where row_num >1
--order by PropertyAddress


 
----Deleting Unused Columns (Not on the raw data from the database)

select *
From NashvilleHousing

alter table NashvilleHousing
drop column ownerAddress, Taxdistrict, PropertyAddress, SaleDate

alter table NashvilleHousing
drop column SaleDate

select *
From NashvilleHousing