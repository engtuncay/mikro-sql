--SELECT cari_sektor_kodu,cari_kod,cari_unvan1 ,* FROM [CARI_HESAPLAR] WHERE cari_unvan1 LIKE '%OLİ%'

USE MikroDB_V15_OZPASDEMO

--select dbo.fn_entCariOrtGecikmeAnacarili('K20973',114971.77, 'KENT') as gecikme

-- Örnek Cari Kodlar
-- PN95889 : Oli Şubesi 
-- PN96184 : Dostlar Gıda 
-- PN293183 : Tuğra Center

select dbo.fn_entCariGunGecikmeAnacarili('MK001',45,'PANEK') as gecikmeTutar


