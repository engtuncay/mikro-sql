--SELECT cari_sektor_kodu,cari_kod,cari_unvan1 ,* FROM [CARI_HESAPLAR] WHERE cari_unvan1 LIKE '%OLİ%'

USE MikroDB_V15_OZPAS

--select dbo.fn_entCariOrtGecikmeAnacarili('K20973',114971.77, 'KENT') as gecikme

-- Örnek Cari Kodlar
-- PN95889 : Oli Şubesi 
-- PN96184 : Dostlar Gıda 
-- PN293183 : Tuğra Center

-- Parametreden Gelecek Değişkenler
DECLARE @sektorkodu as varchar(150) = 'PANEK'
DECLARE @gunLimit as int = 60

-- ilgili veriler silinir
DELETE FROM SCReporting..Gecikenler where SM=@sektorkodu AND KacGun=@gunLimit

--select dbo.fn_entCariGunGecikmeAnacarili('PN293183',30,'PANEK') as gecikmeTutar

DECLARE @cariKod VARCHAR(50) 
DECLARE @gecikmeTutar  Decimal(15,5) 
DECLARE @bakiye Decimal(15,5) 
DECLARE @cariUnvan1 VARCHAR(200)
DECLARE @plasiyer VARCHAR(150)
DECLARE @plasiyerAdi VARCHAR(150)

-- Cursor lenecek sorgu yazılır
DECLARE db_cursor CURSOR FOR 
SELECT chx.cari_kod2,ch2.cari_unvan1,max(chx.cari_temsilci_kodu) as temsilcikod
FROM (
SELECT CASE WHEN LEN(ch.cari_Ana_cari_kodu ) > 0 THEN ch.cari_Ana_cari_kodu
ELSE ch.cari_kod END AS cari_kod2,ch.cari_temsilci_kodu
FROM CARI_HESAPLAR ch WHERE ch.cari_sektor_kodu=@sektorkodu 
) AS chx LEFT JOIN [CARI_HESAPLAR] ch2 ON chx.cari_kod2= ch2.cari_kod 
GROUP BY chx.cari_kod2,ch2.cari_unvan1

-- SELECT cari_kod
-- ,cari_unvan1
-- --,ISNULL(cari_temsilci_kodu + ' - ' + dbo.fn_CarininIsminiBul(1,cari_temsilci_kodu),'') as temsilci
-- FROM CARI_HESAPLAR WHERE cari_sektor_kodu=@sektorkodu and (cari_Ana_cari_kodu IS NULL or cari_Ana_cari_kodu='')
-- UNION 
-- SELECT cari_kod
-- ,cari_unvan1
-- --,ISNULL(cari_temsilci_kodu + ' - ' + dbo.fn_CarininIsminiBul(1,cari_temsilci_kodu),'') as temsilci
-- FROM CARI_HESAPLAR WHERE cari_kod IN (select DISTINCT cari_Ana_cari_kodu 
-- from [CARI_HESAPLAR] where cari_sektor_kodu=@sektorkodu AND cari_Ana_cari_kodu IS NOT NULL AND NOT cari_Ana_cari_kodu='')


-- Cursor açılır, Cursor sorgusundan dönecek alanlar , hangi değişkene bağlanacağı belirlenir
--, sırasına göre değişkene bağlar, aynı ismi olması gerekmez
OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @cariKod,@cariUnvan1,@plasiyer

--,dbo.fn_CarininIsminiBul(1,cari_temsilci_kodu) as temsilci

-- döngü gerçekleştirilir
WHILE @@FETCH_STATUS = 0 -- AND [$secondCondition]
BEGIN  
    PRINT 'cari:'+@cariUnvan1
    SET @gecikmeTutar = dbo.fn_entCariGunGecikmeAnacarili(@cariKod,@gunLimit,@sektorkodu) 
    SET @bakiye = dbo.fn_CariHesapAnaDovizBakiye('',0,@cariKod,'','',NULL,NULL,NULL,0)
    SET @plasiyerAdi = (select cpt.cari_per_kod + ' - ' +cpt.cari_per_adi from CARI_PERSONEL_TANIMLARI cpt WHERE cpt.cari_per_kod=@plasiyer)
    IF @plasiyerAdi IS NULL SET @plasiyerAdi=''
    
    INSERT INTO SCReporting.dbo.Gecikenler ( [CDate],[ACKodu],[CKodu],[CUnvan],[Plasiyer],[SM],[KacGun],[Bakiye],[Geciken])
    VALUES (GETDATE(), @cariKod, @cariKod,@cariUnvan1,@plasiyerAdi,@sektorkodu,@gunLimit,@bakiye,@gecikmeTutar)

    FETCH NEXT FROM db_cursor INTO @cariKod,@cariUnvan1,@plasiyer
END 

-- cursor kapatılır , deallocate edilir
CLOSE db_cursor  
DEALLOCATE db_cursor 
