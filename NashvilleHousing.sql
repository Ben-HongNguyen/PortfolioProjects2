-- Cleaning data in SQL Queries

SELECT *
FROM NashvilleHousing
ORDER BY 2,3

-- Standardlize Date Format

SELECT SaleDateConverted
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date,SaleDate)

-----------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
From NashvilleHousing
Order by ParcelID

SELECT nh1.ParcelID, nh1.PropertyAddress, nh2.ParcelID, nh2.PropertyAddress, ISNULL(nh1.PropertyAddress,nh2.PropertyAddress)
FROM NashvilleHousing nh1
JOIN NashvilleHousing nh2
	ON nh1.ParcelID = nh2.ParcelID
	AND nh1.[UniqueID] <> nh2.[UniqueID]
WHERE nh1.PropertyAddress is null 

UPDATE nh1
SET PropertyAddress = ISNULL(nh1.PropertyAddress,nh2.PropertyAddress)
FROM NashvilleHousing nh1
JOIN NashvilleHousing nh2
	ON nh1.ParcelID = nh2.ParcelID
	AND nh1.[UniqueID] <> nh2.[UniqueID]
WHERE nh1.PropertyAddress is null 


------------------------------------------------------------------------------------------------

--- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
From NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

From NashvilleHousing




ALTER TABLE NashvilleHousing
ADD PropertySlitAdress Nvarchar(50)

UPDATE NashvilleHousing
SET PropertySlitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySlitCity Nvarchar(50)

UPDATE NashvilleHousing
SET PropertySlitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))

SELECT *
From NashvilleHousing

-------------------------------------------------------

SELECT OwnerAddress
From NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerPropertyAdress Nvarchar(50);

UPDATE NashvilleHousing
SET OwnerPropertyAdress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerPropertyCity Nvarchar(50);

UPDATE NashvilleHousing
SET OwnerPropertyCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerPropertyState Nvarchar(50);

UPDATE NashvilleHousing
SET OwnerPropertyState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



-------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group By SoldAsVacant
Order By 2


SELECT SoldAsVacant
,	CASE WHEN SoldAsVacant = 'N' THEN 'NO'
		 WHEN SoldAsVacant = 'Y' THEN 'YES'
		 ELSE SoldAsVacant
		 END
From NashvilleHousing

UPDATE NashvilleHousing
	SET SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'NO'
		 WHEN SoldAsVacant = 'Y' THEN 'YES'
		 ELSE SoldAsVacant
		 END
From NashvilleHousing


------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SaleDate,
					 SalePrice,
					 LegalReference
					 ORDER BY
						UniqueID
						) row_num 
From NashvilleHousing
--ORDER BY ParcelID
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress


-------------------------------------------------------------------------------------

-- Delete Unused Columns


SELECT *
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN  SaleDate


