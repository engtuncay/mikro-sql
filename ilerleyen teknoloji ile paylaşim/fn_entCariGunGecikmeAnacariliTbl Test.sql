--SELECT cari_sektor_kodu,cari_kod,cari_unvan1 ,* FROM [CARI_HESAPLAR] WHERE cari_unvan1 LIKE '%OLİ%'

USE MikroDB_V15_OZPAS

-- Örnek Cari Kodlar
-- PN95889 : Oli Şubesi 
-- PN96184 : Dostlar Gıda 
-- PN293183 : Tuğra Center

select TOP 30 x.*,y.* from CARI_HESAPLAR ch 
CROSS APPLY fn_entCariGunGecikmeAnacariliTbl(ch.cari_kod, 80, 'PANEK') as x
OUTER APPLY ( select TOP 1 cari_temsilci_kodu from [CARI_HESAPLAR] 
WHERE cari_sektor_kodu='PANEK' and (cari_Ana_cari_kodu=ch.cari_kod or cari_kod=ch.cari_kod)
and cari_temsilci_kodu<>'' and cari_temsilci_kodu IS NOT NULL ) as y
where (cari_sektor_kodu='PANEK' and (cari_Ana_cari_kodu IS NULL or ch.cari_Ana_cari_kodu='')) 
or ( ch.cari_kod IN ( select DISTINCT cari_Ana_cari_kodu from [CARI_HESAPLAR] ch2 WITH(NOLOCK) 
where cari_sektor_kodu='PANEK' and ch2.cari_Ana_cari_kodu<>'' and NOT ch2.cari_Ana_cari_kodu IS NULL ))




--select ch.cari_kod, x.*,y.* from CARI_HESAPLAR ch 
--CROSS APPLY fn_entCariGunGecikmeAnacariliTbl(ch.cari_kod, 0, 'PANEK') as x

--WHERE cari_Ana_cari_kodu=ch.cari_kod and cari_sektor_kodu='PANEK' 
--and cari_temsilci_kodu<>'' and cari_temsilci_kodu IS NOT NULL ) as y
--where ch.cari_kod IN ( select DISTINCT cari_Ana_cari_kodu from [CARI_HESAPLAR] ch2 WITH(NOLOCK) 
--where cari_sektor_kodu='PANEK' and ch2.cari_Ana_cari_kodu<>'' and NOT ch2.cari_Ana_cari_kodu IS NULL )

