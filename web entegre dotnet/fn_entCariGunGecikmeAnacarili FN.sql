USE MikroDB_V15_OZPASDEMO

IF object_id(N'dbo.fn_entCariGunGecikmeAnacarili', N'FN') IS NOT NULL 
    DROP FUNCTION dbo.fn_entCariGunGecikmeAnacarili
    
GO

CREATE FUNCTION fn_entCariGunGecikmeAnacarili(@mKod AS varchar(50),@gunLimit AS int, @sektorkodu As varchar(20)) 
RETURNS Decimal(18,2)
AS
BEGIN

-- Örnek Cari Kodlar
-- PN95889 : Oli Şubesi 
-- PN96184 : Dostlar Gıda 
-- PN293183 : Tuğra Center

-- Parametreden Gelenler
--DECLARE @mkod AS varchar(30) ='PN293183'     
--DECLARE @sektorkodu as varchar(150) = 'PANEK'
--DECLARE @gunLimit as int = 45

-- Fonksiyon Değişkenleri
DECLARE @Borc AS Decimal(10,2) -- cari hesap hareketlerindeki meblag
DECLARE @BorcK AS Decimal(10,2)

DECLARE @mkodAnacari AS varchar(30)
DECLARE @Tarih AS date 
DECLARE @gunSayisi AS int
DECLARE @anaCariCount AS int = 0

DECLARE @gecikmeGun AS Decimal(15,2)
DECLARE @OrtalamaGecikme AS int

SET @mkodAnacari = ( SELECT cari_Ana_cari_kodu FROM [CARI_HESAPLAR] WITH (NOLOCK) WHERE cari_kod=@mKod )
SET @anaCariCount = ( SELECT count(*) FROM [CARI_HESAPLAR] WITH (NOLOCK) WHERE cari_Ana_cari_kodu=@mKod )

-- mKod ana cari kodu ise ana carili hesaplama yaptırmak lazım

DECLARE @BorcL AS Decimal(10,2)
DECLARE @gunLimitTutar As Decimal(10,2) = 0

IF @mkodAnacari IS NULL SET @mkodAnacari=''
IF @anaCariCount>0 Set @mkodAnacari=@mKod

--PRINT 'Anacarisi:' + CAST (@mkodAnacari as varchar(50))

IF LEN(@mkodAnacari)>0 OR @anaCariCount>0 BEGIN
SET @BorcL = (select sum(dbo.fn_CariHesapAnaDovizBakiye('',0,cari_kod,'','',NULL,NULL,NULL,0)) from CARI_HESAPLAR WITH (NOLOCK) where cari_Ana_cari_kodu=@mkodAnacari and cari_sektor_kodu=@sektorkodu)
END
ELSE BEGIN 
SET @BorcL = dbo.fn_CariHesapAnaDovizBakiye('',0,@mKod,'','',NULL,NULL,NULL,0)
END

IF @BorcL<=1 GOTO BORCNEG

--PRINT 'Borc Bakiyesi:' + CAST (@BorcL as varchar(50))

SET @BorcK = @BorcL

--SET @gecikmeGun = 0.0;

--DECLARE @userdata TABLE( gunfarki int NOT NULL, meblag Decimal(10,2) NOT NULL )
IF(@mkodAnacari IS NULL OR @mkodAnacari='') SET @mkodAnacari=@mkod

-- Add the T-SQL statements to compute the return value here
DECLARE crs CURSOR FOR
SELECT cha_tarihi,cha_meblag
FROM [CARI_HESAP_HAREKETLERI] chh WITH (NOLOCK)
LEFT JOIN [CARI_HESAPLAR] chs WITH (NOLOCK) ON chh.cha_kod = chs.cari_kod 
WHERE chh.cha_tip=0 and chs.cari_sektor_kodu = @sektorkodu and ( chs.cari_Ana_cari_kodu = @mkodAnacari or chh.cha_kod = @mKod )
ORDER BY chh.cha_tarihi desc

--SELECT x.cha_tarihi,x.cha_meblag
--FROM (SELECT cha_tarihi,cha_meblag,
--CASE
--WHEN LEN(chs.cari_Ana_cari_kodu ) > 0 THEN chs.cari_Ana_cari_kodu
--ELSE chs.cari_kod
--END AS cari_kod2
--FROM [CARI_HESAP_HAREKETLERI] chh WITH (NOLOCK, INDEX=idx_Nonclustered_CARI_HESAP_HAREKETLERI_cha_tip)
----WITH (NOLOCK, INDEX=NDX_CARI_HESAP_HAREKETLERI_03)
--LEFT JOIN [CARI_HESAPLAR] chs WITH (NOLOCK) ON chh.cha_kod = chs.cari_kod 
--WHERE cha_tip=0 and chs.cari_sektor_kodu = @sektorkodu) AS x
--WHERE cari_kod2 = @mkodAnacari   --and cha_evrak_tip=63
--ORDER BY x.cha_tarihi desc

OPEN crs
FETCH NEXT FROM crs INTO @Tarih, @Borc
WHILE @@FETCH_STATUS =0 AND @BorcK>0 
BEGIN

  SET @gunSayisi = DATEDIFF(day,@Tarih,getdate())

  IF @BorcK - @Borc >=0 BEGIN
  --INSERT INTO @userdata VALUES (@gunSayisi, @Borc)
  IF @gunSayisi>=@gunLimit SET @gunLimitTutar=@gunLimitTutar+@Borc
  
  END ELSE BEGIN
  --INSERT INTO @userdata VALUES (@gunSayisi, @BorcK)
  IF @gunSayisi>=@gunLimit SET @gunLimitTutar=@gunLimitTutar+ @BorcK

  END
  
  SET @BorcK = @BorcK - @Borc

  FETCH NEXT FROM CRS INTO @Tarih, @Borc

END

CLOSE crs
DEALLOCATE crs

BORCNEG:

--SELECT top 10 cha_tarihi,cha_meblag FROM [CARI_HESAP_HAREKETLERI] WHERE cha_evrak_tip=63 and cha_kod=@mkod order by cha_tarihi desc
--SELECT * FROM @userdata

--PRINT ' Tutar:' + CAST ( @gunLimitTutar as varchar(50))

RETURN @gunLimitTutar
END