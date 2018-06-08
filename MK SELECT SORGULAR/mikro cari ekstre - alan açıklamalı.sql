Select 
[msg_S_0088] as cha_RECno -- KAYIT NO
--,cha_RECid_DBCno AS [#msg_S_0720], --DBCNO
--cha_RECid_RECno AS [#msg_S_0998], --DATABASE NO
,[#msg_S_0200] as cha_kod -- CARİ KODU
,[#msg_S_0201] as ch_unvan
--dbo.fn_CarininIsminiBul(cha_cari_cins, cha_kod) AS [#msg_S_0201], -- CARİ İSMİ
,[#msg_S_0879] as mikrofirmaunvan --(select fir_unvan from dbo.FIRMALAR WITH (NOLOCK) where fir_sirano=cha_firmano) AS [#msg_S_0879], -- FİRMA UNVANI
,[msg_S_0089] as cha_tarihi -- TARİH
,[msg_S_0090] as cha_evrakno_seri -- SERİ
,[msg_S_0091] as cha_evrakno_sira -- SIRA
,[#msg_S_0092] as cha_belge_tarih -- BELGE TARİHİ
,[#msg_S_0093] as cha_belge_no -- BELGE NO
,[msg_S_0094] as CHEvrUzunIsim -- EVRAK TİPİ
,[msg_S_0003] as CHCinsIsim -- CİNSİ
,[#msg_S_0158] as cha_cinsi -- HAREKET CİNSİ
,[#msg_S_0096] as NORMALCARIGRUP -- GRUBU
,[#msg_S_1712] as cha_grupno -- CARİ HESAP GRUP NO
,[msg_S_0118] as cha_srmrkkodu -- SRM.MRK.KODU
,[msg_S_0119] as sormeradi -- SRM.MRK.İSMİ
--dbo.fn_SorumlulukMerkeziIsmi(cha_srmrkkodu) , -- SRM.MRK.İSMİ
,[msg_S_0097] as NIIsim -- N/İ
,[#msg_S_0085] as cha_aciklama -- AÇIKLAMA
,[msg_S_1129] as cha_satici_kodu -- SORUMLU KODU
,[msg_S_1130] as sorumluisim -- SORUMLU İSMİ
--dbo.fn_CarininIsminiBul(1,cha_satici_kodu) AS [msg_S_1130], -- SORUMLU İSMİ
,[msg_S_0098] as CHA_VADE_TARIHI -- VADE TARİH
,[msg_S_1706] as bakiyeborc -- ANA DÖVİZ BORÇ BAKİYE
,[msg_S_1707] as bakiyealacak -- ANA DÖVİZ ALACAK BAKİYE
,[#msg_S_0957] as bakiye -- ANA DÖVİZ BAKİYE
,[msg_S_1129] as cha_satici_kodu -- SORUMLU KODU
,[msg_S_1130] as sorumluismi -- SORUMLU İSMİ
--dbo.fn_CarininIsminiBul(1,cha_satici_kodu) , -- SORUMLU İSMİ
,[msg_S_0098] as CHA_VADE_TARIHI -- VADE TARİH
,[msg_S_0099] as vadegun -- VADE GÜN
--DATEDIFF(Day,cha_tarihi,CHA_VADE_TARIHI) AS [msg_S_0099], 
,[#msg_S_0159] as depo --'' AS [#msg_S_0159], -- DEPO
--,[#msg_S_0165] as cha_miktari -- MİKTAR
,[msg_S_0100] as CHTipIsim -- B/A
,[msg_S_0101\T] as meblagborc -- ANA DÖVİZ BORÇ
,[msg_S_0102\T] as meblagalacak -- ANA DÖVİZ ALACAK
,[#msg_S_0103\T] as meblagbakiye -- ANA DÖVİZ TUTAR
--CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ANA ELSE 0 END AS [msg_S_0101\T], -- ANA DÖVİZ BORÇ
--CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ANA ELSE 0 END AS [msg_S_0102\T], -- ANA DÖVİZ ALACAK
--CASE WHEN CHA_CARI_BORC_ALACAK_TIP=0 THEN CHA_CARI_MEBLAG_ANA
--WHEN CHA_CARI_BORC_ALACAK_TIP=1 THEN CHA_CARI_MEBLAG_ANA * (-1.0)   -- ALACAK İSE -1 ile çarpıyor
--ELSE 0
--END AS [#msg_S_0103\T], -- ANA DÖVİZ TUTAR
,[msg_S_1710] as orjdovizborc -- ORJINAL DÖVİZ BORÇ BAKİYE
,[msg_S_1711] as orjdovizalacak -- ORJINAL DÖVİZ ALACAK BAKİYE
,[#msg_S_1715] as orjdovizbakiye -- ORJINAL DÖVİZ BAKİYE
,[msg_S_0112] as CHA_NORMAL_CARI_DOVIZ_SEMBOLU -- ORJ.DOVİZ
from dbo.fn_CariFoy (N'0',0,N'001',NULL,'20171116','20171116','20171231',0,N'') 
Order by [msg_S_0089] /* TARİH */ ,[msg_S_0094] /* EVRAK TİPİ */ ,[msg_S_0090] /* SERİ */ ,[msg_S_0091] /* SIRA */


