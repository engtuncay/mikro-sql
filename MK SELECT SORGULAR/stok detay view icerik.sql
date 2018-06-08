USE [MikroDB_V15_OZPAS];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE VIEW [dbo].[STOKDETAY2]
AS
SELECT TOP 100 PERCENT
sto_RECno AS [#msg_S_1588] /* STOK KAYIT NO*/,
sto_kod AS [msg_S_0001] /* STOK KODU */ ,
sto_isim AS [msg_S_0002] /* STOK İSMİ */ ,
dbo.fn_StokCins(sto_cins) AS [msg_S_0003] /* CİNSİ */ ,
dbo.fn_DovizIsmi(sto_doviz_cinsi) AS [msg_S_1589] /* STOK DOVİZ CİNSİ*/,
sto_kisa_ismi AS [msg_S_0004] /* KISA İSMİ */ ,
sto_yabanci_isim AS [msg_S_0005] /* YABANCI İSMİ */ ,
ISNULL(sfiyat_fiyati,0) AS [msg_S_0006] /* FİYAT */,
Kur_adi AS [msg_S_1693] /* FİYAT DÖVİZ*/,
sto_min_stok [msg_S_0007] /* MİN. SEVİYE */ ,
sto_siparis_stok[msg_S_0008] /* SİPARİŞ SEVİYESİ */ ,
sto_max_stok [msg_S_0009] /* MAX. SEVİYE */ ,
sto_birim1_ad AS [msg_S_0010] /* BİRİM */ ,
sto_kategori_kodu AS [msg_S_0011] /* KATEGORİ KODU */ ,
ISNULL(STOK_KATEGORILERI.ktg_isim,'-') AS [msg_S_0012] /* KATEGORİ İSMİ */ ,
sto_anagrup_kod AS [msg_S_0013] /* ANA GRUP KODU */ ,
ISNULL(STOK_ANA_GRUPLARI.san_isim,'-') AS [msg_S_0014] /* ANA GRUP İSMİ */ ,
sto_altgrup_kod AS [msg_S_0015] /* ALT GRUP KODU */ ,
ISNULL(STOK_ALT_GRUPLARI.sta_isim,'-') AS [msg_S_0785] /* ALT GRUP ISMI */,
sto_urun_sorkod AS [msg_S_0016] /* ÜRÜN SORUMLUSU KODU */ ,
dbo.fn_PersFullName(1,sto_urun_sorkod) AS [msg_S_0017] /* ÜRÜN SORUMLUSU İSMİ */ ,
sto_uretici_kodu AS [msg_S_0018] /* ÜRETİCİ KODU */ ,
STOK_URETICILERI.urt_ismi AS [msg_S_0019] /* ÜRETİCİ İSMİ */ ,
sto_reyon_kodu AS [msg_S_0020] /* REYON KODU */ ,
STOK_REYONLARI.ryn_ismi AS [msg_S_0021] /* REYON İSMİ */ ,
sto_sektor_kodu AS [msg_S_0022] /* SEKTÖR KODU */ ,
STOK_SEKTORLERI.sktr_ismi AS [msg_S_0023] /* SEKTÖR İSMİ */ ,
sto_marka_kodu AS [msg_S_0024] /* MARKA KODU */ ,
STOK_MARKALARI.mrk_ismi AS [msg_S_0025] /* MARKA İSMİ */ ,
sto_muhgrup_kodu AS [msg_S_0026] /* MUHASEBE GRUP KODU */ ,
STOK_MUHASEBE_GRUPLARI.stmuh_ismi AS [msg_S_0027] /* MUHASEBE GRUP İSMİ */ ,
sto_ambalaj_kodu AS [msg_S_0028] /* AMBALAJ KODU */ ,
STOK_AMBALAJLARI.amb_ismi AS [msg_S_0029] /* AMBALAJ İSMİ */ ,
sto_kalkon_kodu AS [msg_S_0030] /* KALİTE KONTROL KODU */ ,
STOK_KALITE_KONTROL_TANIMLARI.KKon_ismi AS [msg_S_0031] /* KALİTE KONTROL İSMİ */ ,
sto_sat_cari_kod AS [msg_S_0032] /* SATICI CARİ KODU */ ,
SATICI.cari_unvan1 AS [msg_S_0033] /* SATICI CARİ İSMİ */ ,
sto_beden_kodu AS [msg_S_0034] /* BEDEN KODU */ ,
STOK_BEDEN_TANIMLARI.bdn_ismi AS [msg_S_0035] /* BEDEN İSMİ */ ,
sto_renk_kodu AS [msg_S_0036] /* RENK KODU */ ,
STOK_RENK_TANIMLARI.rnk_ismi AS [msg_S_0037] /* RENK İSMİ */ ,
sto_model_kodu AS [msg_S_0038] /* MODEL KODU */ ,
STOK_MODEL_TANIMLARI.mdl_ismi AS [msg_S_0039] /* MODEL İSMİ */ ,
sto_sezon_kodu AS [msg_S_0040] /* SEZON KODU */ ,
STOK_YILSEZON_TANIMLARI.ysn_ismi AS [msg_S_0041] /* SEZON İSMİ */ ,
sto_hammadde_kodu AS [msg_S_0042] /* HAMMADDE KODU */ ,
STOK_ANAHAMMADDELERI.ahm_ismi AS [msg_S_0043] /* HAMMADDE İSMİ */ ,
sto_prim_kodu AS [msg_S_1122] /* PRİM KODU */ ,
STOK_PRIM_TANIMLARI.prim_adi AS [msg_S_1123] /* PRİM KODU */,
sto_muh_kod As [msg_S_0044] /* MUHASEBE KODU */ ,
dbo.fn_MuhasebeHesapIsminiBul(sto_muh_kod) AS [msg_S_1694] /* MUHASEBE HESAP İSMİ */ ,
sto_muh_Iade_kod     AS [msg_S_1871] /*STOK İADE MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_muh_Iade_kod)     AS [msg_S_1885] /*STOK İADE MUHASEBE İSMİ*/,
sto_muh_sat_muh_kod  AS [msg_S_1872] /*YURT İÇİ SATIŞ MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_muh_sat_muh_kod)  AS [msg_S_1886] /*YURT İÇİ SATIŞ MUHASEBE İSMİ*/,
sto_yurtdisi_satmuhk AS [msg_S_1873] /*YURT DIŞI SATIŞ MUHASEBE KODU */,
dbo.fn_MuhasebeHesapIsminiBul(sto_yurtdisi_satmuhk) AS [msg_S_1887] /*YURT DIŞI SATIŞ MUHASEBE İSMİ */,
sto_muh_satIadmuhkod  AS [msg_S_1874] /*SATIŞ İADE MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_muh_satIadmuhkod)  AS [msg_S_1888] /*SATIŞ İADE MUHASEBE İSMİ*/,
sto_muh_sat_isk_kod  AS [msg_S_1875] /*SATIŞ İSKONTO MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_muh_sat_isk_kod)  AS [msg_S_1889] /*SATIŞ İSKONTO MUHASEBE İSMİ*/,
sto_muh_aIiskmuhkod AS [msg_S_1876] /*ALIŞ İSKONTO MUHASEBE KODU */,
dbo.fn_MuhasebeHesapIsminiBul(sto_muh_aIiskmuhkod) AS [msg_S_1890] /*ALIŞ İSKONTO MUHASEBE İSMİ */,
sto_muh_satmalmuhkod AS [msg_S_1877] /*SATILAN MAL MALİYETİ MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_muh_satmalmuhkod) AS [msg_S_1891] /*SATILAN MAL MALİYETİ MUHASEBE İSMİ*/,
sto_ilavemasmuhkod   AS [msg_S_1878] /*İLAVE MASRAF MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_ilavemasmuhkod)   AS [msg_S_1892] /*İLAVE MASRAF MUHASEBE İSMİ*/,
sto_yatirimtesmuhkod AS [msg_S_1879] /*YATIRIM TEŞVİK MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_yatirimtesmuhkod) AS [msg_S_1893] /*YATIRIM TEŞVİK MUHASEBE İSMİ*/,
sto_depsatmuhkod     AS [msg_S_1880] /*DEPOLAR ARASI SATIŞ MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_depsatmuhkod)     AS [msg_S_1894] /*DEPOLAR ARASI SATIŞ MUHASEBE İSMİ*/,
sto_depsatmalmuhkod  AS [msg_S_1881] /*DEPOLAR ARASI SATIŞ MALİYETİ MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_depsatmalmuhkod)  AS [msg_S_1895] /*DEPOLAR ARASI SATIŞ MALİYETİ MUHASEBE İSMİ*/,
sto_bagortsatmuhkod  AS [msg_S_1882] /*BAĞLI ORTAKLIKLARA YAPILAN SATIŞ MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_bagortsatmuhkod)  AS [msg_S_1896] /*BAĞLI ORTAKLIKLARA YAPILAN SATIŞ MUHASEBE İSMİ*/,
sto_satfiyfarkmuhkod AS [msg_S_1883] /*SATIŞ FİYAT FARKI MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_satfiyfarkmuhkod) AS [msg_S_1897] /*SATIŞ FİYAT FARKI MUHASEBE İSMİ*/,
sto_yurtdisisatmalmuhkod AS [msg_S_2065] /*YURT DIŞI SATILAN MAL MALİYETİ MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_yurtdisisatmalmuhkod) AS [msg_S_2067] /*YURT DIŞI SATILAN MAL MALİYETİ MUHASEBE HESAP İSMİ*/,
sto_bagortsatmalmuhkod AS [msg_S_2066] /*BAĞLI ORTAKLIKLARA YAPILAN SATILAN MAL MALİYETİ MUHASEBE KODU*/,
dbo.fn_MuhasebeHesapIsminiBul(sto_bagortsatmalmuhkod) AS [msg_S_2068] /*BAĞLI ORTAKLIKLARA YAPILAN SATILAN MAL MALİYETİ MUHASEBE  HESAP İSMİ*/
FROM dbo.STOKLAR WITH (NOLOCK)
LEFT OUTER JOIN STOK_KATEGORILERI STOK_KATEGORILERI ON
(STOK_KATEGORILERI.ktg_kod = sto_kategori_kodu)
LEFT OUTER JOIN STOK_SEKTORLERI STOK_SEKTORLERI ON
(STOK_SEKTORLERI.sktr_kod = sto_sektor_kodu)
LEFT OUTER JOIN STOK_ANA_GRUPLARI STOK_ANA_GRUPLARI ON
(STOK_ANA_GRUPLARI.san_kod = sto_anagrup_kod)
LEFT OUTER JOIN STOK_ALT_GRUPLARI STOK_ALT_GRUPLARI ON
(STOK_ALT_GRUPLARI.sta_ana_grup_kod = sto_anagrup_kod AND STOK_ALT_GRUPLARI.sta_kod = sto_altgrup_kod)
LEFT OUTER JOIN STOK_URETICILERI STOK_URETICILERI ON
(STOK_URETICILERI.urt_kod = sto_uretici_kodu)
LEFT OUTER JOIN STOK_REYONLARI STOK_REYONLARI ON
(STOK_REYONLARI.ryn_kod = sto_reyon_kodu)
LEFT OUTER JOIN STOK_MARKALARI STOK_MARKALARI ON
(STOK_MARKALARI.mrk_kod = sto_marka_kodu)
LEFT OUTER JOIN STOK_MUHASEBE_GRUPLARI STOK_MUHASEBE_GRUPLARI ON
(STOK_MUHASEBE_GRUPLARI.stmuh_kod = sto_muhgrup_kodu)
LEFT OUTER JOIN STOK_AMBALAJLARI STOK_AMBALAJLARI ON
(STOK_AMBALAJLARI.amb_kod = sto_ambalaj_kodu)
LEFT OUTER JOIN STOK_KALITE_KONTROL_TANIMLARI STOK_KALITE_KONTROL_TANIMLARI ON
(STOK_KALITE_KONTROL_TANIMLARI.KKon_kod = sto_kalkon_kodu)
LEFT OUTER JOIN dbo.CARI_HESAPLAR SATICI ON
(SATICI.cari_kod = sto_sat_cari_kod)
LEFT OUTER JOIN STOK_RENK_TANIMLARI STOK_RENK_TANIMLARI ON
(STOK_RENK_TANIMLARI.rnk_kodu = sto_renk_kodu )
LEFT OUTER JOIN STOK_MODEL_TANIMLARI STOK_MODEL_TANIMLARI ON
(STOK_MODEL_TANIMLARI.mdl_kodu = sto_model_kodu )
LEFT OUTER JOIN STOK_YILSEZON_TANIMLARI STOK_YILSEZON_TANIMLARI ON
(STOK_YILSEZON_TANIMLARI.ysn_kodu = sto_sezon_kodu)
LEFT OUTER JOIN STOK_ANAHAMMADDELERI STOK_ANAHAMMADDELERI ON
(STOK_ANAHAMMADDELERI.ahm_kodu = sto_hammadde_kodu)
LEFT OUTER JOIN STOK_BEDEN_TANIMLARI STOK_BEDEN_TANIMLARI ON
(STOK_BEDEN_TANIMLARI.bdn_kodu = sto_beden_kodu)
OUTER APPLY ( SELECT TOP 1 prim_adi FROM STOK_PRIM_TANIMLARI WHERE prim_kod = sto_prim_kodu ) STOK_PRIM_TANIMLARI
LEFT OUTER JOIN dbo.STOK_SATIS_FIYATLARI_F1_D0_VIEW ON
STOK_SATIS_FIYATLARI_F1_D0_VIEW.sfiyat_stokkod = sto_kod
LEFT OUTER JOIN MikroDB_V15.dbo.KUR_ISIMLERI ON
KUR_ISIMLERI.Kur_No =  ISNULL(STOK_SATIS_FIYATLARI_F1_D0_VIEW.sfiyat_doviz,0)
GO
