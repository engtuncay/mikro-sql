USE MikroDB_V15_OZPAS

--önceki ismi
IF object_id(N'dbo.fn_entstokbirimMaliyetTarih', N'FN') IS NOT NULL
DROP FUNCTION dbo.fn_entstokbirimMaliyetTarih
GO

IF object_id(N'dbo.fn_entstokbirimMaliyetFatura', N'FN') IS NOT NULL
DROP FUNCTION dbo.fn_entstokbirimMaliyetFatura
GO

CREATE FUNCTION dbo.fn_entstokbirimMaliyetFatura (@stokkod varchar(50),@maliyetTarih date,@stokmiktar Decimal(12,3)) 
RETURNS Decimal(15,5)
AS 
BEGIN

-- parametreden gelecek veriler
--DECLARE @maliyetTarih As DATE = '20180301'
--DECLARE @stokkod AS varchar(30) ='PN403561'
--DECLARE @stokmiktar as DECIMAL(12,3) = 1
--DECLARE @

--ilgili stok fifo yöntemine göre maliyet hesaplar
DECLARE @maliyet AS Decimal(18,5) = 0
DECLARE @ortfiyat AS Decimal(12,5)
-- maliyet hesaplarken kalan stok miktari
DECLARE @envanterMiktarKalan AS Decimal(12,3)
DECLARE @satismiktarikalan AS Decimal(12,3)

-- o tarihteki stok envanter toplam miktari hesaplanır (bütün depolar toplanır)
DECLARE @envanterMiktar AS Decimal(10,3) = (
select COALESCE ( 
(SELECT sum(
case when sth_giris_cikis=0 THEN sth_miktar
when sth_giris_cikis=1 THEN sth_miktar*-1 
end) as stok_miktari from [STOK_HAREKETLERI_GIRIS_CIKIS] WHERE sth_stok_kod=@stokkod and sth_tarih<=@maliyetTarih --and sth_depono=@depokodu
group by sth_stok_kod ),0.0))

DECLARE @tarihsatismiktar AS Decimal(10,3) = (
select COALESCE ( 
(SELECT sum(
case when sth_giris_cikis=0 THEN sth_miktar
when sth_giris_cikis=1 THEN sth_miktar*-1 
end) as stok_miktari from [STOK_HAREKETLERI_GIRIS_CIKIS] WHERE sth_stok_kod=@stokkod and sth_tarih=@maliyetTarih and sth_evraktip=4 --and sth_depono=@depokodu
group by sth_stok_kod ),0.0))

-- O tarihte satış miktarı, negatif ise prm.den gelen stok miktar baz alır
if(@tarihsatismiktar<0) Set @tarihsatismiktar=@stokmiktar
-- O tarihte satış miktarı, stok miktarından az ise, daha dogru hesaplamak için stok miktarını baz alsın
if(@tarihsatismiktar<@stokmiktar) Set @tarihsatismiktar=@stokmiktar

--PRINT @envanterMiktar
--if(@envanterMiktar<0) Set @envanterMiktar=@tarihsatismiktar
--PRINT @tarihsatismiktar

-- Detaylı bilgi tutmak için table oluşturulabilir
-- DECLARE @userdata TABLE(miktar Decimal(10,5),tutar Decimal(10,5) NOT NULL,tarih DATETIME,seri varchar(10),sira int)
--/


-- ilk miktar set edilir - kalan değişkenine
SET @envanterMiktarKalan = @envanterMiktar
SET @satismiktarikalan = @tarihsatismiktar
-- cursor için değişkenler
-- stok hareketlerindeki stok miktarı
DECLARE @sthmiktar AS Decimal(12,3)
DECLARE @tarih AS date
DECLARE @tutar AS Decimal(15,5)
DECLARE @seri AS varchar(10)
DECLARE @sira AS int

DECLARE crs CURSOR FOR
SELECT sth_tarih, sth_miktar
, (sth_tutar-sth_iskonto1-sth_iskonto2-sth_iskonto3-sth_iskonto4-sth_iskonto5-sth_iskonto6) as tutar
, sth_evrakno_seri,sth_evrakno_sira
FROM [STOK_HAREKETLERI]
WHERE sth_evraktip=3 and sth_stok_kod=@stokkod and sth_tarih<=@maliyetTarih
ORDER BY sth_tarih desc

OPEN crs
FETCH NEXT FROM crs INTO @tarih,@sthmiktar,@tutar,@seri,@sira
WHILE @@FETCH_STATUS =0 AND @satismiktarikalan>0 
BEGIN

    SET @envanterMiktarKalan = @envanterMiktarKalan - @sthmiktar

    IF @envanterMiktarKalan<= @satismiktarikalan
    BEGIN

        IF @satismiktarikalan - @sthmiktar >=0 
        BEGIN
            --Detay Bilgi için
            --INSERT INTO @userdata VALUES (@sthmiktar, @tutar, @tarih,@seri,@sira)
            --/
            SET @maliyet = @maliyet + @tutar
        --PRINT @maliyet
        END ELSE BEGIN
            --Detay Bilgi için
            --INSERT INTO @userdata VALUES (@satismiktarikalan, ((@tutar/@sthmiktar)*@satismiktarikalan) , @tarih,@seri,@sira)
            --/
            SET @maliyet = @maliyet + (@tutar/@sthmiktar)*@satismiktarikalan
        --PRINT @maliyet

        END

        SET @satismiktarikalan = @satismiktarikalan - @sthmiktar

    END

    FETCH NEXT FROM CRS INTO @tarih,@sthmiktar, @tutar,@seri,@sira

END

CLOSE crs
DEALLOCATE crs

IF( @tarihsatismiktar>0) SET @ortfiyat = @maliyet / @tarihsatismiktar
IF( @tarihsatismiktar=0) SET @ortfiyat = 0

IF( @tarihsatismiktar<0) 
BEGIN
    SET @ortfiyat = @maliyet / @tarihsatismiktar*-1
END

--PRINT @ortfiyat

--Test için
--select @maliyet as maliyet, @ortfiyat as ortfiyat
--SELECT * FROM @userdata
--/

RETURN @ortfiyat
END  -- fonksiyon bitişi

