


-- tqs 05012018-1413
SELECT cari_RECno, cari_kod , cari_unvan1 , cari_unvan2, ch.cari_temsilci_kodu, ch.cari_bolge_kodu, cari_grup_kodu
, dbo.fn_CariHesapAnaDovizBakiye('',0,cari_kod,'','',NULL,NULL,NULL,0) as nCariBakiyetr
, ch.cari_Ana_cari_kodu 
, cpt.cari_per_adi as cari_per_aditr, cari_sektor_kodu 
 FROM CARI_HESAPLAR ch WITH (NOLOCK)
 LEFT JOIN CARI_PERSONEL_TANIMLARI As cpt WITH (NOLOCK) ON ch.cari_temsilci_kodu = cpt.cari_per_kod
 WHERE ch.cari_sektor_kodu =@_cari_sektor_kodu