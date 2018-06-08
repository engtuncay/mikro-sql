


DECLARE @_cari_Ana_cari_kodu AS varchar(20) ='MK049'
DECLARE @_cari_sektor_kodu AS varchar(20) ='NESTLE'
DECLARE @_cha_tarihiBas AS date ='20180501'
DECLARE @_cha_tarihiSon AS date ='20180531'


SELECT 
 sum(cb.devirbakiye) as nCariBakiyetr
 , MAX((cpt.cari_per_adi +' ' + cpt.cari_per_soyadi)) as cari_per_aditr
 --, cari_RECno /* KAYIT NO */
 --, cari_kod /* CARI KODU */ 
 , MAX(anacari.cari_unvan1) as cari_unvan1 
 , MAX(anacari.cari_unvan2) as cari_unvan2 
 , MAX(ch.cari_Ana_cari_kodu) as cari_Ana_cari_kodu 
 --, ch.cari_temsilci_kodu
 --, ch.cari_bolge_kodu
 , MAX(ch.cari_sektor_kodu) as cari_sektor_kodu 
 FROM CARI_HESAPLAR AS ch WITH (NOLOCK)
 LEFT JOIN dbo.CARI_PERSONEL_TANIMLARI As cpt ON ch.cari_temsilci_kodu = cpt.cari_per_kod
 LEFT JOIN [CARI_HESAPLAR] anacari ON ch.cari_Ana_cari_kodu = anacari.cari_kod
 OUTER APPLY (select dbo.fn_CariHesapAnaDovizBakiye('', 0, ch.cari_kod, '', '', 0,''/*bastarih*/,@_cha_tarihiSon /*son tarih*/, 0) as devirbakiye) as cb /* [msg_S_1530] BAKİYE / HAREKET SAYISI */
 where ch.cari_Ana_cari_kodu =@_cari_Ana_cari_kodu and ch.cari_sektor_kodu =@_cari_sektor_kodu
