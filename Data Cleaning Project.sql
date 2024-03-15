
--Data Cleaning Project in SQL Queries

select*
from PortfolioProject..NashvilleHousing

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
