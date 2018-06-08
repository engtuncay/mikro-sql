
-- Önemli Tablolar ve Alanları


-- Hareket Tabloları

select top 50 cha_kod,cha_evrak_tip,cha_evrakno_seri,cha_evrakno_sira from [CARI_HESAP_HAREKETLERI]

select top 50 * from [STOK_HAREKETLERI]

select top 50 * from [ODEME_EMIRLERI]

-- Master Tabloları

select top 50 * from [STOKLAR]

select top 50 cari_kod,cari_unvan1,cari_unvan2,cari_temsilci_kodu,cari_sektor_kodu,cari_grup_kodu,cari_bolge_kodu from [CARI_HESAPLAR]

select top 50 * from [CARI_PERSONEL_TANIMLARI]

select top 50 takvim_kodu,takvim_ismi from [TAKVIMLER]

select top 50 * from KASALAR

select top 50 * from DEPOLAR

-- günler tutuluyor
select top 50 * from [CARI_HESAP_BOLGELERI]



