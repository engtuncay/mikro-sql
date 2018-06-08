--SELECT cari_sektor_kodu,cari_kod,cari_unvan1 ,* FROM [CARI_HESAPLAR] WHERE cari_unvan1 LIKE '%OLİ%'

USE MikroDB_V15_OZPAS

-- Örnek Cari Kodlar
-- PN95889 : Oli Şubesi 
-- PN96184 : Dostlar Gıda 
-- PN293183 : Tuğra Center

--select dbo.fn_entCariGunGecikmeAnacarili('PN293183',21,'PANEK') as gecikmeTutar

-- 17.26 demoda ( case li ) , 18.513 ( case siz) , withnolock ile 2.3 saniye

--select cari_unvan1,cari_kod,dbo.fn_entCariGunGecikmeAnacarili(cari_kod,21,'PANEK') as gecikmeTutar from CARI_HESAPLAR WITH (NOLOCK) where cari_sektor_kodu='PANEK' and cari_Ana_cari_kodu IS NULL

select TOP 50 x.* from CARI_HESAPLAR ch 
CROSS APPLY fn_entCariGunGecikmeAnacariliTbl(ch.cari_kod, 80, 'PANEK') as x
where cari_sektor_kodu='PANEK' and cari_Ana_cari_kodu IS NULL 

--select ch.cari_kod, x.*,y.* from CARI_HESAPLAR ch 
--CROSS APPLY fn_entCariGunGecikmeAnacariliTbl(ch.cari_kod, 1, 'PANEK') as x
----where cari_sektor_kodu='PANEK' and not cari_Ana_cari_kodu IS NULL
--OUTER APPLY ( select TOP 1 cari_temsilci_kodu from [CARI_HESAPLAR] WHERE cari_Ana_cari_kodu=ch.cari_kod and cari_sektor_kodu='PANEK' 
--and cari_temsilci_kodu<>'' and cari_temsilci_kodu IS NOT NULL ) as y
--where ch.cari_kod IN ( select DISTINCT cari_Ana_cari_kodu from [CARI_HESAPLAR] ch2 WITH(NOLOCK) 
--where cari_sektor_kodu='PANEK' and ch2.cari_Ana_cari_kodu<>'' and NOT ch2.cari_Ana_cari_kodu IS NULL )




--select * from CARI_HESAPLAR

-- 0.09 saniye
--SELECT TOP 50 cari_unvan1,cari_kod,dbo.fn_CariHesapAnaDovizBakiye('',0,cari_kod,'','',NULL,NULL,NULL,0) from CARI_HESAPLAR WITH (NOLOCK) where cari_sektor_kodu='PANEK' and cari_Ana_cari_kodu IS NULL