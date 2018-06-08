--UPDATE [CARI_HESAPLAR]
--SET cari_special2='ENTG' , cari_temsilci_kodu='', cari_bolge_kodu=''
select chbakiye.bakiye,* 
FROM [CARI_HESAPLAR] ch
OUTER APPLY (select dbo.fn_CariHesapBakiye('',0,ch.cari_kod,'','',0,0) as bakiye) as chbakiye
WHERE ch.cari_sektor_kodu ='NS'
and (chbakiye.bakiye<0.25 AND chbakiye.bakiye>-0.25)
 
 -- adr_temsilci_kodu=NULL,adr_ziyaretperyodu=NULL ,adr_ziyaretgunu=NULL
 --INNER JOIN [CARI_PERSONEL_TANIMLARI] as cpt
 --on ch.adr_temsilci_kodu = cpt.cari_per_kod
 --cpt.cari_takvim_kodu='NS'     --?
 