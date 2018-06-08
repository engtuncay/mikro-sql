DECLARE @srmkodu as nvarchar(50)
DECLARE @stkodu as nvarchar(50)
DECLARE @chacinsi as tinyint 
DECLARE @chatip as tinyint 
DECLARE @chaevraktip as tinyint  
DECLARE @tarih as nvarchar(10)
DECLARE @tarih2 as nvarchar(10)
DECLARE @chacaricins as tinyint 
DECLARE @chakasahizmet as tinyint  

SET @srmkodu='KENT'
SET @stkodu='002'
--
SET @chacinsi = 5
SET @chaevraktip= 32
SET @chatip = 0
--
SET @tarih ='20150101'
--cari kart detayı için
SET @chacaricins=0
SET @chakasahizmet=3

--
SET @tarih2 ='20150831'

-- GÜNLÜK MÜŞTERİ CARİ HAREKET DÖKÜM - GRUPLAMA YOK
select CONVERT(VARCHAR,chh.cha_tarihi,112) AS TARIH
,cha_cinsi,cha_evrak_tip,cha_tip,cha_cari_cins,cha_kasa_hizmet,chh.cha_kasa_hizkod
,chh.cha_RECno,chh.cha_RECid_DBCno,chh.cha_RECid_RECno --key
,cast(cha_kod as varchar) as cha_kod
,cast(ch.cari_unvan1 as varchar) as cari_unvan1
,chh.cha_meblag
,cast(chh.cha_evrakno_seri as varchar) as cha_evrakno_seri
,cast(chh.cha_evrakno_sira as varchar) as cha_evrakno_sira
--,chh.cha_srmrkkodu
,cast(chh.cha_satici_kodu as varchar) as cha_satici_kodu
,CONVERT(VARCHAR,chh.cha_belge_tarih,112) AS BelgeTarih
,CONVERT(VARCHAR,chh.cha_lastup_date,112) AS Songüncelleme
--,chh.cha_aciklama,chh.cha_belge_no
from [CARI_HESAP_HAREKETLERI] chh
LEFT JOIN [CARI_HESAPLAR] ch ON chh.cha_kod = ch.cari_kod
where chh.cha_iptal=0 
and chh.cha_srmrkkodu=@srmkodu 
--and chh.cha_satici_kodu=@stkodu
and chh.cha_cinsi=@chacinsi
--and chh.cha_tip=@chatip
and chh.cha_evrak_tip=@chaevraktip
and CONVERT(VARCHAR,cha_tarihi,112)>=@tarih
and CONVERT(VARCHAR,cha_tarihi,112)<=@tarih2
--and chh.cha_evrakno_seri = 'ELEMAN'
--and chh.cha_evrakno_sira = 1
--and chh.cha_cari_cins = @chacaricins and chh.cha_kasa_hizmet = @chakasahizmet
order by chh.cha_satici_kodu

