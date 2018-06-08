
-- Çeşitli Sorgular

DECLARE @cha_RECno INT = 2018106
DECLARE @evrakseri VARCHAR(10) = 'PN'
DECLARE @evraksira1 INT = 11493973
DECLARE @evraksira2 INT = 11486619

--SELECT cha_belge_tarih,cha_evrak_tip  FROM CARI_HESAP_HAREKETLERI WHERE cha_RECno=@cha_RECno

SELECT cha_belge_tarih,cha_evrak_tip,cha_evrakno_seri,cha_evrakno_sira,*  FROM CARI_HESAP_HAREKETLERI WHERE cha_evrakno_seri=@evrakseri and cha_evrakno_sira IN (@evraksira1,@evraksira2)

select * from CARI_HESAP_HAREKETLERI WHERE cha_evrak_tip='0' and cha_normal_Iade='1'

-- 



