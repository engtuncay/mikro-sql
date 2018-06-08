--ttn: cari hesap hareketleri kontrol
--USE MikroDB_V15_MIKROTEST
USE MikroDB_V15_OZPASDEMO

DECLARE @seri as nvarchar( 50) = 'PN'
DECLARE @sira as nvarchar(50) = '9355144' 
DECLARE @carikod as nvarchar(30) = 'A'
DECLARE @stokkod as nvarchar(30) = 'A'


--BMTY AKTARIM TABLOLARI
SELECT 'MİKRO BMTY AKTARIM TABLOLARI KONTROL'
--cha : carinin hareket dökümleri
SELECT cha_belge_no as belgeno,cha_meblag as mb,cha_evrakno_seri,cha_evrakno_sira,* FROM [CARI_HESAP_HAREKETLERI] WHERE cha_kod='PN327448' --cha_evrakno_seri=@seri and cha_belge_no LIKE '%481%' --and cha_evrakno_sira=@sira 

-- BELGE CHH BİLGİSİ
SELECT cha_belge_no,cha_meblag,cha_evrakno_seri,cha_evrakno_sira,* FROM [CARI_HESAP_HAREKETLERI] WHERE cha_evrakno_seri=@seri and cha_evrakno_sira cha_belge_no LIKE '%481%' --and cha_evrakno_sira=@sira 

-- sth: stok hareketleri
SELECT * FROM [STOK_HAREKETLERI] WHERE sth_evrakno_seri =@seri and sth_evrakno_sira=@sira 
-- odeme emirlere (kredi kartı ve çek için)
SELECT * FROM [ODEME_EMIRLERI] WHERE sck_ilk_evrak_seri =@seri and sck_ilk_evrak_sira_no=@sira  --sck: senet,çek kayıtları

--cari: cari kartlar ve adresleri
--SELECT * FROM [CARI_HESAPLAR] --where cari_kod = @carikod
--SELECT * FROM [CARI_HESAP_ADRESLERI] --where adr_cari_kod= @carikod

--sto: stok kartları ve depolar
--SELECT * FROM STOKLAR --Where sto_kod= @stokkod
--SELECT * FROM DEPOLAR -- dep: depolar

--SELECT * FROM [CARI_PERSONEL_TANIMLARI]  --  cari_per : cari personeller
--SELECT * FROM BANKALAR -- ban : bankalar
--SELECT * FROM [EVRAK_ACIKLAMALARI] -- 
--SELECT * FROM KASALAR -- 
--SELECT * FROM [BARKOD_TANIMLARI] --


--SELECT * FROM [CARI_PERSONEL_TANIMLARI]

--SELECT cha_evrakno_sira,cha_ilave_edilecek_kdv1,cha_ebelge_cinsi,cha_e_islem_turu FROM [CARI_HESAP_HAREKETLERI]
--SELECT * FROM [CARI_HESAP_HAREKETLERI] WHERE cha_special1='PAV2' AND cha_tarihi='20151231' AND cha_evrak_tip=63
--SELECT * FROM [CARI_HESAP_HAREKETLERI] WHERE cha_special1='PAV2' AND cha_tarihi='20151231' AND cha_evrakno_sira='5685291'
--SELECT * FROM [CARI_HESAP_HAREKETLERI] --WHERE cha_evrakno_seri='DEMO'

