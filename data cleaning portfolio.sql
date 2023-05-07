--cleaning data in SQL
select *
from [SQL Portfolio].dbo.NashvileHousing

--Standrdize data from
select SaleDateConverd,CONVERT(date,SaleDate)
from [SQL Portfolio].dbo.NashvileHousing

--update
update NashvileHousing
set SaleDate=CONVERT(date,SaleDate)

alter table NashvileHousing 
add  SaleDateConverd date

update NashvileHousing
set SaleDateConverd =CONVERT(date,SaleDate)

--populate property address
select *
from [SQL Portfolio].dbo.NashvileHousing
where PropertyAddress is null

---join
select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from [SQL Portfolio].dbo.NashvileHousing a
join [SQL Portfolio].dbo.NashvileHousing b
 on a.ParcelID=b.ParcelID
and a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from [SQL Portfolio].dbo.NashvileHousing a
join [SQL Portfolio].dbo.NashvileHousing b
 on a.ParcelID=b.ParcelID
and a.[UniqueID]<>b.[UniqueID]
where a.PropertyAddress is null

-- breaking out address  in to indvisual column
select PropertyAddress
from [SQL Portfolio].dbo.NashvileHousing

--Split


select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress)) as Address
from [SQL Portfolio].dbo.NashvileHousing




alter table [SQL Portfolio].dbo.NashvileHousing 
add  PropertySplitAddress Nvarchar (255);

update [SQL Portfolio].dbo.NashvileHousing
set PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table [SQL Portfolio].dbo.NashvileHousing 
add  PropertySplitCity Nvarchar(255);

update [SQL Portfolio].dbo.NashvileHousing
set PropertySplitCity =SUBSTRING(PropertyAddress,
CHARINDEX(',',PropertyAddress)+ 1,LEN(PropertyAddress))

select*
from [SQL Portfolio].dbo.NashvileHousing

select OwnerAddress
from [SQL Portfolio].dbo.NashvileHousing
where OwnerAddress is not null

--splite
select
PARSENAME(replace(OwnerAddress,',',','),1)
,PARSENAME(replace(OwnerAddress,',',','),2)
,PARSENAME(replace(OwnerAddress,',',','),3)
from [SQL Portfolio].dbo.NashvileHousing


alter table [SQL Portfolio].dbo.NashvileHousing 
add  OwnerSplitAddress Nvarchar (255);

update [SQL Portfolio].dbo.NashvileHousing
set OwnerSplitAddress =PARSENAME(replace(OwnerAddress,',',','),1)

alter table [SQL Portfolio].dbo.NashvileHousing 
add  OwnerSplitCity Nvarchar(255);

update [SQL Portfolio].dbo.NashvileHousing
set OwnerSplitCity =PARSENAME(replace(OwnerAddress,',',','),2)


alter table [SQL Portfolio].dbo.NashvileHousing 
add  OwnerSplitState Nvarchar(255);

update [SQL Portfolio].dbo.NashvileHousing
set OwnerSplitState =PARSENAME(replace(OwnerAddress,',',','),3)

select*
from [SQL Portfolio].dbo.NashvileHousing

--change Y and N to Yes and NO in  SoldAsVacant Column
select distinct (SoldAsVacant),count(SoldAsVacant)
from [SQL Portfolio].dbo.NashvileHousing
group by SoldAsVacant
order by 2

select SoldAsVacant

, case  when SoldAsVacant='Y' then 'Yes'
        when SoldAsVacant= 'N'then 'NO'
		else SoldAsVacant
		end 
		from [SQL Portfolio].dbo.NashvileHousing

		 update [SQL Portfolio].dbo.NashvileHousing
		 set SoldAsVacant =
	case	 when SoldAsVacant='Y' then 'Yes'
        when SoldAsVacant= 'N'then 'NO'
		else SoldAsVacant
		end 
		from [SQL Portfolio].dbo.NashvileHousing


	--- remove Duplicate

	select*,
	ROW_NUMBER() over (partition by ParcelID,
	SaleDate,
	SalePrice,
	propertyAddress,
	LegalReference
	order by UniqueID  desc ) row_num

	from [SQL Portfolio].dbo.NashvileHousing

	--cte
	with CteName as (
	select*,
	ROW_NUMBER() over (partition by ParcelID,
	SaleDate,
	SalePrice,
	propertyAddress,
	LegalReference
	order by UniqueID  desc ) row_num

	from [SQL Portfolio].dbo.NashvileHousing )
	select*
	from CteName
	where row_num > 1
	order by PropertyAddress

	select*
	from [SQL Portfolio].dbo.NashvileHousing

	--delete unused column
	alter table [SQL Portfolio].dbo.NashvileHousing
	drop column OwnerAddress,TaxDistrict,PropertyAddress

	alter table [SQL Portfolio].dbo.NashvileHousing
	drop column SaleDate