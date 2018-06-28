USE MikroDB_V15_OZPAS

-- Faturadaki Maliyet
select sth_evrakno_seri,sth_evrakno_sira,sth_miktar,sth_tarih,sth_stok_kod, st.sto_isim, st.sto_kisa_ismi
,(sth_tutar-sth_iskonto1-sth_iskonto2-sth_iskonto3-sth_iskonto4-sth_iskonto5-sth_iskonto6)/sth_miktar as satisFiyat
,dbo.fn_entstokbirimMaliyetFatura( sth_stok_kod, sth_tarih, sth_miktar) as alisFiyat
from [STOK_HAREKETLERI] sh  
LEFT JOIN STOKLAR st ON st.sto_kod = sh.sth_stok_kod
where sth_evraktip='4' and sth_evrakno_seri='PN' AND sth_evrakno_sira='11644877'

-- Envanter Maliyet
--View, Envanter fonksiyonu olarak farklı bir şey kullanılabilir. 
select sh.sth_stok_kod,st.sto_isim, sh.stokMiktar --,sh.sth_depono
,dbo.fn_entstokbirimMaliyetEnvanter(sth_stok_kod,'20181231',sh.stokMiktar ) as alisFiyat
FROM 
(
select sth_stok_kod,sum(
case when sth_giris_cikis=0 THEN sth_miktar
when sth_giris_cikis=1 THEN sth_miktar*-1 
end) as stokMiktar--,sth_depono
From [STOK_HAREKETLERI_GIRIS_CIKIS] 
WHERE sth_tarih<='20181231'
group by sth_stok_kod--,sth_depono
) as sh
LEFT JOIN STOKLAR st ON st.sto_kod = sh.sth_stok_kod 
WHERE st.sto_sektor_kodu ='PANEK' --and sh.sth_depono = 901
--ORDER BY sth_depono
Order by sto_kod

--Son Durum 
select sto_kod,sto_isim,sto_kisa_ismi,dbo.fn_EldekiMiktar(sto_kod) as miktar,dbo.fn_entstokbirimMaliyetSonDurum(sto_kod) as alisFiyat 
from STOKLAR
where sto_sektor_kodu='PANEK'
order by sto_kod


