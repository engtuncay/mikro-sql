--Burada MK003 ün KENT sorumluluk merkezindeki , anacariye birleştirmeli cari hesap ekstresi alınıyor

exec dbo.msp_CARI_HESAP_EXTRE_FOYU N'0',0,0,N'MK003',N'MK003',N'',N'0,1,2','20180101','20181231',1,0,N'''KENT''',0,N'',0,N'',0,0,0,0,0,2,0,0,0

--burada DOGUS, HAYAT , KENT PANEK sorumluluk merkezlerinie göre alınıyor.

exec dbo.msp_CARI_HESAP_EXTRE_FOYU N'0',0,0,N'MK003',N'MK003',N'',N'0,1,2','20180101','20181231',1,0,N'''DOGUS'',''HAYAT'',''KENT'',''PANEK''',0,N'',0,N'',0,0,0,0,0,2,0,0,0


--Stored procedure in içeriği
------

BEGIN
CREATE Table #CariListesi (CariTipi tinyint,
CariKodu nvarchar(25) COLLATE database_default,
CariGrupNo tinyint,
CariDovizCinsi tinyint,
CariMuhKodu nvarchar(25) COLLATE database_default,
AnaCariKodu nvarchar(25) COLLATE database_default)
if @grupnostr=''
set @grupnostr = '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20'
CREATE Table #GrupNolari (CariGrup tinyint)
insert into #GrupNolari
SELECT
cast(Item as tinyint)
from dbo.SplitToItems(@grupnostr,',')
if dbo.fn_no_ok(0,@caricinsstr)=1
begin
insert into #CariListesi
select
cast(0 as tinyint),
cari_kod,
CariGrup,
case when CariGrup=2 then cari_doviz_cinsi2
when CariGrup=1 then cari_doviz_cinsi1
else cari_doviz_cinsi end,
case when CariGrup=2 then cari_muh_kod2
when CariGrup=1 then cari_muh_kod1
else cari_muh_kod end,
cari_kod
from dbo.CARI_HESAPLAR WITH (NOLOCK),#GrupNolari
where (cari_kod >= @cariilk) and (@carison='' or cari_kod <= @carison) and (@cariyapi='' or cari_kod LIKE @cariyapi)AND
((CariGrup = 0 AND cari_doviz_cinsi<255)OR
(CariGrup = 1 AND cari_doviz_cinsi1<255)OR
(CariGrup = 2 AND cari_doviz_cinsi2<255))
if @BaglantiliCari>0
insert into #CariListesi
select
cast(0 as tinyint),
cari_kod,
CariGrup,
case when CariGrup=2 then cari_doviz_cinsi2
when CariGrup=1 then cari_doviz_cinsi1
else cari_doviz_cinsi end,
case when CariGrup=2 then cari_muh_kod2
when CariGrup=1 then cari_muh_kod1
else cari_muh_kod end,
cari_Ana_cari_kodu
from dbo.CARI_HESAPLAR WITH (NOLOCK),#GrupNolari
where cari_Ana_cari_kodu<>'' and cari_Ana_cari_kodu<>cari_kod and
(cari_Ana_cari_kodu in (select CariKodu from #CariListesi where CariTipi=0))and
(not exists(select * from #CariListesi where CariTipi=0 and CariKodu=cari_kod and CariGrupNo=CariGrup))and
((CariGrup = 0 AND cari_doviz_cinsi<255)OR
(CariGrup = 1 AND cari_doviz_cinsi1<255)OR
(CariGrup = 2 AND cari_doviz_cinsi2<255))
end
if @ilktar is NULL set @ilktar = '19100101'
if @sontar is NULL set @sontar = '20700101'
declare @devirtarihi datetime
if @Devreden=1 and @ilktar > '19100101'
begin
set @devirtarihi = DATEADD(day,-1,@ilktar)
set @ilktar = '19000101'
end
else
set @devirtarihi = '19000101';
WITH
FirmaList    as (SELECT CONVERT(INT, Item)          AS FirmaNo  FROM dbo.SplitToItems(@firmalar, ',')),
SrmMrkList   as (SELECT CONVERT(nvarchar(25), Item) AS SrmMrk   FROM dbo.SplitToItems(Replace(@SomStr,'''',''), ',')),
ProjeList    as (SELECT CONVERT(nvarchar(25), Item) AS Proje    FROM dbo.SplitToItems(Replace(@ProjeStr,'''',''), ',')),
PlasiyerList as (SELECT CONVERT(nvarchar(25), Item) AS Plasiyer FROM dbo.SplitToItems(Replace(@PlasiyerStr,'''',''), ','))
select
*
into #CARI_HAREKETLERI
FROM
(
SELECT
CAST(51 AS integer)as TABLONO,
cha_RECno AS RECNO,
cha_RECid_DBCno AS DBCNO,
cha_RECid_RECno AS DBRECNO,
CariTipi AS CARI_TIPI,
CariKodu AS CARI_KODU,
CariGrupNo AS CARI_GRUPNO,
CariDovizCinsi AS CARI_DOVIZ,
CariMuhKodu AS CARI_MUH_KODU,
AnaCariKodu AS ANA_CARI_KODU,
CariKodu AS GERCEK_CARI_KODU,
cast(1 as tinyint) AS BAKIYE_TIP,
cha_tarihi AS TARIH,
cha_evrak_tip    AS EVRAKTIPNO,
CHEvrUzunIsim    AS EVRAKTIPISIM,
cha_cinsi        AS EVRAKCINSNO,
CHCinsIsim       AS EVRAKCINSISIM,
cha_evrakno_seri AS EVRAKSERI,
cha_evrakno_sira AS EVRAKSIRA,
cha_satir_no     AS EVRAKSATIR,
cha_belge_tarih  AS BELGETARIH,
cha_belge_no     AS BELGENO,
cha_firmano AS FIRMANO,
cha_srmrkkodu AS SRM_MRK,
cha_projekodu AS PROJE,
cha_satici_kodu AS PLASIYER,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ANA ELSE 0 END AS ANA_BORC,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ANA ELSE 0 END AS ANA_ALACAK,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ALT ELSE 0 END AS ALT_BORC,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ALT ELSE 0 END AS ALT_ALACAK,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ORJ ELSE 0 END AS ORJ_BORC,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ORJ ELSE 0 END AS ORJ_ALACAK,
CHA_NORMAL_CARI_DOVIZ_SEMBOLU AS ORJ_DOVIZ_SEMBOLU
FROM dbo.CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_03 WITH (NOLOCK)
INNER JOIN dbo.#CariListesi ON CariTipi=cha_cari_cins AND CariKodu=cha_kod AND CariGrupNo=cha_grupno
WHERE (cha_tarihi between @ilktar and @sontar) AND
(@firmalar='' or cha_firmano   in (select FirmaNo from FirmaList)) AND
(@SomStr  ='' or cha_srmrkkodu in (select SrmMrk  from SrmMrkList)) AND
(@ProjeStr='' or cha_projekodu in (select Proje   from ProjeList)) AND
(@PlasiyerStr='' or cha_satici_kodu in (select Plasiyer   from PlasiyerList))
-- Föye CariHesaplar ile ilgili kapalı hareketleride koyalım
UNION ALL
SELECT
51,
cha_RECno,
cha_RECid_DBCno,
cha_RECid_RECno,
CariTipi,
CariKodu,
CariGrupNo,
CariDovizCinsi,
CariMuhKodu,
AnaCariKodu,
CariKodu,
cast(1 as tinyint),
cha_tarihi,
cha_evrak_tip,
CHEvrUzunIsim,
cha_cinsi,
CHCinsIsim,
cha_evrakno_seri,
cha_evrakno_sira,
cha_satir_no,
cha_belge_tarih,
cha_belge_no,
cha_firmano,
cha_srmrkkodu,
cha_projekodu,
cha_satici_kodu,
CHA_CARI_MEBLAG_ANA,
CHA_CARI_MEBLAG_ANA,
CHA_CARI_MEBLAG_ALT,
CHA_CARI_MEBLAG_ALT,
CHA_CARI_MEBLAG_ORJ,
CHA_CARI_MEBLAG_ORJ,
CHA_NORMAL_CARI_DOVIZ_SEMBOLU
FROM dbo.CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_09 WITH (NOLOCK)
INNER JOIN dbo.#CariListesi ON CariTipi=0 AND CariKodu=cha_ciro_cari_kodu AND CariGrupNo=0
WHERE (cha_ciro_cari_kodu<>'') AND
(cha_cari_cins<>0) AND
(cha_tpoz=1) AND
(@grupnostr<>'') AND
(cha_tarihi between @ilktar and @sontar) AND
(@firmalar='' or cha_firmano   in (select FirmaNo from FirmaList)) AND
(@SomStr  ='' or cha_srmrkkodu in (select SrmMrk  from SrmMrkList)) AND
(@ProjeStr='' or cha_projekodu in (select Proje   from ProjeList)) AND
(@PlasiyerStr='' or cha_satici_kodu in (select Plasiyer   from PlasiyerList))
-- İthalat, Demirbaş/hizmet/masraf faturaları veya döviz satış belgeleri
UNION ALL
SELECT
51,
cha_RECno,
cha_RECid_DBCno,
cha_RECid_RECno,
CariTipi,
CariKodu,
CariGrupNo,
CariDovizCinsi,
CariMuhKodu,
AnaCariKodu,
CariKodu,
cast(1 as tinyint),
cha_tarihi,
cha_evrak_tip,
CHEvrUzunIsim,
cha_cinsi,
CHCinsIsim,
cha_evrakno_seri,
cha_evrakno_sira,
cha_satir_no,
cha_belge_tarih,
cha_belge_no,
cha_firmano,
cha_srmrkkodu,
cha_projekodu,
cha_satici_kodu,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ANA ELSE 0 END,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ANA ELSE 0 END,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ALT ELSE 0 END,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ALT ELSE 0 END,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_CARI_MEBLAG_ORJ ELSE 0 END,
CASE WHEN CHA_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_CARI_MEBLAG_ORJ ELSE 0 END,
CHA_NORMAL_CARI_DOVIZ_SEMBOLU
FROM dbo.CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_08 WITH (NOLOCK)
INNER JOIN dbo.#CariListesi ON CariTipi=9 AND CariKodu=cha_EXIMkodu AND CariGrupNo=0
WHERE (cha_EXIMkodu<>'')  AND
((cha_evrak_tip=90)OR     --döviz satış belgesi
((cha_evrak_tip=0) AND   --Demirbaş/hizmet/masraf ithalat faturası
(cha_tip=1) AND
(cha_cinsi=29) AND
(cha_kasa_hizmet IN (3,5,8)) AND
(cha_normal_Iade=0) ) )AND
(cha_tarihi between @ilktar and @sontar) AND
(@firmalar='' or cha_firmano   in (select FirmaNo from FirmaList)) AND
(@SomStr  ='' or cha_srmrkkodu in (select SrmMrk  from SrmMrkList)) AND
(@ProjeStr='' or cha_projekodu in (select Proje   from ProjeList)) AND
(@PlasiyerStr='' or cha_satici_kodu in (select Plasiyer   from PlasiyerList))
-- Karşı Cari indeksine göre olan kayıtlar
UNION ALL
SELECT
51,
cha_RECno,
cha_RECid_DBCno,
cha_RECid_RECno,
CariTipi,
CariKodu,
CariGrupNo,
CariDovizCinsi,
CariMuhKodu,
AnaCariKodu,
CariKodu,
cast(1 as tinyint),
cha_tarihi,
cha_evrak_tip,
CHEvrUzunIsim,
cha_cinsi,
CHCinsIsim,
cha_evrakno_seri,
cha_evrakno_sira,
cha_satir_no,
cha_belge_tarih,
cha_belge_no,
cha_firmano,
cha_karsisrmrkkodu,
cha_projekodu,
cha_satici_kodu,
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_KARSI_CARI_MEBLAG_ANA ELSE 0 END,
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_KARSI_CARI_MEBLAG_ANA ELSE 0 END,
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_KARSI_CARI_MEBLAG_ALT ELSE 0 END,
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_KARSI_CARI_MEBLAG_ALT ELSE 0 END,
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (0,2) THEN CHA_KARSI_CARI_MEBLAG_ORJ ELSE 0 END,
CASE WHEN CHA_KARSI_CARI_BORC_ALACAK_TIP in (1,2) THEN CHA_KARSI_CARI_MEBLAG_ORJ ELSE 0 END,
CHA_KARSI_CARI_DOVIZ_SEMBOLU
FROM dbo.CARI_HESAP_HAREKETLERI_VIEW_WITH_INDEX_05 WITH (NOLOCK)
INNER JOIN dbo.#CariListesi ON CariTipi=cha_kasa_hizmet AND CariKodu=cha_kasa_hizkod AND CariGrupNo=cha_karsidgrupno
WHERE (cha_kasa_hizkod<>'') AND
(cha_tarihi between @ilktar and @sontar) AND
(@firmalar='' or cha_firmano   in (select FirmaNo from FirmaList)) AND
(@SomStr  ='' or cha_karsisrmrkkodu in (select SrmMrk  from SrmMrkList)) AND
(@ProjeStr='' or cha_projekodu in (select Proje   from ProjeList)) AND
(@PlasiyerStr='' or cha_satici_kodu in (select Plasiyer   from PlasiyerList))
-- Stoktaki gider kayıtları
UNION ALL
SELECT
16,
sth_RECno,
sth_RECid_DBCno,
sth_RECid_RECno,
CariTipi,
CariKodu,
CariGrupNo,
CariDovizCinsi,
CariMuhKodu,
AnaCariKodu,
CariKodu,
cast(1 as tinyint),
sth_tarih,
sth_evraktip,
SHEvrIsim,
sth_cins,
SHCinsIsim,
sth_evrakno_seri,
sth_evrakno_sira,
sth_satirno,
sth_belge_tarih,
sth_belge_no,
sth_firmano,
sth_cari_srm_merkezi,
sth_proje_kodu,
sth_plasiyer_kodu,
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (0,2) THEN STH_NET_DEGER_ANA ELSE 0 END,
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (1,2) THEN STH_NET_DEGER_ANA ELSE 0 END,
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (0,2) THEN STH_NET_DEGER_ALT ELSE 0 END,
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (1,2) THEN STH_NET_DEGER_ALT ELSE 0 END,
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (0,2) THEN STH_NET_DEGER_STOK_ORJ ELSE 0 END,
CASE WHEN STH_STOK_BORC_ALACAK_TIP in (1,2) THEN STH_NET_DEGER_STOK_ORJ ELSE 0 END,
STH_STOK_DOVIZ_SEMBOLU
FROM dbo.STOK_HAREKETLERI_VIEW_WITH_INDEX_13 WITH (NOLOCK)
INNER JOIN dbo.#CariListesi ON CariTipi=5 AND CariKodu=sth_isemri_gider_kodu AND CariGrupNo=0
WHERE (sth_isemri_gider_kodu <> '') AND
(sth_cins in (4,5,9,10)) AND
(sth_tarih between @ilktar and @sontar) AND
(@firmalar='' or sth_firmano   in (select FirmaNo from FirmaList)) AND
(@SomStr  ='' or sth_cari_srm_merkezi in (select SrmMrk  from SrmMrkList)) AND
(@ProjeStr='' or sth_proje_kodu in (select Proje   from ProjeList)) AND
(@PlasiyerStr='' or sth_plasiyer_kodu in (select Plasiyer   from PlasiyerList))
-- İthalat için ithalat faturası ile girişler ve antrepo mal millileştirme ile ilgili milllileştirmeler
UNION ALL
SELECT
16,
sth_RECno,
sth_RECid_DBCno,
sth_RECid_RECno,
CariTipi,
CariKodu,
CariGrupNo,
CariDovizCinsi,
CariMuhKodu,
AnaCariKodu,
CariKodu,
cast(1 as tinyint),
sth_tarih,
sth_evraktip,
SHEvrIsim,
sth_cins,
SHCinsIsim,
sth_evrakno_seri,
sth_evrakno_sira,
sth_satirno,
sth_belge_tarih,
sth_belge_no,
sth_firmano,
sth_stok_srm_merkezi,
sth_proje_kodu,
sth_plasiyer_kodu,
CASE WHEN sth_evraktip<>10 THEN STH_NET_DEGER_ANA ELSE 0 END,
CASE WHEN (0=ISNULL(dep_envanter_harici_fl,0)) OR (sth_evraktip=10) THEN STH_NET_DEGER_ANA ELSE 0 END,
CASE WHEN sth_evraktip<>10 THEN  STH_NET_DEGER_ALT ELSE 0 END,
CASE WHEN (0=ISNULL(dep_envanter_harici_fl,0)) OR (sth_evraktip=10) THEN STH_NET_DEGER_ALT ELSE 0 END,
CASE WHEN sth_evraktip<>10 THEN  STH_NET_DEGER_CARI_ORJ ELSE 0 END,
CASE WHEN (0=ISNULL(dep_envanter_harici_fl,0)) OR (sth_evraktip=10) THEN STH_NET_DEGER_CARI_ORJ ELSE 0 END,
STH_HAR_DOVIZ_SEMBOLU
FROM dbo.STOK_HAREKETLERI_VIEW_WITH_INDEX_12 WITH (NOLOCK)
INNER JOIN dbo.#CariListesi ON CariTipi=9 AND CariKodu=sth_exim_kodu AND CariGrupNo=0
LEFT OUTER JOIN dbo.DEPOLAR ON dep_no=sth_giris_depo_no
WHERE (
(sth_evraktip in (3,10,11,12,13)) OR        -- Giris Faturasi,Antrepo mal milli, atropo transfer, giris irsaliyesi
((sth_evraktip=5) AND (1=ISNULL(dep_envanter_harici_fl,0)))
)  AND                                       --  Giris hareketi veya antrepolar arasi mal millileştirme fişi ise
(sth_normal_iade=0) AND
(sth_tarih between @ilktar and @sontar) AND
(@firmalar='' or sth_firmano   in (select FirmaNo from FirmaList)) AND
(@SomStr  ='' or sth_cari_srm_merkezi in (select SrmMrk  from SrmMrkList)) AND
(@ProjeStr='' or sth_proje_kodu in (select Proje   from ProjeList)) AND
(@PlasiyerStr='' or sth_plasiyer_kodu in (select Plasiyer   from PlasiyerList))
-- Ödeme emri değerlemeleri
UNION ALL
SELECT
54,
sck_RECno,
sck_RECid_DBCno,
sck_RECid_RECno,
CariTipi,
CariKodu,
CariGrupNo,
CariDovizCinsi,
CariMuhKodu,
AnaCariKodu,
CariKodu,
cast(5 as tinyint),
@sontar,
sck_tip,
OMTipIsim,
sck_sonpoz,
OMPozIsim,
'',
0,
0,
sck_vade,
sck_refno,
sck_firmano,
sck_srmmrk,
sck_projekodu,
'',
case when sck_tutar_ana >= 0.0 then abs(sck_tutar_ana) else 0.0 end,
case when sck_tutar_ana <  0.0 then abs(sck_tutar_ana) else 0.0 end,
cast(0 AS float),
cast(0 AS float),
case when sck_tutar_orj >= 0.0 then abs(sck_tutar_orj) else 0.0 end,
case when sck_tutar_orj <  0.0 then abs(sck_tutar_orj) else 0.0 end,
KUR_SEMBOLU
FROM
(
SELECT
sck_RECno,
sck_RECid_DBCno,
sck_RECid_RECno,
CariTipi,
CariKodu,
CariGrupNo,
CariDovizCinsi,
CariMuhKodu,
AnaCariKodu,
sck_tip,
OMTipIsim,
sck_sonpoz,
OMPozIsim,
sck_vade,
sck_refno,
sck_firmano,
sck_srmmrk,
sck_projekodu,
dbo.fn_OdemeEmriDegerFarki(0,sck_tutar,sck_doviz,CariDovizCinsi,sck_ilk_hareket_tarihi,sck_son_hareket_tarihi,sck_vade,CariKodu)as sck_tutar_ana,
dbo.fn_OdemeEmriDegerFarki(2,sck_tutar,sck_doviz,CariDovizCinsi,sck_ilk_hareket_tarihi,sck_son_hareket_tarihi,sck_vade,CariKodu)as sck_tutar_orj,
KUR_SEMBOLU
FROM dbo.ODEME_EMIRLERI WITH (NOLOCK)--, INDEX=NDX_ODEME_EMIRLERI_08)
INNER JOIN dbo.#CariListesi ON CariTipi=sck_sahip_cari_cins AND CariKodu=sck_sahip_cari_kodu AND CariGrupNo=sck_sahip_cari_grupno
LEFT OUTER JOIN dbo.vw_Odeme_Emri_Tip_Isimleri ON OMTipNo=sck_tip
LEFT OUTER JOIN dbo.vw_Odeme_Emri_Pozisyon_Isimleri ON OMPozNo=sck_sonpoz
LEFT OUTER JOIN dbo.KUR_ISIMLERI_VIEW ON KUR_NUMARASI=CariDovizCinsi
WHERE (@odemeemridegerlemedok=1) AND
(sck_degerleme_islendi=0) AND
(@firmalar='' or sck_firmano   in (select FirmaNo from FirmaList)) AND
(sck_ilk_hareket_tarihi<=@sontar) AND
((sck_doviz>0) OR (sck_doviz<>CariDovizCinsi)) and
(not (sck_sonpoz in (4,5,7)))
)AS ODEMEEMRITABLE
WHERE sck_tutar_ana<>0.0 OR sck_tutar_orj<>0.0
-- İrsaliyeler
UNION ALL
SELECT
16,
sth_RECno,
sth_RECid_DBCno,
sth_RECid_RECno,
CariTipi,
CariKodu,
CariGrupNo,
CariDovizCinsi,
CariMuhKodu,
AnaCariKodu,
CariKodu,
cast(2 as tinyint),
sth_tarih,
sth_evraktip,
SHEvrIsim,
sth_cins,
SHCinsIsim,
sth_evrakno_seri,
sth_evrakno_sira,
sth_satirno,
sth_belge_tarih,
sth_belge_no,
sth_firmano,
sth_cari_srm_merkezi,
sth_proje_kodu,
sth_plasiyer_kodu,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (0,2) THEN STH_VERGILI_NET_DEGER_ANA ELSE 0 END,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (1,2) THEN STH_VERGILI_NET_DEGER_ANA ELSE 0 END,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (0,2) THEN STH_VERGILI_NET_DEGER_ALT ELSE 0 END,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (1,2) THEN STH_VERGILI_NET_DEGER_ALT ELSE 0 END,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (0,2) THEN STH_VERGILI_NET_DEGER_CARI_ORJ ELSE 0 END,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (1,2) THEN STH_VERGILI_NET_DEGER_CARI_ORJ ELSE 0 END,
STH_HAR_DOVIZ_SEMBOLU
FROM dbo.STOK_HAREKETLERI_VIEW_WITH_INDEX_03 WITH (NOLOCK)
INNER JOIN dbo.#CariListesi ON CariTipi=0 AND CariKodu=sth_cari_kodu AND CariGrupNo=0
LEFT OUTER JOIN dbo.vw_Stok_Hareket_Evrak_Isimleri SHEVRAK ON SHEvrNo=sth_evraktip
LEFT OUTER JOIN dbo.vw_Stok_Hareket_Cins_Isimleri  SHCINS  ON SHCinsNo=sth_cins
WHERE (@Irsaliyeler=1)AND
(sth_tarih between @ilktar and @sontar) AND
(sth_evraktip in (1,13)) AND (sth_fat_recid_recno=0) AND
(@firmalar='' or sth_firmano   in (select FirmaNo from FirmaList)) AND
(@SomStr  ='' or sth_cari_srm_merkezi in (select SrmMrk  from SrmMrkList)) AND
(@ProjeStr='' or sth_proje_kodu in (select Proje   from ProjeList)) AND
(@PlasiyerStr='' or sth_plasiyer_kodu in (select Plasiyer   from PlasiyerList))
-- Siparişler
UNION ALL
SELECT
21,
sip_RECno,
sip_RECid_DBCno,
sip_RECid_RECno,
CariTipi,
CariKodu,
CariGrupNo,
CariDovizCinsi,
CariMuhKodu,
AnaCariKodu,
CariKodu,
cast(3 as tinyint),
sip_tarih,
sip_tip,
dbo.fn_TalepTemin(sip_tip),
sip_cins,
dbo.fn_SiparisCins(sip_cins),
sip_evrakno_seri,
sip_evrakno_sira,
sip_satirno,
sip_belge_tarih,
sip_belgeno,
sip_firmano,
sip_cari_sormerk,
sip_projekodu,
sip_satici_kod,
CASE WHEN SIP_CARI_BORC_ALACAK_TIP in (0,2) THEN SIP_NET_DEGER_ANA*SIP_KALAN_MIKTAR_CARPANI ELSE 0 END,
CASE WHEN SIP_CARI_BORC_ALACAK_TIP in (1,2) THEN SIP_NET_DEGER_ANA*SIP_KALAN_MIKTAR_CARPANI ELSE 0 END,
CASE WHEN SIP_CARI_BORC_ALACAK_TIP in (0,2) THEN SIP_NET_DEGER_ALT*SIP_KALAN_MIKTAR_CARPANI ELSE 0 END,
CASE WHEN SIP_CARI_BORC_ALACAK_TIP in (1,2) THEN SIP_NET_DEGER_ALT*SIP_KALAN_MIKTAR_CARPANI ELSE 0 END,
CASE WHEN SIP_CARI_BORC_ALACAK_TIP in (0,2) THEN SIP_NET_DEGER_ORJ*SIP_KALAN_MIKTAR_CARPANI ELSE 0 END,
CASE WHEN SIP_CARI_BORC_ALACAK_TIP in (1,2) THEN SIP_NET_DEGER_ORJ*SIP_KALAN_MIKTAR_CARPANI ELSE 0 END,
SIP_DOVIZ_SEMBOLU
FROM dbo.SIPARISLER_VIEW_WITH_INDEX_03 WITH (NOLOCK)
INNER JOIN dbo.#CariListesi ON CariTipi=0 AND CariKodu=sip_musteri_kod AND CariGrupNo=0
WHERE (@Siparisler=1)AND
(sip_tarih between @ilktar and @sontar) AND
(sip_kapat_fl=0) AND (SIP_KALAN_MIKTAR>0.0) AND
(@firmalar='' or sip_firmano   in (select FirmaNo from FirmaList)) AND
(@SomStr  ='' or sip_cari_sormerk in (select SrmMrk  from SrmMrkList)) AND
(@ProjeStr='' or sip_projekodu in (select Proje   from ProjeList)) AND
(@PlasiyerStr='' or sip_satici_kod in (select Plasiyer   from PlasiyerList))
-- Konsinyeler
UNION ALL
SELECT
46,
kon_RECno,
kon_RECid_DBCno,
kon_RECid_RECno,
CariTipi,
CariKodu,
CariGrupNo,
CariDovizCinsi,
CariMuhKodu,
AnaCariKodu,
CariKodu,
cast(4 as tinyint),
kon_tarih,
kon_evraktip,
SHEvrIsim,
kon_cins,
SHCinsIsim,
kon_evrakno_seri,
kon_evrakno_sira,
kon_satirno,
kon_belge_tarih,
kon_belge_no,
kon_firmano,
kon_cari_srm_merkez,
kons_projekodu,
kon_satici_kod,
CASE WHEN KON_CARI_BORC_ALACAK_TIP in (0,2) THEN KON_VERGILI_NET_DEGER_ANA*KON_KALAN_MIKTAR_CARPANI ELSE 0 END,
CASE WHEN KON_CARI_BORC_ALACAK_TIP in (1,2) THEN KON_VERGILI_NET_DEGER_ANA*KON_KALAN_MIKTAR_CARPANI ELSE 0 END,
CASE WHEN KON_CARI_BORC_ALACAK_TIP in (0,2) THEN KON_VERGILI_NET_DEGER_ALT*KON_KALAN_MIKTAR_CARPANI ELSE 0 END,
CASE WHEN KON_CARI_BORC_ALACAK_TIP in (1,2) THEN KON_VERGILI_NET_DEGER_ALT*KON_KALAN_MIKTAR_CARPANI ELSE 0 END,
CASE WHEN KON_CARI_BORC_ALACAK_TIP in (0,2) THEN KON_VERGILI_NET_DEGER_CARI_ORJ*KON_KALAN_MIKTAR_CARPANI ELSE 0 END,
CASE WHEN KON_CARI_BORC_ALACAK_TIP in (1,2) THEN KON_VERGILI_NET_DEGER_CARI_ORJ*KON_KALAN_MIKTAR_CARPANI ELSE 0 END,
KON_HAR_DOVIZ_SEMBOLU
FROM dbo.KONSINYE_HAREKETLERI_VIEW_WITH_INDEX_03 WITH (NOLOCK)
INNER JOIN dbo.#CariListesi ON CariTipi=0 AND CariKodu=kon_cari_kod AND CariGrupNo=0
LEFT OUTER JOIN dbo.vw_Stok_Hareket_Evrak_Isimleri SHEVRAK ON SHEvrNo=kon_evraktip
LEFT OUTER JOIN dbo.vw_Stok_Hareket_Cins_Isimleri  SHCINS  ON SHCinsNo=kon_cins
WHERE (@Konsinyeler=1)AND
(kon_tarih between @ilktar and @sontar) AND
(kon_evraktip in (1,13)) AND (KON_KALAN_MIKTAR>0.0) AND
(@firmalar='' or kon_firmano   in (select FirmaNo from FirmaList)) AND
(@SomStr  ='' or kon_cari_srm_merkez in (select SrmMrk  from SrmMrkList)) AND
(@ProjeStr='' or kons_projekodu in (select Proje   from ProjeList)) AND
(@PlasiyerStr='' or kon_satici_kod in (select Plasiyer   from PlasiyerList))
-- Fason fişleri
UNION ALL
SELECT
16,
sth_RECno,
sth_RECid_DBCno,
sth_RECid_RECno,
CariTipi,
CariKodu,
CariGrupNo,
CariDovizCinsi,
CariMuhKodu,
AnaCariKodu,
CariKodu,
cast(6 as tinyint),
sth_tarih,
sth_evraktip,
SHEvrIsim,
sth_cins,
SHCinsIsim,
sth_evrakno_seri,
sth_evrakno_sira,
sth_satirno,
sth_belge_tarih,
sth_belge_no,
sth_firmano,
sth_cari_srm_merkezi,
sth_proje_kodu,
sth_plasiyer_kodu,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (0,2) THEN STH_VERGILI_NET_DEGER_ANA ELSE 0 END,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (1,2) THEN STH_VERGILI_NET_DEGER_ANA ELSE 0 END,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (0,2) THEN STH_VERGILI_NET_DEGER_ALT ELSE 0 END,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (1,2) THEN STH_VERGILI_NET_DEGER_ALT ELSE 0 END,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (0,2) THEN STH_VERGILI_NET_DEGER_CARI_ORJ ELSE 0 END,
CASE WHEN STH_CARI_BORC_ALACAK_TIP in (1,2) THEN STH_VERGILI_NET_DEGER_CARI_ORJ ELSE 0 END,
STH_HAR_DOVIZ_SEMBOLU
FROM dbo.STOK_HAREKETLERI_VIEW_WITH_INDEX_03 WITH (NOLOCK)
INNER JOIN dbo.#CariListesi ON CariTipi=0 AND CariKodu=sth_cari_kodu AND CariGrupNo=0
LEFT OUTER JOIN dbo.vw_Stok_Hareket_Evrak_Isimleri SHEVRAK ON SHEvrNo=sth_evraktip
LEFT OUTER JOIN dbo.vw_Stok_Hareket_Cins_Isimleri  SHCINS  ON SHCinsNo=sth_cins
WHERE (@Fasonlar=1)AND
(sth_tarih between @ilktar and @sontar) AND
(sth_evraktip in (0,12,14)) AND (sth_cins=8) AND (sth_fat_recid_recno=0) AND
(@firmalar='' or sth_firmano   in (select FirmaNo from FirmaList)) AND
(@SomStr  ='' or sth_cari_srm_merkezi in (select SrmMrk  from SrmMrkList)) AND
(@ProjeStr='' or sth_proje_kodu in (select Proje   from ProjeList)) AND
(@PlasiyerStr='' or sth_plasiyer_kodu in (select Plasiyer   from PlasiyerList))
)AS HCH
declare @donemicistr as nvarchar(50)
set @donemicistr = dbo.fn_ResourceSplit('P',2238,1,DEFAULT)
if @FirmaDetayli   =0 update #CARI_HAREKETLERI set FIRMANO=-1
if @SomDetayli     =0 update #CARI_HAREKETLERI set SRM_MRK=''
if @ProjeDetayli   =0 update #CARI_HAREKETLERI set PROJE=''
if @PlasiyerDetayli=0 update #CARI_HAREKETLERI set PLASIYER=''
if @CariHareketDetayli=0 update #CARI_HAREKETLERI set EVRAKSATIR=0,EVRAKCINSNO=EVRAKTIPNO,EVRAKCINSISIM=EVRAKTIPISIM
if @BaglantiliCari = 2 update #CARI_HAREKETLERI set CARI_KODU=ANA_CARI_KODU
if @SadeceToplamlar=1  update #CARI_HAREKETLERI
set TABLONO=0,
RECNO=0,
BAKIYE_TIP=0,
TARIH=@sontar,
EVRAKTIPNO=0,
EVRAKTIPISIM=@donemicistr,
EVRAKCINSNO=0,
EVRAKCINSISIM=@donemicistr,
EVRAKSERI='',
EVRAKSIRA=0,
EVRAKSATIR=0,
BELGETARIH=@sontar,
BELGENO=''
where TARIH > @devirtarihi
select
*,
/*YARDIMCI KOLONLAR*/
CAST(0 AS float) as ANA_TUTAR,
CAST(0 AS float) as ALT_TUTAR,
CAST(0 AS float) as ORJ_TUTAR,
CAST(0 AS float) as GununKuru,
CAST(0 AS tinyint) as Donem
into #CARI_EXTRE_HAREKETLERI
from #CARI_HAREKETLERI
where 1=0
declare @kurhesapsekli as tinyint
set @kurhesapsekli = (select KurHesaplamaSekli from dbo.vw_Gendata)
if not(@kurhesapsekli in (1,2,3,4))
set @kurhesapsekli=1
select
CARI_DOVIZ AS GununDovizCinsi,
dbo.fn_KurBul(0,CARI_DOVIZ,@kurhesapsekli) as GununDovizKuru
into #GUNUN_DOVIZ_KURLARI
from #CARI_HAREKETLERI
group by CARI_DOVIZ
declare @GununAltDovizKuru float
set @GununAltDovizKuru = dbo.fn_KurBul(0,dbo.fn_FirmaAlternatifDovizCinsi(),@kurhesapsekli)
declare @devirstr as nvarchar(50)
set @devirstr = dbo.fn_GetResource('P',1260,DEFAULT)
declare @toplamstr as nvarchar(50)
set @toplamstr = dbo.fn_GetResource('E',1649,DEFAULT)
if @Devreden=1
INSERT INTO #CARI_EXTRE_HAREKETLERI
SELECT
0,
0,
0,
0,
CARI_TIPI,
CARI_KODU,
CARI_GRUPNO,
CARI_DOVIZ,
MAX(CARI_MUH_KODU),
MAX(ANA_CARI_KODU),
CARI_KODU,
0,
@devirtarihi,
0,
@devirstr,
0,
@devirstr,
'',
0,
0,
@devirtarihi,
'',
FIRMANO,
SRM_MRK,
PROJE,
PLASIYER,
SUM(ANA_BORC),
SUM(ANA_ALACAK),
SUM(ALT_BORC),
SUM(ALT_ALACAK),
SUM(ORJ_BORC),
SUM(ORJ_ALACAK),
ORJ_DOVIZ_SEMBOLU,
/*YARDIMCI KOLONLAR*/
SUM(ANA_BORC)-SUM(ANA_ALACAK) AS ANA_TUTAR,
SUM(ALT_BORC)-SUM(ALT_ALACAK) AS ALT_TUTAR,
SUM(ORJ_BORC)-SUM(ORJ_ALACAK) AS ORJ_TUTAR,
(select top 1 GununDovizKuru from #GUNUN_DOVIZ_KURLARI where GununDovizCinsi=CARI_DOVIZ),
CAST(0 AS tinyint)
FROM #CARI_HAREKETLERI
WHERE TARIH <= @devirtarihi
GROUP BY TABLONO,CARI_TIPI,CARI_KODU,CARI_GRUPNO,CARI_DOVIZ,FIRMANO,
SRM_MRK,PROJE,PLASIYER,ORJ_DOVIZ_SEMBOLU
INSERT INTO #CARI_EXTRE_HAREKETLERI
SELECT
TABLONO,
MIN(RECNO),
0,
0,
CARI_TIPI,
CARI_KODU,
CARI_GRUPNO,
CARI_DOVIZ,
CARI_MUH_KODU,
ANA_CARI_KODU,
MAX(GERCEK_CARI_KODU),
BAKIYE_TIP,
TARIH,
EVRAKTIPNO,
EVRAKTIPISIM,
EVRAKCINSNO,
EVRAKCINSISIM,
EVRAKSERI,
EVRAKSIRA,
EVRAKSATIR,
BELGETARIH,
BELGENO,
FIRMANO,
SRM_MRK,
PROJE,
PLASIYER,
SUM(ANA_BORC),
SUM(ANA_ALACAK),
SUM(ALT_BORC),
SUM(ALT_ALACAK),
SUM(ORJ_BORC),
SUM(ORJ_ALACAK),
ORJ_DOVIZ_SEMBOLU,
/*YARDIMCI KOLONLAR*/
SUM(ANA_BORC)-SUM(ANA_ALACAK) AS ANA_TUTAR,
SUM(ALT_BORC)-SUM(ALT_ALACAK) AS ALT_TUTAR,
SUM(ORJ_BORC)-SUM(ORJ_ALACAK) AS ORJ_TUTAR,
(select top 1 GununDovizKuru from #GUNUN_DOVIZ_KURLARI where GununDovizCinsi=CARI_DOVIZ),
CAST(1 AS tinyint)
FROM #CARI_HAREKETLERI
WHERE TARIH > @devirtarihi
GROUP BY TABLONO,CARI_TIPI,CARI_KODU,CARI_GRUPNO,CARI_DOVIZ,CARI_MUH_KODU,ANA_CARI_KODU,BAKIYE_TIP,TARIH,FIRMANO,
EVRAKTIPNO,EVRAKTIPISIM,EVRAKCINSNO,EVRAKCINSISIM,EVRAKSERI,EVRAKSIRA,EVRAKSATIR,BELGETARIH,BELGENO,
SRM_MRK,PROJE,PLASIYER,ORJ_DOVIZ_SEMBOLU
SELECT
ItemNumber-1 AS BTipNo,
cast(Item as nvarchar(50)) AS BTipIsim
into #BAKIYE_TURLERI
FROM dbo.SplitToItems(dbo.fn_GetResource('E',1649,DEFAULT)+','+
dbo.fn_GetResource('R',1401,DEFAULT)+','+
dbo.fn_GetResource('F',2424,DEFAULT)+','+
dbo.fn_ResourceSplit('A',119,15,DEFAULT), ',')
select
[#msg_S_1169] AS [#msg_S_0088],
ROW_NUMBER ( ) OVER(ORDER BY CARI_TIPI,CARI_KODU,CARI_GRUPNO,Donem,
TARIH,BAKIYE_TIP,EVRAKTIPNO,EVRAKSERI,EVRAKSIRA,EVRAKSATIR,
SRM_MRK,PROJE,PLASIYER) as [#msg_S_0157],/*SIRA NO*/
TABLONO as [#msg_S_1222], /* TABLO NO*/
RECNO   as [#msg_S_1225], /* KAYIT NUMARASI*/
CCinsIsim      as [#msg_S_4234], /* CARİ TİPİ */
CARI_KODU      as [msg_S_0200], /* CARİ KODU */
[msg_S_1033],                   /* CARI ÜNVANI */
[msg_S_1034] AS [#msg_S_1034], /* CARI ÜNVANI 2 */
ANA_CARI_KODU AS [#msg_S_1037], /* ANA CARİ KODU*/
ANACARI.cari_unvan1 AS [#msg_S_4287] , /* ANA CARİ İSMİ*/
GERCEK_CARI_KODU AS [#msg_S_4400], /* HAREKETİN CARİ KODU*/
GERCEKCARI.cari_unvan1 AS [#msg_S_4401], /* HAREKETİN CARİ İSMİ*/
[#msg_S_0077]                  /* BAĞLANTI TİPİ  */ ,
[msg_S_1029] AS [#msg_S_1029], /* VD.NO */
[msg_S_1028] AS [#msg_S_1028], /* VD.ADI */
[msg_S_0471] AS [#msg_S_0471], /* CARİ GRUP KODU */
[msg_S_0472] AS [#msg_S_0472], /*CARİ GRUP İSMİ */
[msg_S_0473] AS [#msg_S_0473], /* BÖLGE KODU */
[msg_S_1101] AS [#msg_S_1101], /* CARİ BÖLGE İSMİ */
[msg_S_0474] AS [#msg_S_0474], /* CARİ SEKTÖR KODU */
[msg_S_0475] AS [#msg_S_0475], /* CARİ SEKTÖR İSMİ */
[msg_S_0977] AS [#msg_S_0977], /* TEMSİLCİ KODU*/
[msg_S_0978] AS [#msg_S_0978], /* TEMSİLCİ ADI */
CARI_GRUPNO  AS [msg_S_1712], /* CARİ HESAP GRUP NO*/
CARI_MUH_KODU AS [#msg_S_0044], /* MUHASEBE KODU*/
dbo.fn_UstHesapKodu(CARI_MUH_KODU,1,1) AS [#msg_S_0151], /* ANA HESAP */
ORJ_DOVIZ_SEMBOLU AS [msg_S_0308],/*CARİ DÖVİZ CİNSİ*/
TARIH AS [msg_S_0089], /*TARİH */
BTipIsim AS [#msg_S_0716],/* HAREKET TİP */
EVRAKTIPNO AS [#msg_S_1720], /* TİP NO */
EVRAKTIPISIM  AS [msg_S_0094], /* EVRAK TİPİ */
EVRAKCINSNO AS [#msg_S_4321], /* CİNS NO */
EVRAKCINSISIM AS [#msg_S_0158], /* HAREKET CİNSİ */
EVRAKSERI AS [msg_S_0090], /*SERİ*/
EVRAKSIRA AS [msg_S_0091], /*SIRA*/
EVRAKSATIR AS [msg_S_0671],/* EVRAK SATIR NO */
BELGETARIH AS [msg_S_0092], /*BELGE TARİHİ*/
BELGENO AS [msg_S_0093], /* BELGE NO */
CASE WHEN FIRMANO>=0 THEN fir_unvan ELSE @toplamstr END AS [#msg_S_0516], /*FİRMA ADI*/
SRM_MRK      AS [#msg_S_0118], /*SORUMLULUK MERKEZİ KODU*/
som_isim     AS [#msg_S_0119], /*SORUMLULUK MERKEZİ İSMİ*/
PROJE        AS [#msg_S_0116], /*PROJE KODU*/
pro_adi      AS [#msg_S_0117], /*PROJE ADI*/
PLASIYER     AS [#msg_S_1129], /*SORUMLU KODU*/
cari_per_adi AS [#msg_S_1130], /*SORUMLU İSMİ*/
ANA_BORC     AS [msg_S_0101], /*ANA DÖVİZ BORÇ*/
ANA_ALACAK   AS [msg_S_0102], /*ANA DÖVİZ ALACAK*/
ANA_TUTAR    AS [#msg_S_0103], /*ANA DÖVİZ TUTAR*/
CAST(0 AS float) AS [msg_S_1706], /*ANA DÖVİZ BORÇ BAKİYE*/
CAST(0 AS float) AS [msg_S_1707], /*ANA DÖVİZ ALACAK BAKİYE*/
ALT_BORC     AS [msg_S_0105], /*ALTERNATİF DÖVİZ BORÇ*/
ALT_ALACAK   AS [msg_S_0106], /*ALTERNATİF DÖVİZ ALACAK*/
ALT_TUTAR    AS [#msg_S_0107], /*ALTERNATİF DÖVİZ TUTAR*/
CAST(0 AS float) AS [msg_S_1708], /*ALTERNATİF DÖVİZ BORÇ BAKİYE*/
CAST(0 AS float) AS [msg_S_1709], /*ALTERNATİF DÖVİZ ALACAK BAKİYE*/
ALT_TUTAR*@GununAltDovizKuru AS [#msg_S_4289 msg_S_0107], /*BUGÜNKÜ KUR İLE ALTERNATİF DÖVİZ TUTAR*/
(ALT_TUTAR*@GununAltDovizKuru)-ANA_TUTAR AS [#msg_S_4291], /*ALTERNATİF DÖVİZ KUR FARKI*/
ORJ_DOVIZ_SEMBOLU AS [msg_S_0849],/*DÖVİZ CİNSİ*/
ORJ_BORC     AS [msg_S_0109], /*ORJİNAL DÖVİZ BORÇ*/
ORJ_ALACAK   AS [msg_S_0110], /*ORJİNAL DÖVİZ ALACAK*/
ORJ_TUTAR    AS [#msg_S_0111], /*ORJİNAL DÖVİZ TUTAR*/
CAST(0 AS float) AS [msg_S_1710], /*ORJINAL DÖVİZ BORÇ BAKİYE*/
CAST(0 AS float) AS [msg_S_1711], /*ORJINAL DÖVİZ ALACAK BAKİYE*/
GununKuru AS [#msg_S_4290],/*BUGÜNKÜ KUR*/
ORJ_TUTAR*GununKuru AS [#msg_S_4289 msg_S_0111], /*BUGÜNKÜ KUR İLE ORJİNAL DÖVİZ TUTAR*/
(ORJ_TUTAR*GununKuru)-ANA_TUTAR AS [#msg_S_4292] /*ORJİNAL DÖVİZ KUR FARKI*/
into #CARI_EXTRE_FOYU
from #CARI_EXTRE_HAREKETLERI
left outer join dbo.CARIDETAY on [msg_S_1032]=CARI_KODU
left outer join dbo.CARI_HESAPLAR ANACARI ON ANACARI.cari_kod=ANA_CARI_KODU
left outer join dbo.CARI_HESAPLAR GERCEKCARI ON GERCEKCARI.cari_kod=GERCEK_CARI_KODU
left outer join dbo.vw_Cari_Cins_Isimleri ON CCinsNo=CARI_TIPI
left outer join dbo.SORUMLULUK_MERKEZLERI_TANIMSIZ on som_kod=SRM_MRK
left outer join dbo.PROJELER_TANIMSIZ on pro_kodu=PROJE
left outer join dbo.CARI_PERSONEL_TANIMLARI_TANIMSIZ on cari_per_kod=PLASIYER
left outer join dbo.FIRMALAR ON fir_sirano=FIRMANO
left outer join #BAKIYE_TURLERI ON BTipNo=BAKIYE_TIP
select
ROW_NUMBER ( ) OVER(ORDER BY [msg_S_0200],[msg_S_1712])as crowno,
[msg_S_0200] as ckod,
[msg_S_1712] as cgrup
into #CARIGRUPLISTESI
from #CARI_EXTRE_FOYU
GROUP BY [msg_S_0200],[msg_S_1712]
declare @carino as integer
declare @soncarino as integer
declare @extrecarikod as nvarchar(25)
declare @extrecarigrup as tinyint
declare @extrecaribakiyeana as float
declare @extrecaribakiyealt as float
declare @extrecaribakiyeorj as float
set @carino = 1
set @soncarino = (select max(crowno) from #CARIGRUPLISTESI)
while @carino <= @soncarino
begin
set @extrecaribakiyeana = 0.0
set @extrecaribakiyealt = 0.0
set @extrecaribakiyeorj = 0.0
set @extrecarikod = ''
set @extrecarigrup = 0
select @extrecarikod = ckod, @extrecarigrup = cgrup from #CARIGRUPLISTESI where crowno=@carino
UPDATE CEF SET @extrecaribakiyeana = @extrecaribakiyeana + [#msg_S_0103],
@extrecaribakiyealt = @extrecaribakiyealt + [#msg_S_0107],
@extrecaribakiyeorj = @extrecaribakiyeorj + [#msg_S_0111],
[msg_S_1706] = case when @extrecaribakiyeana >=0.0 then abs(@extrecaribakiyeana) else null end ,
[msg_S_1707] = case when @extrecaribakiyeana < 0.0 then abs(@extrecaribakiyeana) else null end ,
[msg_S_1708] = case when @extrecaribakiyealt >=0.0 then abs(@extrecaribakiyealt) else null end ,
[msg_S_1709] = case when @extrecaribakiyealt < 0.0 then abs(@extrecaribakiyealt) else null end ,
[msg_S_1710] = case when @extrecaribakiyeorj >=0.0 then abs(@extrecaribakiyeorj) else null end ,
[msg_S_1711] = case when @extrecaribakiyeorj < 0.0 then abs(@extrecaribakiyeorj) else null end
FROM #CARI_EXTRE_FOYU CEF
WHERE [msg_S_0200]=@extrecarikod and [msg_S_1712]=@extrecarigrup
SET @carino = @carino + 1
end
select * from #CARI_EXTRE_FOYU order by [#msg_S_0157]
END