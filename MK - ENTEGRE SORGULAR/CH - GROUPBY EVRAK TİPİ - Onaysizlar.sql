DECLARE @srmkodu as nvarchar(50)
DECLARE @stkodu as nvarchar(50)
DECLARE @chacinsi as tinyint 
DECLARE @chatip as tinyint 
DECLARE @chaevraktip as tinyint  
DECLARE @tarih as nvarchar(10)

SET @srmkodu='DOGUS'
SET @tarih ='20150729'

--ek ayarlar
SET @chatip = 1
SET @chacinsi = 19 
SET @chaevraktip= 1
SET @stkodu='002'

-- GÜNLÜK ONAYSIZ TAHSİLAT DÖKÜMÜ
select chh.cha_cinsi,chh.cha_evrak_tip,chh.cha_tip,chh.cha_tarihi
--,cha_cari_cins,cha_kasa_hizmet
,sum(chh.cha_meblag)--,ch.cari_unvan1,chh.cha_evrakno_seri,chh.cha_evrakno_sira
,dl.opronay
from [CARI_HESAP_HAREKETLERI] chh
LEFT JOIN [CARI_HESAPLAR] ch ON chh.cha_kod = ch.cari_kod
LEFT JOIN [XOZ_MODDEVIR_LOG] dl ON dl.cha_cinsi= chh.cha_cinsi and dl.cha_evrak_tip= chh.cha_evrak_tip and
dl.cha_tip = chh.cha_tip and dl.somkod = chh.cha_srmrkkodu and dl.tarih= chh.cha_tarihi
where chh.cha_iptal=0 
and chh.cha_srmrkkodu = @srmkodu
and CONVERT(VARCHAR,cha_tarihi,112)>@tarih
and ( dl.opronay=0 OR dl.opronay is null)
--and chh.cha_tip=@chatip
--and chh.cha_satici_kodu=@stkodu
group by chh.cha_evrak_tip,chh.cha_cinsi,chh.cha_tip,dl.opronay,chh.cha_tarihi
--,cha_cari_cins,cha_kasa_hizmet
order by chh.cha_tip,chh.cha_cinsi,chh.cha_evrak_tip
