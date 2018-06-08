--ttn: cari hesap hareketleri kontrol
USE MikroDB_V15_MIKROTEST

--BMTY AKTARIM TABLOLARI
SELECT 'MİKRO BMTY AKTARIM TABLOLARI KONTROL'
SELECT * FROM [CARI_HESAP_HAREKETLERI] --cha : cari hesap hareketleri
SELECT * FROM [CARI_HESAPLAR] --cari: cari kartlar
SELECT * FROM [CARI_HESAP_ADRESLERI] --adr: adresler

SELECT * FROM [ODEME_EMIRLERI]  --sck: senet,çek kayıtları

SELECT * FROM STOKLAR --sto: stok kartları
SELECT * FROM [STOK_HAREKETLERI] -- sth: stok hareketleri
SELECT * FROM DEPOLAR -- dep: depolar

SELECT * FROM [CARI_PERSONEL_TANIMLARI]  --  cari_per : cari personeller
SELECT * FROM BANKALAR -- ban : bankalar
SELECT * FROM [EVRAK_ACIKLAMALARI] -- 
SELECT * FROM KASALAR -- 
SELECT * FROM [BARKOD_TANIMLARI] --



--SELECT * FROM [CARI_PERSONEL_TANIMLARI]

--SELECT cha_evrakno_sira,cha_ilave_edilecek_kdv1,cha_ebelge_cinsi,cha_e_islem_turu FROM [CARI_HESAP_HAREKETLERI]
--SELECT * FROM [CARI_HESAP_HAREKETLERI] WHERE cha_special1='PAV2' AND cha_tarihi='20151231' AND cha_evrak_tip=63
--SELECT * FROM [CARI_HESAP_HAREKETLERI] WHERE cha_special1='PAV2' AND cha_tarihi='20151231' AND cha_evrakno_sira='5685291'
--SELECT * FROM [CARI_HESAP_HAREKETLERI] --WHERE cha_evrakno_seri='DEMO'

