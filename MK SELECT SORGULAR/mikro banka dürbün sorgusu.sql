--select * from KASALAR_CHOOSE_2A
--select * from BANKALAR_CHOOSE_3A

SELECT TOP 100 PERCENT
[msg_S_0088] as ban_RECno  /* KAYIT NO */ ,
[msg_S_0070] as ban_ismi /* İSMİ */ ,
[msg_S_0078] as ban_kod /* KODU */ ,
[msg_S_1263] as ban_firma_no  /* FİRMA NO */ ,
[msg_S_0822] as ban_sube  /* ŞUBE */ ,
[msg_S_0771] as ban_hesapno   /* HESAP NO */ ,
[msg_S_0849] as ban_doviz_cinsi /* DÖVİZ CİNSİ */ ,
[msg_S_1530] as bakiyetr
--CASE
--WHEN Cari_F10da_detay = 1 Then dbo.fn_CariHesapAnaDovizBakiye(ban_firma_no,2,ban_kod,'','',1,NULL,NULL,0)
--WHEN Cari_F10da_detay = 2 Then dbo.fn_CariHesapAlternatifDovizBakiye(ban_firma_no,2,ban_kod,'','',1,NULL,NULL,0)
--WHEN Cari_F10da_detay = 3 Then dbo.fn_CariHesapOrjinalDovizBakiye(ban_firma_no,2,ban_kod,'','',1,NULL,NULL,0)
--WHEN Cari_F10da_detay = 4 Then dbo.fn_CariHareketSayisi(2,ban_kod,'')
--END AS [msg_S_1530] /* BAKİYE / HAREKET SAYISI */ ,
--ban_TCMB_Kodu AS [#msg_S_0843] /* TCMB BANKALAR KODU */
FROM BANKALAR_CHOOSE_3A