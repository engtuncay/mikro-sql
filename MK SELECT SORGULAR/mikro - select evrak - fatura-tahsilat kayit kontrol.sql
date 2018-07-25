--USE MikroDB_V15_MIKROTEST
USE MikroDB_V15_OZPAS
-- STOK,CARI,ODEME - -- kontrol edilecek kayıt seri ve sira nosunu giriniz
--PN-22313487
--KN 15143072
--SF NS - 25885085

DECLARE @seri as nvarchar(50) = 'KN'
DECLARE @sira as nvarchar(50) = '16792789'
DECLARE @cha_evrak_tip as INT = 64     -- 63 sf 64 çek

--

--SELECT * FROM CARI_HESAP_HAREKETLERI
--KN	15417971

--SELECT 'KONTROL SORGULARI'
SELECT cha_evrak_tip as et,cha_satir_no as sn,cha_evrakno_seri as seri,cha_evrakno_sira as sira,cha_meblag
,cha_special1 as sp1 ,cha_special2 as sp2, cha_special3 as sp3 ,cha_create_date as cd, * FROM CARI_HESAP_HAREKETLERI where cha_evrakno_seri =@seri 
and cha_evrak_tip=@cha_evrak_tip and cha_evrakno_sira=@sira
ORDER BY cha_evrak_tip,cha_satir_no

--SELECT * FROM STOK_HAREKETLERI where sth_evrakno_seri =@seri and sth_evrakno_sira=@sira
--SELECT * FROM ODEME_EMIRLERI where sck_ilk_evrak_seri =@seri and sck_ilk_evrak_sira_no=@sira
