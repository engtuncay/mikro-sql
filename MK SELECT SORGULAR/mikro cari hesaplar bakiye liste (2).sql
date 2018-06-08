-- tqs 05012018-1413

-- bakiye alanını where de kullanmak için
Select cari_RECno, cari_kod , cari_unvan1 , cari_unvan2, chbakiye.bakiye, ch.cari_temsilci_kodu, ch.cari_bolge_kodu
FROM [CARI_HESAPLAR] ch WITH (NOLOCK)
LEFT JOIN CARI_PERSONEL_TANIMLARI As cpt WITH ( NOLOCK) ON ch.cari_temsilci_kodu = cpt.cari_per_kod
OUTER APPLY (select dbo.fn_CariHesapBakiye( '', 0,ch.cari_kod, '', '' , NULL ,0 ) as bakiye ) as chbakiye
WHERE bakiye> 0.25 or bakiye < (- 0.25 ) and ch.cari_sektor_kodu='NS'
ORDER BY bakiye desc


SELECT cari_RECno, cari_kod , cari_unvan1 , cari_unvan2, ch.cari_temsilci_kodu, ch.cari_bolge_kodu
, dbo.fn_CariHesapAnaDovizBakiye('',0,cari_kod,'','',NULL,NULL,NULL,0) as bakiye
, ch.cari_Ana_cari_kodu 
FROM CARI_HESAPLAR ch WITH (NOLOCK)
WHERE ch.cari_sektor_kodu = 'NS' --: + Qprm.Sormerkisa.toString() + 
ORDER BY cari_kod



--Select * from CARI_HESAPLAR_CHOOSE_2A c2 --WHERE msg_S_1032=?

--OUTER APPLY (select top 1 chh.cha_satici_kodu as saticikodu from [CARI_HESAP_HAREKETLERI] as chh WITH ( NOLOCK)
 --where chh.cha_kod= rutdisi.cari_kod order by cha_RECno desc ) as satici
 -- as satici on 1=1

--SELECT
--cari_RECno , cari_kod , cari_unvan1 , cari_unvan2
--, dbo.fn_CariHesapAnaDovizBakiye('',0,cari_kod,'','',NULL,NULL,NULL,0) as bakiye
--, cari_temsilci_kodu
--FROM dbo.CARI_HESAPLAR WITH (NOLOCK)
---LEFT OUTER JOIN dbo.vw_Gendata ON 1=1
--WHERE bakiye > 0.25 or bakiye < -0.25
--ORDER BY cari_kod

-- where alanlar
--cari_kod='001' -- ?

-- hariç tutalan alanlar
--, dbo.vw_Gendata.Cari_F10da_detay ,
--WHEN Cari_F10da_detay = 2 Then dbo.fn_CariHesapAlternatifDovizBakiye('',0,cari_kod,'','',NULL,NULL,NULL,0)
--WHEN Cari_F10da_detay = 3 Then dbo.fn_CariHesapOrjinalDovizBakiye('',0,cari_kod,'','',0,NULL,NULL,0)
--WHEN Cari_F10da_detay = 4 Then dbo.fn_CariHareketSayisi(0,cari_kod,'')
--END AS [msg_S_1530] /* BAKİYE / HAREKET SAYISI */ ,

--,CariBaglantiIsim AS [msg_S_3171] /* BAĞLANTI TİPİ */ ,
--CariHareketIsim AS [msg_S_0888] /* HAREKET TİPİ */
--LEFT OUTER JOIN dbo.vw_Cari_Hesap_Baglanti_Tip_Isimleri ON CariBaglantiNo=cari_baglanti_tipi
--LEFT OUTER JOIN dbo.vw_Cari_Hesap_Hareket_Tip_Isimleri ON CariHareketNo=cari_hareket_tipi

