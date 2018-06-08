select ANACARI.anacarikod,ANACARI.anacariunvan1,ANACARI.anacarivergino,SUBECH.cari_kod as subecarikod
 ,SUBECH.cari_unvan1 as subecariunvan1,SUBECH.cari_vdaire_no AS subevergino,SUBECH.cari_bolge_kodu as bolgekodu,
 SUBECH.cari_sektor_kodu as sektorkodu
 ,dbo.fn_CariHesapBakiye('',0,SUBECH.cari_kod, '', '' , 0,0 ) as bakiye ,SUBECH.cari_temsilci_kodu as caripersonelkodu, CARIPER.cari_takvim_kodu as grupkodu
 FROM
 (
 select ACH.anacarikod,ANACH.cari_vdaire_no AS anacarivergino,ANACH.cari_unvan1 as anacariunvan1,ANACH.cari_kod as carikod
 from (select DISTINCT cari_Ana_cari_kodu AS anacarikod from [CARI_HESAPLAR] where cari_Ana_cari_kodu<>'' )
 AS ACH
 LEFT JOIN [CARI_HESAPLAR] AS ANACH ON ANACH.cari_kod=ACH.anacarikod
 ) AS ANACARI
 INNER JOIN [CARI_HESAPLAR] AS SUBECH ON SUBECH.cari_Ana_cari_kodu=ANACARI.anacarikod
  LEFT JOIN [CARI_PERSONEL_TANIMLARI] AS CARIPER ON SUBECH.cari_temsilci_kodu = CARIPER.cari_per_kod 
 WHERE anacarikod='MK001'
