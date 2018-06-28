USE MikroDB_V15_MIKROTEST

DECLARE @seri varchar(30) = 'PN'
DECLARE @sira varchar(30) = '30514785'

--PRINT 'SETER'
SELECT '1 CHH 2 STOKHAR 3 ODEME EMİR' FROM (SELECT name='Nothing') n WHERE 1=1
SELECT * FROM [CARI_HESAP_HAREKETLERI] WHERE cha_evrakno_seri=@seri and cha_evrakno_sira=@sira
SELECT * FROM [STOK_HAREKETLERI] WHERE sth_evrakno_seri=@seri  and sth_evrakno_sira=@sira
SELECT * FROM [ODEME_EMIRLERI] WHERE sck_ilk_evrak_seri=@seri  and sck_ilk_evrak_sira_no=@sira
--SELECT * FROM [ODEME_EMIRLERI]

--SELECT * FROM [CARI_HESAP_HAREKETLERI] WHERE cha_evrakno_seri='NS' and cha_evrakno_sira='14294203'
--SELECT * FROM [STOK_HAREKETLERI] WHERE sth_evrakno_seri='KN'  and sth_evrakno_sira='18276284'


