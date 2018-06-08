-- tqs 08012018-1400
-- tarihli cari hesap bakiye
 SELECT TOP 100 PERCENT
 cb.devirbakiye as nCariBakiyetr
 , (cpt.cari_per_adi +' ' + cpt.cari_per_soyadi) as cari_per_aditr
 , cari_RECno /* KAYIT NO */
 , cari_kod /* CARI KODU */ 
 , cari_unvan1 
 , cari_unvan2 
 , ch.cari_Ana_cari_kodu
 , ch.cari_temsilci_kodu
 , ch.cari_bolge_kodu
 , ch.cari_sektor_kodu
 FROM CARI_HESAPLAR AS ch WITH (NOLOCK)
 LEFT JOIN dbo.CARI_PERSONEL_TANIMLARI As cpt ON ch.cari_temsilci_kodu = cpt.cari_per_kod
 OUTER APPLY (select dbo.fn_CariHesapAnaDovizBakiye('', 0, ch.cari_kod, '', '', 0,'20140101' --: + Qprm.dateBegin.toString() + 
 ,'20171231' --:+ Qprm.dateEnd.toString() + /* bitiş tarih */
 , 0) as devirbakiye) as cb /* [msg_S_1530] BAKİYE / HAREKET SAYISI */
 where ch.cari_sektor_kodu ='DG' -- : + Qprm.sormerkisa.toString(); 
 and ((NOT (ch.cari_temsilci_kodu = '' OR ch.cari_temsilci_kodu IS NULL)
 and NOT (ch.cari_bolge_kodu = '' OR ch.cari_bolge_kodu IS NULL)) OR NOT (ch.cari_Ana_cari_kodu = '' OR ch.cari_Ana_cari_kodu IS NULL)
 /* şubeli cariler ruta tanımlı olmasa da eklendi. */ )

 
 -- select içinden alınan sütunlar
 --dbo.fn_CariHesapBakiye('',0,cari_kod, '', '' , 0,0 )
 --dbo.fn_CariTip(cari_tipi) AS [msg_S_0077] /* TİPİ */ ,
 --dbo.fn_CariHareketTip(cari_hareket_tipi) AS [msg_S_0888] /* HAREKET TİPİ */
 --,dbo.fn_CariHesapAnaDovizBakiye('', 0, ch.cari_kod, '', '', 0, '20140101' /* ? --baş tarih */ , '20171231' /* --? -- bitiş tarih */ , 0) as bakiye
 
 
 -- rut bilgisi adresten alınırsa
 --,ca.adr_temsilci_kodu, ca.adr_ziyaretgunu,ca.adr_ziyaretperyodu
 --OUTER APPLY (SELECT TOP 1 * FROM dbo.CARI_HESAP_ADRESLERI ca WHERE ch.cari_kod = ca.adr_cari_kod ) as ca 
 --cpt.cari_takvim_kodu = 'NS'
--dbo.fn_CariHesapAnaDovizBakiye fonksiyonunun içeriği

/*
Declare @Borc as float
Declare @Alacak as float
IF (@ODEMEEMRIDEGERLEMEDOK>0) OR
(@CARICINSI IN (5,9)) OR
(NOT(@ILKTARIH IS NULL)) OR
(NOT(@SONTARIH IS NULL))
BEGIN
Select @Borc   = SUM([msg_S_0101\T] /* ANA DÖVİZ BORÇ */ ),
@Alacak = SUM([msg_S_0102\T] /* ANA DÖVİZ ALACAK */ )
FROM dbo.fn_CariTutarlar (@FIRMALAR, @CARICINSI, @CARIKODU, @GRUPNO, @ILKTARIH, @SONTARIH , @ODEMEEMRIDEGERLEMEDOK , @SORMERKKODU, @PROJEKODU)
END
ELSE SET @Borc = dbo.fn_CariHesapBakiye(@FIRMALAR , @CARICINSI , @CARIKODU , @SORMERKKODU , @PROJEKODU , @GRUPNO , 0 )
RETURN ISNULL(@Borc,0) - ISNULL(@Alacak,0)
*/

