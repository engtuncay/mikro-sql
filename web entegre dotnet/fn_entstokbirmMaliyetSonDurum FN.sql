USE MikroDB_V15_OZPAS
GO

--önceki ismi
IF object_id(N'dbo.fn_entstokbirimMaliyet', N'FN') IS NOT NULL
DROP FUNCTION dbo.fn_entstokbirimMaliyet
GO

IF object_id(N'dbo.fn_entstokbirimMaliyetSonDurum', N'FN') IS NOT NULL
DROP FUNCTION dbo.fn_entstokbirimMaliyetSonDurum
GO

CREATE FUNCTION dbo.fn_entstokbirimMaliyetSonDurum (@stokkod varchar(50)) 
RETURNS Decimal(15,5)
AS 
BEGIN

--DECLARE @stokkod AS varchar(30) ='PN403561' 
--ilgili stok fifo yöntemine göre maliyet hesaplar
DECLARE @maliyet AS Decimal(18,5) = 0
DECLARE @ortfiyat AS Decimal(12,5) 
-- maliyet hesaplarken kalan stok miktari
DECLARE @stokmiktarikalan AS Decimal(12,3) 

-- stok toplam miktari (bütün depolar toplanır)
DECLARE @stokmiktar AS Decimal(10,3) = (
select COALESCE ( 
(SELECT sum(
case when sth_giris_cikis=0 THEN sth_miktar
when sth_giris_cikis=1 THEN sth_miktar*-1 
end) as stok_miktari from [STOK_HAREKETLERI_GIRIS_CIKIS] WHERE sth_stok_kod=@stokkod --and sth_depono=@depokodu
group by sth_stok_kod ),0.0))

--PRINT 'stok miktar:' + cast( @stokmiktar as varchar(20))

-- ilk miktar set edilir - kalan değişkenine
SET @stokmiktarikalan = @stokmiktar

-- neg.stoklar için de fiyat hesaplar
IF (@stokmiktarikalan<0) SET @stokmiktarikalan = @stokmiktarikalan*-1

-- Detaylı bilgi tutmak için table oluşturulabilir
--DECLARE @userdata TABLE( miktar Decimal(10,5), tutar Decimal(10,5) NOT NULL , tarih DATETIME)

-- cursor için değişkenler
-- stok hareketlerindeki stok miktarı
DECLARE @sthmiktar AS Decimal(12,3)
DECLARE @tarih AS date 
DECLARE @tutar AS Decimal(15,5)

DECLARE crs CURSOR FOR
SELECT sth_tarih,sth_miktar
,(sth_tutar-sth_iskonto1-sth_iskonto2-sth_iskonto3-sth_iskonto4-sth_iskonto5-sth_iskonto6) as tutar 
FROM [STOK_HAREKETLERI] WHERE sth_evraktip=3 and sth_stok_kod=@stokkod 
ORDER BY sth_tarih desc

OPEN crs
FETCH NEXT FROM crs INTO @tarih,@sthmiktar,@tutar
WHILE @@FETCH_STATUS =0 AND @stokmiktarikalan>0 
BEGIN
  
  IF @stokmiktarikalan - @sthmiktar >=0 BEGIN
  --INSERT INTO @userdata VALUES (@sthmiktar, @tutar, @tarih)
  SET @maliyet = @maliyet + @tutar
  --PRINT @maliyet
  END ELSE BEGIN
  --INSERT INTO @userdata VALUES (@stokmiktarikalan, @tutar , @tarih)
  SET @maliyet = @maliyet + (@tutar/@sthmiktar)*@stokmiktarikalan
  --PRINT @maliyet
  END
  
  SET @stokmiktarikalan = @stokmiktarikalan - @sthmiktar

  FETCH NEXT FROM CRS INTO @tarih,@sthmiktar, @tutar

END

CLOSE crs
DEALLOCATE crs

IF( @stokmiktar>0) SET @ortfiyat = @maliyet / @stokmiktar
IF( @stokmiktar=0) SET @ortfiyat = 0

IF( @stokmiktar<0) 
BEGIN
SET @ortfiyat = @maliyet / @stokmiktar*-1
END

--Test için
--select @maliyet as maliyet, @ortfiyat as ortfiyat
--SELECT * FROM @userdata

RETURN @ortfiyat

END