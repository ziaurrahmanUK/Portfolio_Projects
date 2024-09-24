SELECT Top 10
    *
FROM NashvilleHousing
ORDER BY SalePrice
;

-- Standardise the Date Format

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate);

SELECT SaleDateConverted
FROM NashvilleHousing

-- Populate Property Addresses
-- self join table - the pnes with ParcelId and and adress can populate the missing PropertyAdress

/*
SELECT A.ParcelID, A.PropertyAddress, B.ParcelId, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashvilleHousing A
JOIN NashvilleHousing B
    ON A.ParcelID = B.ParcelID
    AND A.UniqueID <> B.UniqueId
WHERE A.PropertyAddress IS NULL

*/


-- the following sql code will update the Property adress if it is NULL with that from the self-join B.PropertyAddress field

UPDATE A
SET A.PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashvilleHousing A
    JOIN NashvilleHousing B
    ON A.ParcelID = B.ParcelID
        AND A.UniqueID <> B.UniqueId
WHERE A.PropertyAddress IS NULL


-- check below returns no missing values for PropertyAddress
SELECT PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress IS NULL


-- Break out the adresss into seperate columns i.e. Adress, City , State

SELECT
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress, (CHARINDEX(',', PropertyAddress) + 1), CHARINDEX(',', PropertyAddress) - 1) AS City
FROM NashvilleHousing;


-- then update the table with the two new columns and update with trhe values from above select query

ALTER TABLE NashvilleHousing
ADD PropertyAddressConverted NVARCHAR(255);
;
ALTER TABLE NashvilleHousing
ADD PropertyAddressCityConverted NVARCHAR(255)
;

UPDATE NashvilleHousing
SET PropertyAddressConverted = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)
;
UPDATE NashvilleHousing
SET PropertyAddressCityConverted = SUBSTRING(PropertyAddress, (CHARINDEX(',', PropertyAddress) + 1), CHARINDEX(',', PropertyAddress) - 1)
;

-- check it created the new columns

SELECT TOP 10
    PropertyAddress, PropertyAddressConverted, PropertyAddressCityConverted
FROM NashvilleHousing;

-- Split the OwnerAddress using ParseName

SELECT
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM
    NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD OwnerAddressConverted NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerAddressConverted = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
;

ALTER TABLE NashvilleHousing
ADD OwnerCityConverted NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerCityConverted = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
;
ALTER TABLE NashvilleHousing
ADD OwnerStateConverted NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerStateConverted = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
;


-- check the new columns are created and populated
SELECT TOP 10
    *
FROM NashvilleHousing;


-- Change Y and N in 'Sold as Vacant' field to make all same 
SELECT
    DISTINCT(SoldAsVacant),
    COUNT(*) As Count
FROM
    NashvilleHousing
GROUP BY
    SoldAsVacant;
-- we have 399 that are N and 52 that are Y

SELECT
    SoldAsVacant,
    CASE
        WHEN SoldAsVacant = 'N' THEN 'No'
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        ELSE SoldAsVacant
    END
FROM
    NashvilleHousing;


-- update statement
UPDATE
    NashvilleHousing
SET SoldAsVacant = CASE
        WHEN SoldAsVacant = 'N' THEN 'No'
        WHEN SoldAsVacant = 'Y' THEN 'Yes'
        ELSE SoldAsVacant
    END
;


-- Remove duplicates using RANK and a CTE

WITH Duplicate_finder AS
(
SELECT 
    *, 
    ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS Row_Num
FROM
    NashvilleHousing
)

SELECT * FROM Duplicate_finder
WHERE Row_Num >= 2;

-- change it from select clause to delete

/*
WITH Duplicate_finder AS
(
SELECT 
    *, 
    ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) AS Row_Num
FROM
    NashvilleHousing
)

DELETE 
FROM Duplicate_finder
WHERE Row_Num >= 2;

*/

-- DElete Uniused columns

SELECT * FROM NashvilleHousing;

--ALTER TABLE NashvilleHousing
--DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate
;
