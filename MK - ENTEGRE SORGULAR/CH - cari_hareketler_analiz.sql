USE MikroDB_V15_OZPAS

select cha_cinsi,cha_evrak_tip,cha_tip,chh.[cha_normal_Iade],cha_cari_cins,cha_kasa_hizmet,count(cha_cinsi),count(cha_RECno),max(cha_kod),max(ch.cari_unvan1),max(chh.cha_evrakno_seri),max(chh.cha_evrakno_sira)
from [CARI_HESAP_HAREKETLERI] chh
LEFT JOIN [CARI_HESAPLAR] ch ON chh.cha_kod = ch.cari_kod
group by cha_evrak_tip,cha_cinsi,cha_tip,cha_cari_cins,cha_kasa_hizmet,cha_cinsi, cha_evrak_tip, cha_tip, chh.[cha_normal_Iade], cha_cari_cins, cha_kasa_hizmet
order by cha_cinsi,cha_evrak_tip,cha_tip

 