-- tqs 04012018-1041
--Select * from CARI_HESAPLAR_CHOOSE_2A c2 --WHERE msg_S_1032=?
SELECT TOP 100 PERCENT
cari_RECno AS [msg_S_0088] /* KAYIT NO */ ,
cari_kod AS [msg_S_1032] /* CARI KODU */ ,
cari_unvan1 AS [msg_S_1033] /* CARI ÜNVANI */ ,
cari_unvan2 AS [msg_S_1034] /* CARI ÜNVANI 2 */ 
--, dbo.vw_Gendata.Cari_F10da_detay ,
,dbo.fn_CariHesapAnaDovizBakiye('',0,cari_kod,'','',NULL,NULL,NULL,0) AS [msg_S_1530] 
--WHEN Cari_F10da_detay = 2 Then dbo.fn_CariHesapAlternatifDovizBakiye('',0,cari_kod,'','',NULL,NULL,NULL,0)
--WHEN Cari_F10da_detay = 3 Then dbo.fn_CariHesapOrjinalDovizBakiye('',0,cari_kod,'','',0,NULL,NULL,0)
--WHEN Cari_F10da_detay = 4 Then dbo.fn_CariHareketSayisi(0,cari_kod,'')
--END AS [msg_S_1530] /* BAKİYE / HAREKET SAYISI */ ,
,CariBaglantiIsim AS [msg_S_3171] /* BAĞLANTI TİPİ */ ,
CariHareketIsim AS [msg_S_0888] /* HAREKET TİPİ */
,dbo.[CARI_HESAPLAR].cari_temsilci_kodu
FROM dbo.CARI_HESAPLAR WITH (NOLOCK)
LEFT OUTER JOIN dbo.vw_Cari_Hesap_Baglanti_Tip_Isimleri ON CariBaglantiNo=cari_baglanti_tipi
LEFT OUTER JOIN dbo.vw_Cari_Hesap_Hareket_Tip_Isimleri ON CariHareketNo=cari_hareket_tipi
--LEFT OUTER JOIN dbo.vw_Gendata ON 1=1
WHERE cari_kod='001' -- ?
ORDER BY cari_kod