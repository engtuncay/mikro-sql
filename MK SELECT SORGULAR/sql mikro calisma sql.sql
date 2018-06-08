-- Mikro Calisma ****SELECT**** Sql Sorgular (select) id:tqs901
-- USE MikroDB_V15_OZPASTEST
-- TOAD KISAYOLLAR
-- CTRL + K , ctrl + C -> comment , yorum ekler 
-- CTRL + K , ctrl + U -> uncomment , yorum kaldırır
-- CTRL + shift + u -> upper case , büyük harf
-- CTRL + shift + l -> lower case , küçük harf
-- Execute Sql F5
-- Execute Current Statement F9

-- MIKRO SQL SERVER SELECT SORGULAR
-- GENEL AMAÇLI DEĞİŞKENLER

DECLARE @evrakseri varchar(10)
SET @evrakseri='NS' 

DECLARE @evraksira as varchar(10)
SET @evraksira = '11710746' --:w2

DECLARE @chaevraktip as varchar(5)
SET @chaevraktip= '1'

DECLARE @carikod as varchar(20)
SET @carikod='DG00181' -- AKMARKET SHOP

DECLARE @srmkodu as nvarchar( 20)


DECLARE @islemtipid as tinyint
SET @islemtipid = 23 --:islemtipid --kredikartı

DECLARE @tarih as varchar( 9)
SET @tarih = '20161001' --:tarih

DECLARE @tarih2 as varchar( 9)
SET @tarih2 = '20161031' --:tarih

-- ***** CARI HESAPLAR TABLOSU SQL SELECT SORGULAR
--select * from [CARI_HESAPLAR] where cari_kod=@carikod
--select DISTINCT cari_grup_kodu from [CARI_HESAPLAR]
--select * from [XOZ_CARI_GRUPLAR]

-- ***** FARKLI CARI GRUPLARI
--select distinct cari_grup_kodu from [CARI_HESAPLAR] where cari_grup_kodu!=''

-- ***** CARI HESAP HAREKETLERI EVRAK KONTROL
-- --evrak var mı yok mu kontrolü
--SELECT count(cha_RECno) FROM CARI_HESAP_HAREKETLERI WITH (NOLOCK) WHERE cha_evrakno_seri=@evrakseri 
--and cha_evrakno_sira=@evraksira and cha_evrak_tip=@chaevraktip

--** CARI HESAP HAREKETLERİ - EVRAK İNCELEME - islemtipid ye göre listeler
select --distinct 
chh.cha_evrak_tip,chh.cha_cinsi,chh.cha_tip,chh.[cha_normal_Iade]
,chh.cha_satir_no,chh.cha_evrakno_seri,chh.cha_evrakno_sira
,chh.cha_meblag,ci.aciklama,chh.cha_tarihi,*
FROM [CARI_HESAP_HAREKETLERI] chh
LEFT JOIN [XOZ_CARIHAREKETCINSDETAY] ci ON ci.cinsi = chh.cha_cinsi
and ci.evraktip= chh.cha_evrak_tip and ci.cha_tip =chh.cha_tip 
and ci.[cha_normal_Iade] = chh.[cha_normal_Iade]
--LEFT JOIN [CARI_HESAPLAR] ch ON chh.cha_kod = ch.cari_kod
--LEFT JOIN [CARI_PERSONEL_TANIMLARI] cp on chh.cha_satici_kodu = cp.cari_per_kod
WHERE chh.cha_iptal= 0 -- iptal olmayanlar
--and cha_tarihi= @tarih
and ci.chaislemid= '31'
--and chh.cha_satir_no=0
--and cha_evrakno_seri='KR'
--and cha_evrakno_sira='39630'


--select --distinct 
--chh.cha_evrak_tip,chh.cha_satir_no,chh.cha_evrakno_seri,chh.cha_evrakno_sira,ci.aciklama,chh.cha_tarihi,*,chh.cha_meblag
--FROM [CARI_HESAP_HAREKETLERI] chh
--LEFT JOIN [XOZ_CARIHAREKETCINSDETAY] ci ON ci.cinsi = chh.cha_cinsi
--and ci.evraktip= chh.cha_evrak_tip and ci.cha_tip =chh.cha_tip 
--and ci.[cha_normal_Iade] = chh.[cha_normal_Iade]
----LEFT JOIN [CARI_HESAPLAR] ch ON chh.cha_kod = ch.cari_kod
----LEFT JOIN [CARI_PERSONEL_TANIMLARI] cp on chh.cha_satici_kodu = cp.cari_per_kod
--WHERE chh.cha_iptal= 0 -- iptal olmayanlar
----and cha_tarihi= @tarih
--and ci.chaislemid= @islemtipid
----and chh.cha_satir_no=0
--and cha_evrakno_seri=@evrakseri 
--and cha_evrakno_sira=@evraksira

-- ** TAHSILAT TOPLAMI (işlem id ye göre)
--select --distinct 
--ci.chaislemid,sum(chh.cha_meblag),cp.cari_per_adi,chh.cha_srmrkkodu,cp.cari_per_kod
----chh.cha_evrak_tip,chh.cha_satir_no,chh.cha_evrakno_seri,chh.cha_evrakno_sira,ci.aciklama,chh.cha_tarihi,*,chh.cha_meblag
--FROM [CARI_HESAP_HAREKETLERI] chh
--LEFT JOIN [XOZ_CARIHAREKETCINSDETAY] ci 
--ON ci.cinsi = chh.cha_cinsi and ci.evraktip= chh.cha_evrak_tip and ci.cha_tip =chh.cha_tip 
--and ci.[cha_normal_Iade] = chh.[cha_normal_Iade]
----LEFT JOIN [CARI_HESAPLAR] ch ON chh.cha_kod = ch.cari_kod
--LEFT JOIN [CARI_PERSONEL_TANIMLARI] cp on chh.cha_satici_kodu = cp.cari_per_kod
--WHERE chh.cha_iptal= 0 -- iptal olmayanlar
--and chh.cha_tarihi>= @tarih
--and chh.cha_tarihi<= @tarih2
----and ci.chaislemid IN (1,2,4,23)
----and cp.cari_per_kod = '002'
--GROUP BY ci.chaislemid,cp.cari_per_adi,chh.cha_srmrkkodu,cp.cari_per_kod
--ORDER BY chh.cha_srmrkkodu,cp.cari_per_kod



-- **EVRAK TIPINE GÖRE HAREKETLER
--SELECT TOP 100 * FROM [CARI_HESAP_HAREKETLERI] WHERE cha_evrak_tip=1

-- **** CARI PERSONEL - SATIŞ TEMSİLCİSİ
--select top 10 cari_takvim_kodu,* from [CARI_PERSONEL_TANIMLARI]
--select DISTINCT cari_takvim_kodu from [CARI_PERSONEL_TANIMLARI]


-- ***** XOZ
--SELECT TOP 100 * FROM [XOZ_KREDIKARTIONAY] --WHERE cha_evrakno_seri=@evrakseri 
--and cha_evrakno_sira=@evraksira 

select * from [XOZ_CARIHAREKETCINSDETAY]

--- PANORAMA

