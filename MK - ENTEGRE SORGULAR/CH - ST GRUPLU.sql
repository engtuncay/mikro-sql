DECLARE @srmkodu as nvarchar(50)
DECLARE @stkodu as nvarchar(50)
DECLARE @chacinsi as tinyint 
DECLARE @chatip as tinyint 
DECLARE @chaevraktip as tinyint  
DECLARE @tarih as nvarchar(10)

SET @srmkodu='DOGUS'
SET @stkodu='002'
SET @chacinsi = 19 
SET @chatip = 1
SET @chaevraktip= 1
SET @tarih ='20150803'

-- GÜNLÜK TAHSİLAT DÖKÜM - STA GRUPLU
select CONVERT(VARCHAR,chh.cha_tarihi,112) AS TARIH
,cast(chh.cha_satici_kodu as varchar) as cha_satici_kodu,cast(cp.cari_per_adi as varchar) as cari_per_adi
,sum(chh.cha_meblag) as meblag
from [CARI_HESAP_HAREKETLERI] chh
LEFT JOIN [CARI_HESAPLAR] ch ON chh.cha_kod = ch.cari_kod
LEFT JOIN [CARI_PERSONEL_TANIMLARI] cp on chh.cha_satici_kodu = cp.cari_per_kod
where chh.cha_iptal=0 
and chh.cha_srmrkkodu=@srmkodu
and chh.cha_cinsi=@chacinsi
and chh.cha_tip=@chatip
and chh.cha_evrak_tip=@chaevraktip
and CONVERT(VARCHAR,cha_tarihi,112)=@tarih
group by chh.cha_tarihi,chh.cha_satici_kodu,cp.cari_per_adi