/*
RETURN
(
-- Cari kod indeksine göre olan kayıtlar
SELECT  TOP 100 PERCENT
cha_RECno AS [msg_S_0088], -- KAYIT NO
cha_tarihi AS [msg_S_0089], -- TARİH
cha_cinsi AS [#msg_S_0095], -- CİNS
cha_grupno AS [#msg_S_1712], -- CARİ HESAP GRUP NO
cha_srmrkkodu AS [msg_S_0118], -- SRM.MRK.KODU
cha_projekodu AS [msg_S_0116], -- PROJE KODU
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ANA ELSE 0 END AS [msg_S_0101\T], -- ANA DÖVİZ BORÇ
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ANA ELSE 0 END AS [msg_S_0102\T], -- ANA DÖVİZ ALACAK
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ALT ELSE 0 END AS [msg_S_0105\T], -- ALT. DÖVİZ BORÇ
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ALT ELSE 0 END AS [msg_S_0106\T], -- ALT. DÖVİZ ALACAK
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ORJ ELSE 0 END AS [msg_S_0109\T], -- ORJ. DÖVİZ BORÇ
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ORJ ELSE 0 END AS [msg_S_0110\T], -- ORJ. DÖVİZ ALACAK
CHA_NORMAL_CARI_DOVIZ_SEMBOLU AS [msg_S_0112] -- ORJ.DOVİZ
FROM dbo.CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_03_SPECIAL WITH (NOLOCK)
WHERE (cha_cari_cins=@caricins) AND
((@carikod='') OR (cha_kod=@carikod)) AND
(cha_kod<>'') AND
((cha_grupno=@grupno) OR (@grupno is NULL)) AND
((cha_tarihi>=@ilktar) or (@ilktar is NULL)) AND
((cha_tarihi<=@sontar) or (@sontar is NULL)) AND
(dbo.fn_no_ok(cha_firmano,@firmalar)=1) AND
(dbo.fn_str_ok(cha_srmrkkodu,@SomStr)=1) AND
(dbo.fn_str_ok(cha_projekodu,@ProjeStr)=1)
-- Föye CariHesaplar ile ilgili kapalı hareketleride koyalım
UNION
SELECT  TOP 100 PERCENT
cha_RECno AS [msg_S_0088], -- KAYIT NO
cha_tarihi AS [msg_S_0089], -- TARİH
cha_cinsi AS [#msg_S_0095], -- CİNS
0,
cha_srmrkkodu AS [msg_S_0118], -- SRM.MRK.KODU
cha_projekodu AS [msg_S_0116], -- PROJE KODU
CHA_CARI_MEBLAG_ANA AS [msg_S_0101\T], -- ANA DÖVİZ BORÇ
CHA_CARI_MEBLAG_ANA AS [msg_S_0102\T], -- ANA DÖVİZ ALACAK
CHA_CARI_MEBLAG_ALT AS [msg_S_0105\T], -- ALT. DÖVİZ BORÇ
CHA_CARI_MEBLAG_ALT AS [msg_S_0106\T], -- ALT. DÖVİZ ALACAK
CHA_CARI_MEBLAG_ORJ AS [msg_S_0109\T], -- ORJ. DÖVİZ BORÇ
CHA_CARI_MEBLAG_ORJ AS [msg_S_0110\T], -- ORJ. DÖVİZ ALACAK
CHA_NORMAL_CARI_DOVIZ_SEMBOLU
FROM dbo.CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_09_SPECIAL WITH (NOLOCK)
WHERE (@caricins=0) AND (cha_ciro_cari_kodu<>'') AND
(cha_cari_cins<>@caricins) AND
((cha_ciro_cari_kodu=@carikod)OR(@carikod='')) AND
(cha_tpoz=1) AND
(@grupno is NULL) AND
((cha_tarihi>=@ilktar) or (@ilktar is NULL)) AND
((cha_tarihi<=@sontar) or (@sontar is NULL)) AND
(dbo.fn_no_ok(cha_firmano,@firmalar)=1) AND
(dbo.fn_str_ok(cha_srmrkkodu,@SomStr)=1) AND
(dbo.fn_str_ok(cha_projekodu,@ProjeStr)=1)
-- İthalat, Demirbaş/hizmet/masraf faturaları veya döviz satış belgeleri
UNION
SELECT  TOP 100 PERCENT
cha_RECno AS [msg_S_0088], -- KAYIT NO
cha_tarihi AS [msg_S_0089], -- TARİH
cha_cinsi AS [#msg_S_0095], -- CİNS
cha_grupno AS [#msg_S_1712], -- CARİ HESAP GRUP NO
cha_srmrkkodu AS [msg_S_0118], -- SRM.MRK.KODU
cha_projekodu AS [msg_S_0116], -- PROJE KODU
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ANA ELSE 0 END AS [msg_S_0101\T], -- ANA DÖVİZ BORÇ
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ANA ELSE 0 END AS [msg_S_0102\T], -- ANA DÖVİZ ALACAK
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ALT ELSE 0 END AS [msg_S_0105\T], -- ALT. DÖVİZ BORÇ
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ALT ELSE 0 END AS [msg_S_0106\T], -- ALT. DÖVİZ ALACAK
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ORJ ELSE 0 END AS [msg_S_0109\T], -- ORJ. DÖVİZ BORÇ
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ORJ ELSE 0 END AS [msg_S_0110\T], -- ORJ. DÖVİZ ALACAK
CHA_NORMAL_CARI_DOVIZ_SEMBOLU AS [msg_S_0112] -- ORJ.DOVİZ
FROM dbo.CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_08_SPECIAL WITH (NOLOCK)
WHERE (@caricins=9) And
((@carikod='')or(cha_EXIMkodu=@carikod)) AND
(cha_EXIMkodu<>'')  AND
((cha_evrak_tip=90)OR     --döviz satış belgesi
((cha_evrak_tip=0) AND   --Demirbaş/hizmet/masraf ithalat faturası
(cha_tip=1) AND
(cha_cinsi=29) AND
(cha_kasa_hizmet IN (3,5,8)) AND
(cha_normal_Iade=0) ) )AND
((@grupno is NULL) OR (@grupno=0)) AND
((cha_tarihi>=@ilktar) or (@ilktar is NULL)) AND
((cha_tarihi<=@sontar) or (@sontar is NULL)) AND
(dbo.fn_no_ok(cha_firmano,@firmalar)=1) AND
(dbo.fn_str_ok(cha_srmrkkodu,@SomStr)=1) AND
(dbo.fn_str_ok(cha_projekodu,@ProjeStr)=1)
-- Karşı Cari indeksine göre olan kayıtlar
UNION
SELECT  TOP 100 PERCENT
cha_RECno AS [msg_S_0088], -- KAYIT NO
cha_tarihi AS [msg_S_0089], -- TARİH
cha_cinsi AS [#msg_S_0095], -- CİNS
cha_karsidgrupno,
cha_karsisrmrkkodu AS [msg_S_0118], -- SRM.MRK.KODU
cha_projekodu AS [msg_S_0116], -- PROJE KODU
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_KARSI_CARI_MEBLAG_ANA ELSE 0 END AS [msg_S_0101\T], -- ANA DÖVİZ BORÇ
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_KARSI_CARI_MEBLAG_ANA ELSE 0 END AS [msg_S_0102\T], -- ANA DÖVİZ ALACAK
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_KARSI_CARI_MEBLAG_ALT ELSE 0 END AS [msg_S_0105\T], -- ALT. DÖVİZ BORÇ
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_KARSI_CARI_MEBLAG_ALT ELSE 0 END AS [msg_S_0106\T], -- ALT. DÖVİZ ALACAK
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_KARSI_CARI_MEBLAG_ORJ ELSE 0 END AS [msg_S_0109\T], -- ORJ. DÖVİZ BORÇ
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_KARSI_CARI_MEBLAG_ORJ ELSE 0 END AS [msg_S_0110\T], -- ORJ. DÖVİZ ALACAK
CHA_KARSI_CARI_DOVIZ_SEMBOLU
FROM dbo.CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_05_SPECIAL WITH (NOLOCK)
WHERE (cha_kasa_hizmet=@caricins) AND
((@carikod='') OR (cha_kasa_hizkod=@carikod)) AND
(cha_kasa_hizkod<>'') AND
((cha_karsidgrupno=@grupno) or (@grupno is NULL)) AND
((cha_tarihi>=@ilktar) or (@ilktar is NULL)) AND
((cha_tarihi<=@sontar) or (@sontar is NULL)) AND
(dbo.fn_no_ok(cha_firmano,@firmalar)=1) AND
(dbo.fn_str_ok(cha_karsisrmrkkodu,@SomStr)=1) AND
(dbo.fn_str_ok(cha_projekodu,@ProjeStr)=1)
-- Stoktaki gider kayıtları
UNION
SELECT  TOP 100 PERCENT
(-1 * sth_RECno) AS [msg_S_0088], -- KAYIT NO
sth_tarih AS [msg_S_0089], -- TARİH
CAST(32 AS tinyint) AS [#msg_S_0095], -- CİNS
0,
sth_cari_srm_merkezi AS [msg_S_0118], -- SRM.MRK.KODU
sth_proje_kodu AS [msg_S_0116], -- PROJE KODU
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (0,2) THEN STH_NET_DEGER_ANA ELSE 0 END AS [msg_S_0101\T], -- ANA DÖVİZ BORÇ
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (1,2) THEN STH_NET_DEGER_ANA ELSE 0 END AS [msg_S_0102\T], -- ANA DÖVİZ ALACAK
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (0,2) THEN STH_NET_DEGER_ALT ELSE 0 END AS [msg_S_0105\T], -- ALT. DÖVİZ BORÇ
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (1,2) THEN STH_NET_DEGER_ALT ELSE 0 END AS [msg_S_0106\T], -- ALT. DÖVİZ ALACAK
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (0,2) THEN STH_NET_DEGER_STOK_ORJ ELSE 0 END AS [msg_S_0109\T], -- ORJ. DÖVİZ BORÇ
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (1,2) THEN STH_NET_DEGER_STOK_ORJ ELSE 0 END AS [msg_S_0110\T], -- ORJ. DÖVİZ ALACAK
STH_STOK_DOVIZ_SEMBOLU
FROM dbo.STOK_HAREKETLERI_VIEW_WITH_INDEX_13_SPECIAL WITH (NOLOCK)
WHERE (@caricins=5) AND
((@carikod='') OR (sth_isemri_gider_kodu=@carikod)) AND
(sth_cins in (4,5,9,10)) AND
((sth_tarih>=@ilktar) or (@ilktar is NULL)) AND
((sth_tarih<=@sontar) or (@sontar is NULL)) AND
(dbo.fn_no_ok(sth_firmano,@firmalar)=1) AND
(dbo.fn_str_ok(sth_cari_srm_merkezi,@SomStr)=1) AND
(dbo.fn_str_ok(sth_proje_kodu,@ProjeStr)=1)
-- İthalat için ithalat faturası ile girişler ve antrepo mal millileştirme ile ilgili milllileştirmeler
UNION
SELECT  TOP 100 PERCENT
(-1 * sth_RECno) AS [msg_S_0088], -- KAYIT NO
sth_tarih AS [msg_S_0089], -- TARİH
CAST(sth_cins AS tinyint) AS [#msg_S_0095], -- CİNS
0,
sth_stok_srm_merkezi AS [msg_S_0118], -- SRM.MRK.KODU
sth_proje_kodu AS [msg_S_0116], -- PROJE KODU
CASE WHEN sth_evraktip<>10 THEN STH_NET_DEGER_ANA ELSE 0 END AS [msg_S_0101\T], -- ANA DÖVİZ BORÇ
CASE WHEN (0=STH_GIRIS_DEPO_ENVANTER_HARICI) OR (sth_evraktip=10) THEN STH_NET_DEGER_ANA ELSE 0 END AS [msg_S_0102\T], -- ANA DÖVİZ ALACAK
CASE WHEN sth_evraktip<>10 THEN  STH_NET_DEGER_ALT ELSE 0 END AS [msg_S_0105\T], -- ALT. DÖVİZ BORÇ
CASE WHEN (0=STH_GIRIS_DEPO_ENVANTER_HARICI) OR (sth_evraktip=10) THEN STH_NET_DEGER_ALT ELSE 0 END AS [msg_S_0106\T], -- ALT. DÖVİZ ALACAK
CASE WHEN sth_evraktip<>10 THEN  STH_NET_DEGER_CARI_ORJ ELSE 0 END AS [msg_S_0109\T], -- ORJ. DÖVİZ BORÇ
CASE WHEN (0=STH_GIRIS_DEPO_ENVANTER_HARICI) OR (sth_evraktip=10) THEN STH_NET_DEGER_CARI_ORJ ELSE 0 END AS [msg_S_0110\T], -- ORJ. DÖVİZ ALACAK
STH_HAR_DOVIZ_SEMBOLU
FROM dbo.STOK_HAREKETLERI_VIEW_WITH_INDEX_12_SPECIAL WITH (NOLOCK)
WHERE (@caricins=9) And
(sth_exim_kodu=@carikod) AND
(
(sth_evraktip in (3,10,11,12,13)) OR        -- Giris Faturasi,Antrepo mal milli, atropo transfer, giris irsaliyesi
((sth_evraktip=5) AND (1=STH_GIRIS_DEPO_ENVANTER_HARICI))
)  AND                                       --  Giris hareketi veya antrepolar arasi mal millileştirme fişi ise
(sth_normal_iade=0) AND
((@grupno is NULL) OR (@grupno=0)) AND
((sth_tarih>=@ilktar) or (@ilktar is NULL)) AND
((sth_tarih<=@sontar) or (@sontar is NULL)) AND
(dbo.fn_str_ok(sth_cari_srm_merkezi,@SomStr)=1) AND
(dbo.fn_str_ok(sth_proje_kodu,@ProjeStr)=1)
-- Ödeme emri değerlemeleri
UNION
SELECT  TOP 100 PERCENT
0 AS [msg_S_0088], -- KAYIT NO
@sontar AS [msg_S_0089], -- TARİH
0 AS [#msg_S_0095], -- CİNS
0,
'' AS [msg_S_0118], -- SRM.MRK.KODU
'' AS [msg_S_0116], -- PROJE KODU
CASE
WHEN dbo.fn_OdemeEmriDegerFarki ( 0,
sck_tutar,
sck_doviz,
dbo.fn_CariDovizCinsi(@caricins,@carikod,sck_sahip_cari_grupno),
sck_ilk_hareket_tarihi,
sck_son_hareket_tarihi,
sck_vade,
@carikod ) >= 0
THEN dbo.fn_OdemeEmriDegerFarki ( 0,
sck_tutar,
sck_doviz,
dbo.fn_CariDovizCinsi(@caricins,@carikod,sck_sahip_cari_grupno),
sck_ilk_hareket_tarihi,
sck_son_hareket_tarihi,
sck_vade,
@carikod )
ELSE 0
END AS [msg_S_0101\T], -- ANA DÖVİZ BORÇ
CASE
WHEN dbo.fn_OdemeEmriDegerFarki ( 0,
sck_tutar,
sck_doviz,
dbo.fn_CariDovizCinsi(@caricins,@carikod,sck_sahip_cari_grupno),
sck_ilk_hareket_tarihi,
sck_son_hareket_tarihi,
sck_vade,
@carikod ) < 0
THEN dbo.fn_OdemeEmriDegerFarki ( 0,
sck_tutar,
sck_doviz,
dbo.fn_CariDovizCinsi(@caricins,@carikod,sck_sahip_cari_grupno),
sck_ilk_hareket_tarihi,
sck_son_hareket_tarihi,
sck_vade,
@carikod ) * (-1.0)
ELSE 0
END AS [msg_S_0102\T], -- ANA DÖVİZ ALACAK
CAST ( 0 AS FLOAT ) AS [msg_S_0105\T], -- ALT. DÖVİZ BORÇ
CAST ( 0 AS FLOAT ) AS [msg_S_0106\T], -- ALT. DÖVİZ ALACAK
CASE
WHEN dbo.fn_OdemeEmriDegerFarki ( 2,
sck_tutar,
sck_doviz,
dbo.fn_CariDovizCinsi(@caricins,@carikod,sck_sahip_cari_grupno),
sck_ilk_hareket_tarihi,
sck_son_hareket_tarihi,
sck_vade,
@carikod ) >= 0
THEN dbo.fn_OdemeEmriDegerFarki (2,
sck_tutar,
sck_doviz,
dbo.fn_CariDovizCinsi(@caricins,@carikod,sck_sahip_cari_grupno),
sck_ilk_hareket_tarihi,
sck_son_hareket_tarihi,
sck_vade,
@carikod )
ELSE 0
END AS [msg_S_0109\T], -- ORJ. DÖVİZ BORÇ
CASE
WHEN dbo.fn_OdemeEmriDegerFarki ( 2,
sck_tutar,
sck_doviz,
dbo.fn_CariDovizCinsi(@caricins,@carikod,sck_sahip_cari_grupno),
sck_ilk_hareket_tarihi,
sck_son_hareket_tarihi,
sck_vade,
@carikod ) < 0
THEN dbo.fn_OdemeEmriDegerFarki (2,
sck_tutar,
sck_doviz,
dbo.fn_CariDovizCinsi(@caricins,@carikod,sck_sahip_cari_grupno),
sck_ilk_hareket_tarihi,
sck_son_hareket_tarihi,
sck_vade,
@carikod ) * (-1.0)
ELSE 0
END AS [msg_S_0110\T], -- ORJ. DÖVİZ ALACAK
dbo.fn_DovizSembolu(dbo.fn_CariDovizCinsi(@caricins,@carikod,sck_sahip_cari_grupno))
FROM dbo.ODEME_EMIRLERI WITH (NOLOCK)--, INDEX=NDX_ODEME_EMIRLERI_08)
WHERE (@odemeemridegerlemedok=1) AND
(@caricins=0) AND
(@carikod<>'') AND
(sck_degerleme_islendi=0) AND
(dbo.fn_no_ok(sck_firmano,@firmalar)=1) AND
(sck_sahip_cari_cins=0) AND
(sck_sahip_cari_kodu=@carikod) AND
((@grupno is NULL) OR (@grupno=sck_sahip_cari_grupno)) AND
((sck_ilk_hareket_tarihi<=@sontar) or (@sontar is NULL)) AND
((sck_doviz>0) OR (sck_doviz<>dbo.fn_CariDovizCinsi(@caricins,@carikod,sck_sahip_cari_grupno))) and
(not (sck_sonpoz in (4,5,7)))
)
*/
