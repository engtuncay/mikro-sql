--USE MikroDB_V15_OZPASTEST
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATE FUNCTION fn_TableBorcGun (@mKod AS varchar(50),@BorcL AS Decimal(10,2)) RETURNS 
--@userdata TABLE( gunfarki int NOT NULL, meblag Decimal(10,2) NOT NULL )
--AS
--BEGIN

DECLARE @mkod AS varchar(30) ='K00205'
DECLARE @BorcL AS Decimal(10,2) = 409.63

DECLARE @BorcK AS Decimal(10,2)
DECLARE @Borc AS Decimal(10,2)
DECLARE @Tarih AS date 
DECLARE @gunSayisi AS int
 
SET @BorcK = @BorcL

DECLARE @userdata TABLE( gunfarki int NOT NULL, meblag Decimal(10,2) NOT NULL )

-- Add the T-SQL statements to compute the return value here
DECLARE crs CURSOR FOR
SELECT cha_tarihi,cha_meblag FROM [CARI_HESAP_HAREKETLERI] WHERE cha_tip=1 and cha_kod=@mkod --and cha_evrak_tip=63
ORDER BY cha_tarihi desc

OPEN crs
FETCH NEXT FROM crs INTO @Tarih, @Borc
WHILE @@FETCH_STATUS =0 AND @BorcK>0 
BEGIN

  SET @gunSayisi = DATEDIFF(day,@Tarih,getdate())

  IF @BorcK - @Borc >=0 BEGIN
  INSERT INTO @userdata VALUES (@gunSayisi, @Borc)
  END ELSE BEGIN
  INSERT INTO @userdata VALUES (@gunSayisi, @BorcK)
  END
  
  SET @BorcK = @BorcK - @Borc

  FETCH NEXT FROM CRS INTO @Tarih, @Borc

END

CLOSE crs
DEALLOCATE crs

--SELECT top 10 cha_tarihi,cha_meblag FROM [CARI_HESAP_HAREKETLERI] WHERE cha_evrak_tip=63 and cha_kod=@mkod order by cha_tarihi desc
--SELECT * FROM @userdata

--RETURN
--END