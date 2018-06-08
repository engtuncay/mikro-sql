-- **** MİKRO EVRAK KONTROL ***

USE MikroDB_V15_OZPAS --MIKROTEST

DECLARE @seri as nvarchar( 50) = ''
DECLARE @sira as nvarchar(50) ='51'  -- 26502399 tahsilat  -- PN 10547750 fatura -- PN 27026855 NAKİT
DECLARE @chh_evraktip as int = 33  -- 0:alış ve iade faturası(0,3) 4:çek tahsilat(müşteri çeki) 63:satış faturası (63,4) 1:nakit,kredi kartı 
--DECLARE @sth_evraktip as int = 4 -- 3:giriş faturası 4:çıkış faturası
--DECLARE @carikod as nvarchar(20) = 'PN327448' -- HİLAL GROSS AVM:PN327448
--DECLARE @stokkod as nvarchar(20) = ''

DECLARE @cha_cinsi as int = (SELECT TOP 1 cha_cinsi FROM CARI_HESAP_HAREKETLERI where cha_evrakno_seri=@seri and cha_evrakno_sira=@sira and cha_evrak_tip=@chh_evraktip )

--SELECT 'BELGE KONTROL'

-- CARİ HAREKETLERİ
SELECT cha_tarihi,cha_evrak_tip,cha_meblag,cha_trefno,cha_cinsi,cha_cari_cins ,* FROM CARI_HESAP_HAREKETLERI where cha_evrakno_seri=@seri and cha_evrakno_sira=@sira --and cha_evrak_tip=@chh_evraktip

-- STOK HAREKETLERİ

-- cha cinsi 6 ise (toptan fatura : alış ve satış faturası , evrak tip :0,63 )
IF @cha_cinsi = 6
BEGIN

SELECT sth_stok_kod,st.sto_isim,sth_miktar,
case sth.sth_birim_pntr when 1 then st.sto_birim1_ad
when 2 then st.sto_birim2_ad
when 3 then st.sto_birim3_ad
when 4 then st.sto_birim4_ad end as birim_ad, sth.sth_tutar / sth.sth_miktar2 as birim_fiyat
,case sth.sth_vergi_pntr 
when 1 then 0
when 2 then 1
when 3 then 8
when 4 then 18
when 5 then 26
end as vergi_oran
,sth_vergi,sth_iskonto1,sth_iskonto2,sth_iskonto3,sth_iskonto4+sth_iskonto5+sth_iskonto6 as iskonto_diger
,sth_tutar + sth.sth_vergi- sth_iskonto1-sth_iskonto2-sth_iskonto3-sth_iskonto4-sth_iskonto5-sth_iskonto6 as net_tutar
--,sth.sth_tarih,sth_tutar  --brut tutar
FROM STOK_HAREKETLERI sth
LEFT JOIN STOKLAR st ON st.sto_kod = sth.sth_stok_kod
where sth_fat_recid_dbcno IN ( SELECT chh.cha_RECid_DBCno from CARI_HESAP_HAREKETLERI chh WHERE cha_evrakno_seri=@seri and cha_evrakno_sira=@sira and cha_evrak_tip=@chh_evraktip ) 
and sth_fat_recid_recno IN ( SELECT chh.cha_RECid_RECno from CARI_HESAP_HAREKETLERI chh WHERE cha_evrakno_seri=@seri and cha_evrakno_sira=@sira and cha_evrak_tip=@chh_evraktip )

END

IF @cha_cinsi = 0 or @cha_cinsi = 1 or @cha_cinsi = 3 or @cha_cinsi = 5 or @cha_cinsi = 19 or @cha_cinsi = 20 or @cha_cinsi = 22 or @cha_cinsi = 8
BEGIN

SELECT chh.cha_evrakno_seri,chh.cha_evrakno_sira,chh.cha_kod
,case chh.cha_cari_cins 
when 0 then 'Cari'
when 1 then 'Cari Per.' 
when 2 then 'Banka'
when 3 then 'Hizmet'
when 4 then 'Kasa'
when 5 then 'Gider'
when 6 then 'Muhasebe'
when 7 then 'Personel'
when 8 then 'Demirbaş'
end as cinsi,
case chh.cha_cari_cins 
when 0 then ch.cari_unvan1  -- 0 cari hesap
when 1 then (select cpt.cari_per_adi from CARI_PERSONEL_TANIMLARI cpt where cpt.cari_per_kod = chh.cha_kod)  -- 1 cari personel
when 2 then (select bk.ban_ismi from BANKALAR bk where bk.ban_kod = chh.cha_kod )  -- 3 banka hesabı
when 3 then (select hs.hiz_isim from HIZMET_HESAPLARI hs where hs.hiz_kod = chh.cha_kod)  -- 3 hizmet hesabı
when 4 then (select ks.kas_isim from KASALAR ks where ks.kas_kod = chh.cha_kod) -- 4 kasa hesabı
when 5 then (select mh.his_isim from MASRAF_HESAPLARI mh where mh.his_kod = chh.cha_kod) -- 5 giderimiz
-- 6 muhasebe hesap
-- 7 personel
-- 8 demirbaş
else 'Tanımlanmayan cari cins' 
end as hesap_isim
,cha_tarihi,case chh.cha_tip when 0 then 'B' when 1 then 'A' end as tip,cha_meblag
FROM CARI_HESAP_HAREKETLERI chh
LEFT JOIN [CARI_HESAPLAR] ch ON ch.cari_kod = chh.cha_kod
Where cha_evrakno_seri=@seri and cha_evrakno_sira=@sira and cha_evrak_tip=@chh_evraktip

END

