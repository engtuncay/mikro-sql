

--select TOP 10 * from [CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_01]

select TOP 10 cha_evrakno_seri,cha_evrakno_sira,[NORMALTIP],[NORMALCARICINS],cha_kod,[NORMALCARIGRUP],[CHEvrUzunIsim]
,[CHEvrKisaIsim],cha_karsidcinsi,cha_kasa_hizkod,[KARSICARICINS],[KARSITIP],[KARSICARIGRUP],cha_meblag,[CHA_TERS_EVRAKMI],[CHA_KARSI_CARI_MEBLAG_ANA]
from [CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_02] WHERE [CHA_TERS_EVRAKMI]=1

SELECT cari_RECno, cari_kod , cari_unvan1 , cari_unvan2, ch.cari_temsilci_kodu, ch.cari_bolge_kodu
, dbo.fn_CariHesapAnaDovizBakiye('',0,cari_kod,'','',NULL,NULL,NULL,0) as nCariBakiyetr
, ch.cari_Ana_cari_kodu 
, cpt.cari_per_adi as cari_per_aditr 
FROM CARI_HESAPLAR ch WITH (NOLOCK)
LEFT JOIN CARI_PERSONEL_TANIMLARI As cpt WITH ( NOLOCK) ON ch.cari_temsilci_kodu = cpt.cari_per_kod
WHERE ch.cari_sektor_kodu = 'NS' --:" + Qprm.sormerkisa.toString()
ORDER BY cari_kod


