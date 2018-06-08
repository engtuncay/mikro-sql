USE MikroDB_V15_OZPAS

-- önceki ismi
IF object_id(N'dbo.fn_entCariOrtGecikmeAnacariliSormer', N'FN') IS NOT NULL 
    DROP FUNCTION dbo.fn_entCariOrtGecikmeAnacariliSormer
    
GO

--CREATE FUNCTION fn_entCariOrtGecikmeAnacariliSormer(@mKod AS varchar(50), @sektorkodu As varchar(20)) 
--RETURNS int
--AS
--BEGIN

-- Parametreden Gelenler
DECLARE @mkod AS varchar(30) ='KM102'     -- K00205 , PN95889
DECLARE @sektorkodu as varchar(150) = ''
DECLARE @BorcL AS Decimal(10,2) = 948.99

-- Fonksiyon Değişkenleri
DECLARE @Borc AS Decimal(10,2) -- cari hesap hareketlerindeki meblag
DECLARE @BorcK AS Decimal(10,2)

DECLARE @mkodAnacari AS varchar(30)
DECLARE @Tarih AS date 
DECLARE @gunSayisi AS int

DECLARE @GecikmeKum AS Decimal(15,2)
DECLARE @OrtalamaGecikme AS int

 
SET @BorcK = @BorcL

SET @GecikmeKum = 0.0;

SET @mkodAnacari = ( SELECT cari_Ana_cari_kodu FROM [CARI_HESAPLAR] WHERE cari_kod=@mKod )

IF @sektorkodu='' SET @sektorkodu='%'

PRINT 'Anacarisi:' + CAST (@mkodAnacari as varchar(50))

DECLARE @userdata TABLE( gunfarki int NOT NULL, meblag Decimal(10,2) NOT NULL )
IF(@mkodAnacari IS NULL OR @mkodAnacari='') SET @mkodAnacari=@mkod

-- Add the T-SQL statements to compute the return value here
DECLARE crs CURSOR FOR
SELECT x.cha_tarihi,x.cha_meblag
FROM (SELECT cha_tarihi,cha_meblag,
CASE
WHEN LEN(chs.cari_Ana_cari_kodu ) > 0 THEN chs.cari_Ana_cari_kodu
ELSE chs.cari_kod
END AS cari_kod2
FROM [CARI_HESAP_HAREKETLERI] chh
LEFT JOIN [CARI_HESAPLAR] chs ON chh.cha_kod = chs.cari_kod 
WHERE cha_tip=0 and chs.cari_sektor_kodu LIKE @sektorkodu) AS x
WHERE cari_kod2 = @mkodAnacari   --and cha_evrak_tip=63
ORDER BY x.cha_tarihi desc

OPEN crs
FETCH NEXT FROM crs INTO @Tarih, @Borc
WHILE @@FETCH_STATUS =0 AND @BorcK>0 
BEGIN

  SET @gunSayisi = DATEDIFF(day,@Tarih,getdate())

  IF @BorcK - @Borc >=0 BEGIN
  INSERT INTO @userdata VALUES (@gunSayisi, @Borc)
  SET @GecikmeKum = @GecikmeKum + ( @gunSayisi*@Borc)
  
  END ELSE BEGIN
  INSERT INTO @userdata VALUES (@gunSayisi, @BorcK)
  SET @GecikmeKum = @GecikmeKum + ( @gunSayisi*@BorcK)
  END
  
  SET @BorcK = @BorcK - @Borc

  FETCH NEXT FROM CRS INTO @Tarih, @Borc

END

CLOSE crs
DEALLOCATE crs

--SELECT top 10 cha_tarihi,cha_meblag FROM [CARI_HESAP_HAREKETLERI] WHERE cha_evrak_tip=63 and cha_kod=@mkod order by cha_tarihi desc
SELECT * FROM @userdata

PRINT @GecikmeKum
PRINT @BorcL
SET @OrtalamaGecikme = @GecikmeKum / @BorcL

--SET @OrtalamaGecikme = -1

Print @OrtalamaGecikme
--RETURN @OrtalamaGecikme
--END