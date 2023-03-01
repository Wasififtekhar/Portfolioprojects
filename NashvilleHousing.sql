select * 
from portfolioproject.dbo.NashvilleHousing
order by 2

--1. Standarized the date format 
select saledateconverted, CONVERT(Date,SaleDate)
from portfolioproject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing 
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--------------------------------------------------------------------------------------------------------------------------------------------------------------
--2.

--populating property address data

select *
from portfolioproject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, ISNULL(a.propertyaddress,b.propertyaddress)
from portfolioproject.dbo.NashvilleHousing a
Join portfolioproject.dbo.NashvilleHousing b
on a.parcelID = b.parcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.propertyaddress is null


--updating current table with new table

Update a
SET propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
From portfolioproject.dbo.NashvilleHousing a
Join portfolioproject.dbo.NashvilleHousing b
on a.parcelID = b.parcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.propertyaddress is null




--------------------------------------------------------------------------------------------------------------------------------------------------------------


--3.

-- Breaking out Address into individual Columns (Address, City, State)

select propertyaddress
from portfolioproject.dbo.NashvilleHousing




SELECT 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1 ) AS Address
, SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 1, LEN(PropertyAddress)) AS City

From portfolioproject.dbo.NashvilleHousing 


ALTER TABLE portfolioproject.dbo.NashvilleHousing
Add PropertyySplitAddress Nvarchar(255);

Update portfolioproject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1 ) 

ALTER TABLE portfolioproject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update portfolioproject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 1, LEN(PropertyAddress))

Select *
From portfolioproject.dbo.NashvilleHousing 
order by 2





Select OwnerAddress
From portfolioproject.dbo.NashvilleHousing 


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From portfolioproject.dbo.NashvilleHousing 


ALTER TABLE portfolioproject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update portfolioproject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3) 

ALTER TABLE portfolioproject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update portfolioproject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)


ALTER TABLE portfolioproject.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update portfolioproject.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)


Select *
From portfolioproject.dbo.NashvilleHousing 
order by 2



--------------------------------------------------------------------------------------------------------------------------------------------------------------

--4.
--Changed Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From portfolioproject.dbo.NashvilleHousing 
Group by SoldAsVacant
order by 2

select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From portfolioproject.dbo.NashvilleHousing 


Update portfolioproject.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--------------------------------------------------------------------------------------------------------------------------------------------------------------

--5.

--Removed Duplicates 
WITH RowNumCTE as(
Select *, 
   ROW_NUMBER() OVER (
   PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				UniqueID
				) row_num


From portfolioproject.dbo.NashvilleHousing 
--order by ParcelID
)
Select *
From RowNumCTE
where Row_num > 1

select *
From portfolioproject.dbo.NashvilleHousing 
order by 2



--------------------------------------------------------------------------------------------------------------------------------------------------------------

--6. 

-- deleting unused columns
Select *
From portfolioproject.dbo.NashvilleHousing 
order by 2


ALTER TABLE portfolioproject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, Propertyaddress

ALTER TABLE portfolioproject.dbo.NashvilleHousing
DROP COLUMN SaleDate